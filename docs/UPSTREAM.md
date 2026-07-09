# 来源与同步策略

本仓库对标的唯一官方来源是：

- 来源账号：`AidenXu-1`
- 来源仓库：`AidenXu-1/ZJ-clipper`
- 官方地址：https://github.com/AidenXu-1/ZJ-clipper
- 官方 Release：https://github.com/AidenXu-1/ZJ-clipper/releases

## 为什么只同步信息

上游项目的许可证保留全部权利，未授权复制、修改或分发扩展本体。因此本仓库不提交这些内容：

- Release zip 包。
- 解压后的扩展目录。
- `manifest.json`、`background.js`、`popup.html`、图标等构建产物。
- 上游源码和资源文件。

本仓库只同步这些信息：

- 最新 Release tag。
- Chrome 成品包名称。
- Chrome 成品包下载地址。
- 文件大小。
- SHA-256 校验值。
- 发布时间。
- 上游 Release 页面链接。

## 自动同步方式

仓库包含 GitHub Actions 工作流：

```text
.github/workflows/sync-upstream-release.yml
```

它会：

1. 每天按计划检查官方最新 Release。
2. 读取 Chrome 资产信息。
3. 更新 `upstream/releases/latest.json`。
4. 更新 `checksums/SHA256SUMS.txt`。
5. 更新 `README.md`、`NOTICE.md`、`docs/INSTALL.md` 中的当前版本说明。
6. 如果信息有变化，自动创建或更新一个同步 PR。

这样可以持续对标来源账号，但仍保留人工 review：有新版本时先看 PR，再决定是否合并。

## 手动同步

本地也可以手动同步：

```bash
bash scripts/sync-upstream-release.sh
```

同步完成后检查 diff：

```bash
git diff
```

如果上游发布了新版，确认许可证和 Release 信息无误后再提交。

## 安装脚本如何使用同步信息

`scripts/install-chrome.sh` 会优先读取：

```text
upstream/releases/latest.json
```

如果该文件存在，脚本按其中记录的版本、下载地址、文件大小和 SHA-256 安装。如果元数据文件不存在，则回退到脚本内置的 v4.0.0 信息。

## 更新判断标准

有以下变化时视为需要同步：

- 最新 Release tag 变化。
- Chrome zip 文件名变化。
- Chrome zip 文件大小变化。
- Chrome zip SHA-256 变化。
- Chrome zip 下载地址变化。

如果 SHA-256 变化但 tag 没变，仍然需要人工确认，因为这代表上游替换了同一版本的 Release 资产。
