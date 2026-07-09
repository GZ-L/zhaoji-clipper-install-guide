# 常见问题

## 找不到「加载已解压的扩展程序」

Chrome 中文界面里的按钮叫：

```text
加载未打包的扩展程序
```

它就是 `Load unpacked`，也就是常说的「加载已解压的扩展程序」。

确认：

1. 已打开 `chrome://extensions/`。
2. 右上角「开发者模式」已开启。
3. 左上角出现「加载未打包的扩展程序」按钮。

## 选哪个文件夹

选择：

```text
/Users/guozhi/Applications/ZJ-clipper/chrome
```

这个文件夹里应该直接包含：

```text
manifest.json
```

如果你打开文件夹后先看到另一个同名文件夹，说明层级选错了。要选择直接包含 `manifest.json` 的那一层。

## 不要选择 zip

Chrome 的本地扩展加载需要选择已经解压后的文件夹，不是 zip 文件。

错误：

```text
zhaoji-clipper-4.0.0-chrome.zip
```

正确：

```text
/Users/guozhi/Applications/ZJ-clipper/chrome
```

## Chrome 提示扩展不安全

本地加载的扩展属于开发者模式扩展，Chrome 可能显示安全提醒。这是 Chrome 对本地扩展的通用提醒，不等于该扩展一定有问题。

你仍然应该只从可信来源下载，并确认 SHA-256 校验值一致。

## 下载失败

可能原因：

- GitHub 网络连接慢。
- 下载中断。
- Release 资产被上游替换。

处理方式：

1. 重新运行：

```bash
bash scripts/install-chrome.sh
```

2. 如果仍失败，打开上游 Release 页面手动下载。
3. 下载后校验 SHA-256。

## SHA-256 不一致

不要加载该扩展。

可能原因：

- 文件下载不完整。
- 上游替换了 Release 资产。
- 下载到了错误文件。

处理方式：

1. 删除下载的 zip。
2. 重新下载。
3. 再次校验。
4. 如果仍不一致，先检查上游 Release 页面是否更新。

## 快捷键冲突

默认快捷键：

```text
Command + Shift + S
```

如果快捷键没有反应，打开：

```text
chrome://extensions/shortcuts
```

找到兆基 Clipper，重新设置快捷键。

## 保存到 Obsidian 失败

先确认：

- Obsidian 已打开。
- 仓库名填写正确。
- 如果使用 Local REST API，确认插件已启用。
- API 地址和 API Key 正确。
- 本机防火墙没有阻止 Local REST API。

建议先用 `obsidian://` 方式跑通最小流程，再切换到 Local REST API。
