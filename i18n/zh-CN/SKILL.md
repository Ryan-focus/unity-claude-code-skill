---
name: unity-claude-code-setup
description: >
  分步指南：安装 Claude Code，通过 MCP（Model Context Protocol）将其连接到
  Unity Editor，并验证集成是否正常工作。涵盖 Unity 官方 MCP
  （com.unity.ai.assistant）和社区版 Coplay MCP。支持 Windows 和 macOS。
  当用户提到设置 Claude Code 与 Unity 的连接、将 AI 助手连接到 Unity Editor、
  安装 Unity MCP、设置 Coplay MCP，或希望通过 Claude Code 使用自然语言控制
  Unity 场景、GameObject、资源或脚本时，请使用此 Skill。当用户询问 AI 辅助
  Unity 开发的前置条件、Claude Code + Unity 连接的故障排除，或比较 Unity MCP
  与 Coplay MCP 时，也应触发此 Skill。
---

# Unity + Claude Code + MCP 设置指南

此 Skill 将引导你通过 MCP 将 Claude Code 连接到 Unity Editor，以便你可以使用自然语言控制场景、资源、脚本等。

有**两条主要路径**。根据用户的情况选择合适的路径：

| 路径 | 适用场景 |
|------|----------|
| **路径 A – Unity Official MCP** | Unity 6+ 搭配 `com.unity.ai.assistant` 包。由 Unity 官方支持。 |
| **路径 B – Coplay MCP（社区版）** | Unity 2022+。工具更多、迭代更快、社区驱动。 |

如果用户不确定，请询问其 Unity 版本。Unity 6+ 用户可以使用任一路径；Unity 2022–2023 用户应使用路径 B。

---

## 共享前置条件

在使用任一路径之前，请确保以下条件已满足：

### 1. 安装 Claude Code

Claude Code 需要付费的 Anthropic 计划（Pro、Max、Team 或 Enterprise）。

**macOS / Linux：**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows (PowerShell)：**

```powershell
irm https://claude.ai/install.ps1 | iex
```

> Windows 还需要安装 **Git for Windows**。

**验证：**

```bash
claude --version
```

首次启动后，运行 `claude` 并按照浏览器提示完成身份验证。

### 2. 验证 Unity 已安装

- 路径 A 需要 **Unity 6 (6000.0)** 或更高版本。
- 路径 B 需要 **Unity 2022** 或更高版本。

---

## 路径 A – Unity Official MCP

### A1. 安装 AI Assistant 包

在 Unity 中，前往 **Window > Package Manager**，点击 **+**，选择
**Add package by name**，然后输入：

```text
com.unity.ai.assistant
```

### A2. 启动 Unity Bridge

1. 前往 **Edit > Project Settings > AI > Unity MCP**。
2. 确认 **Unity Bridge** 状态显示为 **Running**（绿色）。
3. 如果显示 **Stopped**，点击 **Start**。

relay binary 会自动安装到 `~/.unity/relay/`。

### A3. 配置 Claude Code

**选项 1 – 自动配置（推荐）：**
在 Unity 的 **Project Settings > AI > Unity MCP > Integrations** 中，找到
**Claude Code** 并点击 **Configure**。

**选项 2 – 手动配置：**

在终端中运行：

```bash
claude mcp add unity-mcp -- <RELAY_PATH> --mcp
```

将 `<RELAY_PATH>` 替换为你平台对应的路径：

| 平台 | Relay 路径 |
|------|-----------|
| macOS (Apple Silicon) | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
| macOS (Intel) | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
| Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

### A4. 批准连接

1. 回到 Unity：**Edit > Project Settings > AI > Unity MCP**。
2. 在 **Pending Connections** 下，查看并点击 **Accept**。

之前已批准的客户端会自动重新连接。

### A5. 测试

在 Claude Code 中，尝试：

```text
Read the Unity console messages and summarize any warnings or errors.
```

如果 Claude 能调用 `Unity_ReadConsole`，则设置完成。

---

## 路径 B – Coplay MCP（社区版）

### B1. 安装 Python 3.11+

Coplay 的 MCP 服务器需要 Python ≥ 3.11。

**验证：**

```bash
python3 --version   # macOS/Linux
python --version    # Windows
```

如果未安装：

- macOS：`brew install python@3.11`
- Windows：从 <https://www.python.org/downloads/> 下载

### B2. 安装 Coplay Unity 包

1. 打开你的 Unity 项目。
2. **Window > Package Manager > + > Add package from git URL**
3. 输入：

   ```text
   https://github.com/CoplayDev/unity-plugin.git#beta
   ```

4. 确保 Coplay 在编辑器中已启用并正在运行。

### B3. 将 Coplay MCP 添加到 Claude Code

```bash
claude mcp add \
  --scope user \
  --transport stdio \
  coplay-mcp \
  --env MCP_TOOL_TIMEOUT=720000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

> 在 Windows 上，请在 PowerShell 中运行此命令。如果找不到 `uvx`，请先运行
> `pip install uv` 安装。

### B4. 验证

```bash
claude mcp list
```

你应该能在列表中看到 `coplay-mcp`。

### B5. 测试

打开你的 Unity 项目，然后在 Claude Code 中：

```text
List all open Unity editors
```

然后尝试：

```text
Create a red cube at position (0, 1, 0) in the current Unity scene
```

---

## 故障排除

阅读 `references/troubleshooting.md` 了解常见问题，包括：

- `claude` 命令未找到
- MCP 服务器卡在"connecting"状态
- Unity 未检测到 MCP 客户端
- macOS 从 Finder 启动 Unity 时的 PATH 问题
- 大型操作的超时错误
- Windows 特有的 PowerShell 问题

---

## 设置后提示

- 在 Unity 项目根目录运行 `claude /init`，生成一个 `CLAUDE.md` 文件来向 Claude Code 描述你的项目规范。
- 在 Claude Code 中使用 `@` 符号引用特定文件，例如
  `@PlayerController.cs`。
- 对于 Coplay MCP，如果在长时间操作中遇到超时错误，请增大 `MCP_TOOL_TIMEOUT`（默认值为 720000ms = 12 分钟）。
