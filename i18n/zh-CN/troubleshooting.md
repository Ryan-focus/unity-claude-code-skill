# 故障排除 – Unity + Claude Code + MCP

## `claude` 命令未找到

**macOS/Linux：**
原生安装程序会自动将 `claude` 添加到你的 PATH。如果安装后仍未找到，请重启终端或运行：
```bash
source ~/.bashrc   # 或 ~/.zshrc
```

**Windows：**
确保已安装 Git for Windows（原生安装程序需要）。安装后重启 PowerShell。如果仍然缺失，请尝试：
```powershell
irm https://claude.ai/install.ps1 | iex
```

如果你是通过 npm 安装的（已弃用），请确保全局 npm bin 目录在 PATH 中：
```bash
npm config get prefix
# 将 <prefix>/bin 添加到你的 PATH
```

---

## MCP 服务器无法连接 / 卡在"connecting"状态

### 路径 A（Unity Official MCP）
1. 确认 Unity Bridge 在 Project Settings > AI > Unity MCP 中状态为 **Running**。
2. 验证 relay binary 是否存在于 `~/.unity/relay/`。
3. 重新执行配置步骤，或手动重新添加：
   ```bash
   claude mcp remove unity-mcp
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```
4. 重启 Claude Code。

### 路径 B（Coplay MCP）
1. 验证 Python ≥ 3.11：`python3 --version`
2. 移除并重新添加：
   ```bash
   claude mcp remove coplay-mcp
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```
3. 重启 Claude Code。

---

## Unity 未检测到 MCP 客户端

- 确保在启动 Claude Code **之前**已打开 Unity Editor。
- 对于路径 A，在 Project Settings 中检查 **Pending Connections** 并点击 Accept。
- 对于路径 B，确保 Coplay 包已安装并在编辑器中启用。

---

## macOS PATH 问题 – 从 Finder/Hub 启动 Unity

当你通过 Finder 或 Unity Hub（而非终端）启动 Unity 时，编辑器可能无法继承你的 shell PATH。这意味着 Unity 的内部进程可能找不到 `claude`。

**解决方案：**
1. 从终端启动 Unity Hub，使 PATH 得以传递：
   ```bash
   open -a "Unity Hub"
   ```
2. 在 Unity MCP 设置中，使用"Choose Claude Install Location"选项设置 `claude` 二进制文件的绝对路径（例如 `/usr/local/bin/claude` 或 `which claude` 显示的路径）。

---

## 大型操作的超时错误

**Coplay MCP：** 通过移除并使用更大的超时值重新添加来增加超时时间：
```bash
claude mcp remove coplay-mcp
claude mcp add --scope user --transport stdio coplay-mcp \
  --env MCP_TOOL_TIMEOUT=1800000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```
（1800000ms = 30 分钟）

**Unity Official MCP：** 超时由 relay binary 管理。如果遇到问题，请检查 Unity 控制台中的错误，并确保项目不处于大量编译状态。

---

## Windows PowerShell 特有问题

- 如果看到 `The token '&&' is not a valid statement separator` 错误，说明你在 PowerShell 中。请使用 `;` 代替 `&&`，或逐条运行命令。
- 如果 `uvx` 未被识别，请先安装：
  ```powershell
  pip install uv
  ```
- 确保在安装 Python 时已将其添加到系统 PATH（在 Python 安装程序中勾选该选项）。

---

## 切换 HTTP 和 stdio 传输模式

如果你在 MCP for Unity 窗口中更改了传输模式（例如从 HTTP 切换到 stdio），**必须重启 Claude Code** 才能使更改生效。

---

## 仍然遇到问题？

- Unity Official MCP：https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-troubleshooting.html
- Coplay MCP：https://docs.coplay.dev/essentials/troubleshooting
- Claude Code：https://code.claude.com/docs/en/troubleshooting
- CoplayDev/unity-mcp GitHub Issues：https://github.com/CoplayDev/unity-mcp/issues
