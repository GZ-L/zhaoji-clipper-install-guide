#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_REPO="${ZJ_CLIPPER_UPSTREAM_REPO:-AidenXu-1/ZJ-clipper}"
META_PATH="$ROOT/upstream/releases/latest.json"
CHECKSUM_PATH="$ROOT/checksums/SHA256SUMS.txt"

mkdir -p "$(dirname "$META_PATH")" "$(dirname "$CHECKSUM_PATH")"

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

if command -v gh >/dev/null 2>&1; then
  gh api "repos/${UPSTREAM_REPO}/releases/latest" > "$tmp_json"
else
  curl -fsSL "https://api.github.com/repos/${UPSTREAM_REPO}/releases/latest" > "$tmp_json"
fi

python3 - "$tmp_json" "$META_PATH" "$CHECKSUM_PATH" "$UPSTREAM_REPO" <<'PY'
import json
import re
import sys
from pathlib import Path

source_path = Path(sys.argv[1])
meta_path = Path(sys.argv[2])
checksum_path = Path(sys.argv[3])
upstream_repo = sys.argv[4]
root = meta_path.parents[2]

release = json.loads(source_path.read_text(encoding="utf-8"))
assets = release.get("assets", [])
chrome_assets = [
    asset for asset in assets
    if re.search(r"chrome\.zip$", asset.get("name", ""), re.IGNORECASE)
]

if not chrome_assets:
    names = ", ".join(asset.get("name", "") for asset in assets)
    raise SystemExit(f"No Chrome zip asset found. Available assets: {names}")

chrome_asset = sorted(chrome_assets, key=lambda asset: asset.get("name", ""))[0]
digest = chrome_asset.get("digest") or ""
sha256 = digest.removeprefix("sha256:") if digest.startswith("sha256:") else digest

if not re.fullmatch(r"[0-9a-fA-F]{64}", sha256):
    raise SystemExit(f"Chrome asset does not expose a valid SHA-256 digest: {digest!r}")

metadata = {
    "schema_version": 1,
    "source": {
        "account": upstream_repo.split("/", 1)[0],
        "repository": upstream_repo,
        "repository_url": f"https://github.com/{upstream_repo}",
        "releases_url": f"https://github.com/{upstream_repo}/releases"
    },
    "release": {
        "tag_name": release.get("tag_name"),
        "name": release.get("name"),
        "html_url": release.get("html_url"),
        "published_at": release.get("published_at"),
        "prerelease": release.get("prerelease", False),
        "draft": release.get("draft", False)
    },
    "chrome_asset": {
        "id": chrome_asset.get("id"),
        "name": chrome_asset.get("name"),
        "size": chrome_asset.get("size"),
        "sha256": sha256.lower(),
        "api_url": chrome_asset.get("url"),
        "browser_download_url": chrome_asset.get("browser_download_url"),
        "content_type": chrome_asset.get("content_type"),
        "created_at": chrome_asset.get("created_at"),
        "updated_at": chrome_asset.get("updated_at")
    }
}

meta_path.write_text(
    json.dumps(metadata, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
    encoding="utf-8",
)

checksum_path.write_text(
    f"{metadata['chrome_asset']['sha256']}  {metadata['chrome_asset']['name']}\n",
    encoding="utf-8",
)

def replace_between(path: Path, start_marker: str, end_marker: str, replacement: str) -> None:
    text = path.read_text(encoding="utf-8")
    start = f"<!-- {start_marker} -->"
    end = f"<!-- {end_marker} -->"
    start_index = text.find(start)
    end_index = text.find(end)
    if start_index == -1 or end_index == -1 or end_index < start_index:
        raise SystemExit(f"Missing marker block in {path}: {start_marker} / {end_marker}")

    end_index += len(end)
    new_text = (
        text[:start_index]
        + start
        + "\n"
        + replacement.rstrip()
        + "\n"
        + end
        + text[end_index:]
    )
    path.write_text(new_text, encoding="utf-8")

tag = metadata["release"]["tag_name"]
release_url = metadata["release"]["html_url"]
asset_name = metadata["chrome_asset"]["name"]
asset_size = metadata["chrome_asset"]["size"]
asset_sha = metadata["chrome_asset"]["sha256"]

replace_between(
    root / "README.md",
    "upstream-current-start",
    "upstream-current-end",
    f"""- 上游仓库：`{upstream_repo}`
- Release：`{tag}`
- 文件：`{asset_name}`
- 文件大小：`{asset_size}` bytes
- SHA-256：`{asset_sha}`
- 官方 Release：{release_url}
- 默认安装目录：`~/Applications/ZJ-clipper/chrome`""",
)

replace_between(
    root / "NOTICE.md",
    "upstream-notice-start",
    "upstream-notice-end",
    f"""- Release used by this guide: `{tag}`
- Chrome asset: `{asset_name}`
- Chrome asset size: `{asset_size}` bytes
- Chrome asset SHA-256: `{asset_sha}`""",
)

replace_between(
    root / "docs" / "INSTALL.md",
    "upstream-manual-install-start",
    "upstream-manual-install-end",
    f"""1. 打开上游 Release 页面：

```text
{release_url}
```

2. 下载：

```text
{asset_name}
```

3. 校验 SHA-256：

```bash
shasum -a 256 {asset_name}
```

结果应为：

```text
{asset_sha}
```""",
)
PY

echo "Synced upstream metadata to $META_PATH"
echo "Updated checksum file at $CHECKSUM_PATH"
