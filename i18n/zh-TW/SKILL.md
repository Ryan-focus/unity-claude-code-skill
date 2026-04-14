---
name: unity-claude-code-setup
description: >
  逐步指南：安裝 Claude Code，透過 MCP（Model Context Protocol）將其連接至
  Unity Editor，並驗證整合是否正常運作。涵蓋 Unity 官方 MCP
  （com.unity.ai.assistant）及社群 Coplay MCP。支援 Windows 和 macOS。
  當使用者提及設定 Claude Code 與 Unity 的連接、將 AI 助理連接至 Unity Editor、
  安裝 Unity MCP、設定 Coplay MCP，或想透過 Claude Code 以自然語言控制 Unity
  場景、GameObject、資源或腳本時，請使用此 Skill。當使用者詢問 AI 輔助 Unity
  開發的前置需求、Claude Code + Unity 連線疑難排解，或比較 Unity MCP 與
  Coplay MCP 時，也請觸發此 Skill。
---

# Unity + Claude Code + MCP 設定指南

此 Skill 將引導您透過 MCP 將 Claude Code 連接至 Unity Editor，讓您能以自然語言控制場景、資源、腳本等。

有**兩種主要路徑**，請根據使用者的情況選擇：

| 路徑 | 適用時機 |
|------|----------|
| **路徑 A – Unity 官方 MCP** | Unity 6+ 搭配 `com.unity.ai.assistant` 套件。由 Unity 官方支援。 |
| **路徑 B – Coplay MCP（社群版）** | Unity 2022+。工具更多、迭代更快、社群驅動。 |

如果使用者不確定，請詢問其 Unity 版本。Unity 6+ 使用者可選擇任一路徑；Unity 2022–2023 使用者應使用路徑 B。

---

## 共同前置需求

在使用任一路徑之前，請確保以下條件已就緒：

### 1. 安裝 Claude Code

Claude Code 需要付費的 Anthropic 方案（Pro、Max、Team 或 Enterprise）。

**macOS / Linux：**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows（PowerShell）：**
```powershell
irm https://claude.ai/install.ps1 | iex
```
> Windows 還需要安裝 **Git for Windows**。

**驗證：**
```bash
claude --version
```

首次啟動後，執行 `claude` 並按照瀏覽器提示進行身份驗證。

### 2. 確認 Unity 已安裝

- 路徑 A 需要 **Unity 6（6000.0）** 或更新版本。
- 路徑 B 需要 **Unity 2022** 或更新版本。

---

## 路徑 A – Unity 官方 MCP

### A1. 安裝 AI Assistant 套件

在 Unity 中，前往 **Window > Package Manager**，點選 **+**，選擇
**Add package by name**，然後輸入：

```
com.unity.ai.assistant
```

### A2. 啟動 Unity Bridge

1. 前往 **Edit > Project Settings > AI > Unity MCP**。
2. 確認 **Unity Bridge** 狀態顯示為 **Running**（綠色）。
3. 如果顯示 **Stopped**，請點選 **Start**。

relay binary 會自動安裝至 `~/.unity/relay/`。

### A3. 設定 Claude Code

**選項 1 – 自動設定（建議）：**
在 Unity 的 **Project Settings > AI > Unity MCP > Integrations** 中，找到
**Claude Code** 並點選 **Configure**。

**選項 2 – 手動設定：**

在終端機中執行：
```bash
claude mcp add unity-mcp -- <RELAY_PATH> --mcp
```

請將 `<RELAY_PATH>` 替換為您平台對應的路徑：

| 平台 | Relay 路徑 |
|------|-----------|
| macOS（Apple Silicon） | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
| macOS（Intel） | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
| Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

### A4. 核准連線

1. 回到 Unity：**Edit > Project Settings > AI > Unity MCP**。
2. 在 **Pending Connections** 底下，檢視並點選 **Accept**。

先前已核准的客戶端會自動重新連線。

### A5. 測試

在 Claude Code 中嘗試：
```
Read the Unity console messages and summarize any warnings or errors.
```

如果 Claude 能呼叫 `Unity_ReadConsole`，表示設定已完成。

---

## 路徑 B – Coplay MCP（社群版）

### B1. 安裝 Python 3.11+

Coplay 的 MCP 伺服器需要 Python ≥ 3.11。

**驗證：**
```bash
python3 --version   # macOS/Linux
python --version    # Windows
```

如果尚未安裝：
- macOS：`brew install python@3.11`
- Windows：從 https://www.python.org/downloads/ 下載

### B2. 安裝 Coplay Unity 套件

1. 開啟您的 Unity 專案。
2. **Window > Package Manager > + > Add package from git URL**
3. 輸入：
   ```
   https://github.com/CoplayDev/unity-plugin.git#beta
   ```
4. 確認 Coplay 在 Editor 中已啟用且正在運行。

### B3. 將 Coplay MCP 新增至 Claude Code

```bash
claude mcp add \
  --scope user \
  --transport stdio \
  coplay-mcp \
  --env MCP_TOOL_TIMEOUT=720000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

> 在 Windows 上，請在 PowerShell 中執行此命令。如果找不到 `uvx`，請先透過
> `pip install uv` 安裝。

### B4. 驗證

```bash
claude mcp list
```

您應該會在清單中看到 `coplay-mcp`。

### B5. 測試

開啟您的 Unity 專案，然後在 Claude Code 中輸入：
```
List all open Unity editors
```

接著嘗試：
```
Create a red cube at position (0, 1, 0) in the current Unity scene
```

---

## 疑難排解

請閱讀 `references/troubleshooting.md` 以瞭解常見問題，包括：

- 找不到 `claude` 命令
- MCP 伺服器停留在「connecting」狀態
- Unity 未偵測到 MCP 客戶端
- macOS 從 Finder 啟動 Unity 時的 PATH 問題
- 大型操作的逾時錯誤
- Windows 特有的 PowerShell 問題

---

## 設定後建議

- 在 Unity 專案根目錄執行 `claude /init` 以產生 `CLAUDE.md`，向 Claude Code 描述您的專案慣例。
- 在 Claude Code 中使用 `@` 符號來參照特定檔案，例如 `@PlayerController.cs`。
- 若使用 Coplay MCP，如果在長時間操作中遇到逾時錯誤，請增加 `MCP_TOOL_TIMEOUT` 的值（預設為 720000ms = 12 分鐘）。
