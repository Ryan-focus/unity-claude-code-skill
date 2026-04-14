# 疑難排解 – Unity + Claude Code + MCP

## 找不到 `claude` 命令

**macOS/Linux：**
原生安裝程式會自動將 `claude` 加入您的 PATH。如果安裝後仍找不到，請重新啟動終端機或執行：

```bash
source ~/.bashrc   # 或 ~/.zshrc
```

**Windows：**
確認已安裝 Git for Windows（原生安裝程式的必要條件）。
安裝後請重新啟動 PowerShell。如果仍然找不到，請嘗試：

```powershell
irm https://claude.ai/install.ps1 | iex
```

如果您是透過 npm 安裝（已棄用），請確認全域 npm bin 目錄已加入 PATH：

```bash
npm config get prefix
# 將 <prefix>/bin 加入您的 PATH
```

---

## MCP 伺服器未連線 / 停留在「connecting」狀態

### 路徑 A（Unity 官方 MCP）

1. 確認 Unity Bridge 在 Project Settings > AI > Unity MCP 中狀態為 **Running**。
2. 確認 relay binary 存在於 `~/.unity/relay/`。
3. 重新執行設定步驟或手動重新新增：

   ```bash
   claude mcp remove unity-mcp
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

4. 重新啟動 Claude Code。

### 路徑 B（Coplay MCP）

1. 確認 Python ≥ 3.11：`python3 --version`
2. 移除並重新新增：

   ```bash
   claude mcp remove coplay-mcp
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

3. 重新啟動 Claude Code。

---

## Unity 未偵測到 MCP 客戶端

- 確認在啟動 Claude Code **之前**已開啟 Unity Editor。
- 路徑 A：檢查 Project Settings 中的 **Pending Connections** 並點選 Accept。
- 路徑 B：確認已在 Editor 中安裝並啟用 Coplay 套件。

---

## macOS PATH 問題 – 從 Finder/Hub 啟動 Unity

當您透過 Finder 或 Unity Hub 啟動 Unity（而非從終端機啟動）時，Editor 可能無法繼承您的 shell PATH。這代表 Unity 的內部程序可能找不到 `claude`。

**解決方案：**

1. 從終端機啟動 Unity Hub 以傳遞 PATH：

   ```bash
   open -a "Unity Hub"
   ```

2. 在 Unity MCP 設定中，使用「Choose Claude Install Location」選項來設定 `claude` 二進位檔的絕對路徑（例如 `/usr/local/bin/claude` 或 `which claude` 顯示的路徑）。

---

## 大型操作的逾時錯誤

**Coplay MCP：** 透過移除並以更高數值重新新增來增加逾時時間：

```bash
claude mcp remove coplay-mcp
claude mcp add --scope user --transport stdio coplay-mcp \
  --env MCP_TOOL_TIMEOUT=1800000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

（1800000ms = 30 分鐘）

**Unity 官方 MCP：** 逾時由 relay binary 管理。如果遇到問題，請檢查 Unity 的主控台是否有錯誤訊息，並確認您的專案不處於大量編譯的狀態。

---

## Windows PowerShell 特有問題

- 如果看到 `The token '&&' is not a valid statement separator` 錯誤，代表您在 PowerShell 中。請使用 `;` 取代 `&&`，或逐一執行命令。
- 如果無法識別 `uvx`，請先安裝：

  ```powershell
  pip install uv
  ```

- 確認安裝 Python 時已將其加入系統 PATH（在 Python 安裝程式中勾選該選項）。

---

## 切換 HTTP 與 stdio 傳輸模式

如果您在 MCP for Unity 視窗中變更了傳輸模式（例如從 HTTP 切換至 stdio），**必須重新啟動 Claude Code** 才能套用變更。

---

## 仍然無法解決？

- Unity 官方 MCP：<https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-troubleshooting.html>
- Coplay MCP：<https://docs.coplay.dev/essentials/troubleshooting>
- Claude Code：<https://code.claude.com/docs/en/troubleshooting>
- CoplayDev/unity-mcp GitHub Issues：<https://github.com/CoplayDev/unity-mcp/issues>
