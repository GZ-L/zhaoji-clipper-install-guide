# 安装说明

本文档说明如何安装 `兆基 Clipper v4.0.0` 的 Chrome 扩展成品包。

## 方式一：使用脚本安装

在终端执行：

```bash
git clone https://github.com/GZ-L/zhaoji-clipper-install-guide.git
cd zhaoji-clipper-install-guide
bash scripts/install-chrome.sh
```

脚本会把扩展解压到：

```text
~/Applications/ZJ-clipper/chrome
```

在当前 Mac 上展开后的绝对路径是：

```text
/Users/guozhi/Applications/ZJ-clipper/chrome
```

如果该目录已经存在，脚本会先把旧目录移动成带时间戳的备份目录，然后再解压新版。

## 方式二：手动安装

1. 打开上游 Release 页面：

```text
https://github.com/AidenXu-1/ZJ-clipper/releases/tag/v4.0.0
```

2. 下载：

```text
zhaoji-clipper-4.0.0-chrome.zip
```

3. 校验 SHA-256：

```bash
shasum -a 256 zhaoji-clipper-4.0.0-chrome.zip
```

结果应为：

```text
016817dc815a6c529480ef5d7a0787311a61ec8dc2193f431d68544ee65636fb
```

4. 解压 zip。

5. 确认解压后的文件夹里直接包含：

```text
manifest.json
popup.html
options.html
background.js
content-scripts/
```

## Chrome 加载步骤

1. 打开 Chrome。
2. 地址栏输入：

```text
chrome://extensions/
```

3. 打开右上角「开发者模式」。
4. 点击左上角「加载未打包的扩展程序」。
5. 选择安装目录：

```text
/Users/guozhi/Applications/ZJ-clipper/chrome
```

6. 加载成功后，扩展列表中会出现：

```text
兆基clipper 4.0.0
```

## 重要提醒

- 选择文件夹，不要选择 zip 文件。
- 选择包含 `manifest.json` 的那一层文件夹。
- Chrome 中文按钮「加载未打包的扩展程序」就是 `Load unpacked`。
- 不要点击「打包扩展程序」，那是开发者重新打包扩展用的。
- 浏览器扩展安装必须由用户在 Chrome 中确认，脚本不能代替这个确认动作。
