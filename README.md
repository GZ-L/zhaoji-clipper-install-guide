# 兆基 Clipper 安装指南

这是一个面向个人使用的安装说明仓库，用来记录如何安装和使用
[AidenXu-1/ZJ-clipper](https://github.com/AidenXu-1/ZJ-clipper) 的 Chrome 扩展成品包。

重要说明：本仓库不是上游项目源码仓库，也不重新分发扩展源码、解压后的 JS 文件或 zip 包。上游项目采用保留全部权利的许可证，未授权复制或分发软件本体。因此本仓库只保存安装脚本、校验值和使用说明；真正的扩展包会在安装时从上游 GitHub Release 下载。

## 来源账号

本仓库对标的唯一官方来源是：

- 来源账号：`AidenXu-1`
- 来源仓库：`AidenXu-1/ZJ-clipper`
- 官方仓库：https://github.com/AidenXu-1/ZJ-clipper
- 官方 Release：https://github.com/AidenXu-1/ZJ-clipper/releases

本仓库不改名、不二次包装成原创项目，也不保存上游扩展本体。它的定位是：记录来源、提供安装规范、保存校验信息，并从官方 Release 获取安装包。

## 这是什么

兆基 Clipper 是一个中文网页剪藏浏览器扩展，主要用于把网页内容转换成 Markdown，并保存到 Obsidian 仓库。它适合做知识库归档、资料收藏、长文整理和中文内容平台剪藏。

它的工作流程是：

1. 在 Chrome 中打开需要剪藏的网页。
2. 点击扩展图标、使用快捷键，或通过右键菜单触发剪藏。
3. 扩展读取当前页面内容，转换成 Markdown。
4. 在弹窗中预览、编辑标题、标签和正文。
5. 保存到 Obsidian，或在配置后保存到飞书知识库。

## 当前同步版本

本仓库安装脚本默认安装已经同步到本仓库的 Chrome 版：

<!-- upstream-current-start -->
- 上游仓库：`AidenXu-1/ZJ-clipper`
- Release：`v4.0.0`
- 文件：`zhaoji-clipper-4.0.0-chrome.zip`
- 文件大小：`351659` bytes
- SHA-256：`016817dc815a6c529480ef5d7a0787311a61ec8dc2193f431d68544ee65636fb`
- 官方 Release：https://github.com/AidenXu-1/ZJ-clipper/releases/tag/v4.0.0
- 默认安装目录：`~/Applications/ZJ-clipper/chrome`
<!-- upstream-current-end -->

同步元数据保存在：

```text
upstream/releases/latest.json
```

如果上游官方 Release 有更新，仓库的 GitHub Actions 会自动检查并创建同步 PR。合并 PR 后，安装脚本会使用新的版本、文件大小、下载地址和 SHA-256。

## 快速安装

在终端执行：

```bash
git clone https://github.com/GZ-L/zhaoji-clipper-install-guide.git
cd zhaoji-clipper-install-guide
bash scripts/install-chrome.sh
```

脚本会完成：

1. 从上游 Release 下载 Chrome zip 包。
2. 校验文件大小和 SHA-256。
3. 解压到 `~/Applications/ZJ-clipper/chrome`。
4. 如果旧目录已存在，自动备份旧目录。
5. 打印 Chrome 中需要选择的文件夹路径。

脚本不会静默安装 Chrome 扩展。Chrome 出于安全限制，加载本地扩展必须由用户在扩展管理页手动确认。

## 在 Chrome 中加载扩展

脚本完成后，打开 Chrome：

1. 访问 `chrome://extensions/`。
2. 打开右上角「开发者模式」。
3. 点击左上角「加载未打包的扩展程序」。
4. 选择这个文件夹：

```text
/Users/guozhi/Applications/ZJ-clipper/chrome
```

注意：Chrome 中文界面里的「加载未打包的扩展程序」就是英文 `Load unpacked`，也就是常说的「加载已解压的扩展程序」。

## 怎么使用

首次使用建议先配置保存方式：

1. 点击 Chrome 工具栏中的「兆基 Clipper」扩展图标。
2. 进入设置页。
3. 选择保存方式：
   - `obsidian://`：适合快速上手，只需要填写 Obsidian 仓库名。
   - Obsidian Local REST API：适合长文、图片落地和更稳定的本地写入。
   - 飞书知识库：需要配置自己的飞书自建应用和 OAuth 授权。
4. 打开一篇文章或资料页。
5. 点击扩展图标，或使用快捷键 `Command + Shift + S`。
6. 在弹窗中检查标题、标签、正文和保存路径。
7. 点击保存。

更多使用细节见 [docs/USAGE.md](docs/USAGE.md)。

## 效果怎么样

安装后，它能把网页资料整理成更适合 Obsidian 的 Markdown。典型效果包括：

- 保留网页标题、来源 URL、作者、发布时间等元数据。
- 把正文转换成 Markdown，减少侧栏、推荐、广告等干扰内容。
- 支持选区剪藏，只保存你选中的部分内容。
- 支持长文或 thread 的完整抓取入口。
- 对部分中文内容平台和知识平台有专门适配。
- v4.0.0 增加了可选的飞书知识库保存能力。

具体效果和边界见 [docs/EFFECTS.md](docs/EFFECTS.md)。

## 常见问题

如果你在 Chrome 中找不到按钮：

- 先确认 `chrome://extensions/` 右上角「开发者模式」已经打开。
- Chrome 中文界面按钮叫「加载未打包的扩展程序」。
- 不要点「打包扩展程序」。
- 选择的是文件夹，不是 zip 文件。
- 应选择 `~/Applications/ZJ-clipper/chrome`，这个文件夹里必须直接包含 `manifest.json`。

更多排查见 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)。

## 更新同步

本仓库通过 GitHub Actions 对标来源账号 `AidenXu-1`：

1. 每天检查 `AidenXu-1/ZJ-clipper` 的最新 Release。
2. 获取 Chrome 成品包名称、下载地址、文件大小和 SHA-256。
3. 更新 `upstream/releases/latest.json` 和 `checksums/SHA256SUMS.txt`。
4. 如有变化，自动创建或更新同步 PR，等待人工 review 后合并。

这样既能跟进上游更新，又不会复制或重新分发上游扩展本体。

详细规则见 [docs/UPSTREAM.md](docs/UPSTREAM.md)。

## 仓库结构

```text
.
├── .github/
│   └── workflows/
│       └── sync-upstream-release.yml
├── README.md
├── NOTICE.md
├── checksums/
│   └── SHA256SUMS.txt
├── docs/
│   ├── EFFECTS.md
│   ├── INSTALL.md
│   ├── TROUBLESHOOTING.md
│   ├── UPSTREAM.md
│   └── USAGE.md
├── scripts/
│   ├── install-chrome.sh
│   └── sync-upstream-release.sh
└── upstream/
    └── releases/
        └── latest.json
```

## 版权和来源

扩展本体来自上游项目 [AidenXu-1/ZJ-clipper](https://github.com/AidenXu-1/ZJ-clipper)。上游许可证保留全部权利，未授权复制、修改或分发软件本体。本仓库只提供安装说明、同步元数据和自动下载脚本，不包含扩展本体。

详见 [NOTICE.md](NOTICE.md)。
