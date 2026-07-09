#!/usr/bin/env bash
set -euo pipefail

VERSION="4.0.0"
TAG="v${VERSION}"
ASSET="zhaoji-clipper-${VERSION}-chrome.zip"
EXPECTED_SHA="016817dc815a6c529480ef5d7a0787311a61ec8dc2193f431d68544ee65636fb"
EXPECTED_SIZE="351659"
ASSET_API="https://api.github.com/repos/AidenXu-1/ZJ-clipper/releases/assets/463992496"
DIRECT_URL="https://github.com/AidenXu-1/ZJ-clipper/releases/download/${TAG}/${ASSET}"

INSTALL_ROOT="${ZJ_CLIPPER_HOME:-$HOME/Applications/ZJ-clipper}"
TARGET="${INSTALL_ROOT}/chrome"
ZIP="${INSTALL_ROOT}/${ASSET}"

file_size() {
  if stat -f%z "$1" >/dev/null 2>&1; then
    stat -f%z "$1"
  else
    stat -c%s "$1"
  fi
}

sha256_file() {
  if command -v shasum >/dev/null 2>&1; then
    LC_ALL=C LANG=C shasum -a 256 "$1" | awk '{print $1}'
  else
    sha256sum "$1" | awk '{print $1}'
  fi
}

download_with_resume() {
  local url="$1"
  local extra_header_1="${2:-}"
  local extra_header_2="${3:-}"

  for attempt in 1 2 3 4 5; do
    local current_size=0
    if [ -f "$ZIP" ]; then
      current_size="$(file_size "$ZIP")"
    fi

    if [ "$current_size" = "$EXPECTED_SIZE" ]; then
      return 0
    fi

    echo "Download attempt ${attempt}, current size: ${current_size}/${EXPECTED_SIZE}"

    if [ -n "$extra_header_1" ] && [ -n "$extra_header_2" ]; then
      curl -C - --connect-timeout 20 --max-time 180 --speed-time 30 --speed-limit 1 \
        --retry 3 --retry-all-errors -fL \
        -H "$extra_header_1" \
        -H "$extra_header_2" \
        "$url" -o "$ZIP" || true
    elif [ -n "$extra_header_1" ]; then
      curl -C - --connect-timeout 20 --max-time 180 --speed-time 30 --speed-limit 1 \
        --retry 3 --retry-all-errors -fL \
        -H "$extra_header_1" \
        "$url" -o "$ZIP" || true
    else
      curl -C - --connect-timeout 20 --max-time 180 --speed-time 30 --speed-limit 1 \
        --retry 3 --retry-all-errors -fL \
        "$url" -o "$ZIP" || true
    fi
  done

  [ -f "$ZIP" ] && [ "$(file_size "$ZIP")" = "$EXPECTED_SIZE" ]
}

main() {
  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required." >&2
    exit 1
  fi

  if ! command -v unzip >/dev/null 2>&1; then
    echo "unzip is required." >&2
    exit 1
  fi

  mkdir -p "$INSTALL_ROOT"

  echo "Installing ZJ Clipper Chrome ${VERSION}"
  echo "Install root: $INSTALL_ROOT"

  echo "Downloading from GitHub API asset endpoint..."
  if ! download_with_resume "$ASSET_API" "Accept: application/octet-stream" "X-GitHub-Api-Version: 2022-11-28"; then
    echo "GitHub API download did not finish. Trying direct release URL..."
    rm -f "$ZIP"
    download_with_resume "$DIRECT_URL" || {
      echo "Download failed." >&2
      exit 1
    }
  fi

  actual_size="$(file_size "$ZIP")"
  if [ "$actual_size" != "$EXPECTED_SIZE" ]; then
    echo "Downloaded file size mismatch: expected $EXPECTED_SIZE, got $actual_size" >&2
    exit 1
  fi

  actual_sha="$(sha256_file "$ZIP")"
  echo "SHA-256: $actual_sha"
  if [ "$actual_sha" != "$EXPECTED_SHA" ]; then
    echo "SHA-256 mismatch. Do not load this extension." >&2
    exit 1
  fi

  if [ -e "$TARGET" ]; then
    backup="${TARGET}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$TARGET" "$backup"
    echo "Existing extension folder backed up to: $backup"
  fi

  mkdir -p "$TARGET"
  unzip -q "$ZIP" -d "$TARGET"

  if [ ! -f "$TARGET/manifest.json" ]; then
    echo "manifest.json not found in $TARGET" >&2
    exit 1
  fi

  echo
  echo "Installed and verified."
  echo
  echo "Open Chrome and load this folder:"
  echo "$TARGET"
  echo
  echo "Chrome steps:"
  echo "1. Open chrome://extensions/"
  echo "2. Enable Developer mode"
  echo "3. Click Load unpacked / 加载未打包的扩展程序"
  echo "4. Select: $TARGET"
}

main "$@"
