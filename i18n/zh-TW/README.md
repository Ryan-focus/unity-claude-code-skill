> **Language / 語言:** [English](../../README.md) | [한국어](../ko/README.md) | [日本語](../ja/README.md) | **繁體中文** | [简体中文](../zh-CN/README.md)

# unity-claude-code-skill

一個將 Claude Code 轉變為 Unity AI 開發助理的 **Claude Code 自訂 Skill**
— 支援一鍵 MCP 設定、自動診斷，以及透過自然語言直接操作
Unity Editor。

> **什麼是 Claude Code Skill？**
> Skill 是基於檔案系統的指令集，Claude Code 會在相關時自動載入。
> 它們存放在包含 `SKILL.md` 檔案及選用腳本/參考資料的資料夾中。
> 詳情請參閱
> [Claude Code Custom Skills 文件](https://code.claude.com/docs/en/skills)。

## 此 Skill 的功能

| 功能 | 說明 |
|---------|-------------|
| **一鍵設定** | 自動設定腳本透過單一指令設定 MCP |
| **自動診斷** | 偵測並建議修復連線問題 |
| **Unity 操作** | 透過 MCP 工具控制 Unity 的範本與工作流程 |
| **快速原型製作** | 常見遊戲類型的逐步工作流程 |
| **腳本生成** | PlayerController、GameManager、UI 等 C# 範本 |

### 支援的 MCP 路徑

- **路徑 A — Unity 官方 MCP**（`com.unity.ai.assistant`）— 適用於 Unity 6+
- **路徑 B — Coplay MCP**（社群版）— 適用於 Unity 2022+

## 儲存庫結構

```text
unity-claude-code-skill/
├── SKILL.md                        # 核心 Skill：設定 + 操作 + 工作流程
├── README.md                       # 本檔案
├── LICENSE                         # MIT
├── auto_setup.sh                   # 一鍵 MCP 設定（macOS/Linux）
├── auto_setup.ps1                  # 一鍵 MCP 設定（Windows）
├── unity_operations.md             # 詳細 MCP 工具參考 & 程式碼範本
├── verify_setup.sh                 # 前置需求檢查器（macOS/Linux）
├── verify_setup.ps1                # 前置需求檢查器（Windows）
├── troubleshooting.md              # 常見問題 & 修復方式
├── .github/workflows/ci.yml        # CI：Markdown lint、shellcheck、連結檢查
└── i18n/                           # 翻譯
    ├── ko/                         # 한국어 (Korean)
    ├── ja/                         # 日本語 (Japanese)
    ├── zh-TW/                      # 繁體中文 (Traditional Chinese)
    └── zh-CN/                      # 简体中文 (Simplified Chinese)
```

## 快速安裝

### 選項 1：複製到 Claude Code skills 目錄

```bash
# 使用者層級 skill（在所有專案中可用）
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# 或專案層級 skill（僅在此專案中可用）
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### 選項 2：僅複製 SKILL.md

如果您只需要核心指令而不需要腳本：

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/ryan-focus/unity-claude-code-skill/main/SKILL.md
```

## 一鍵 MCP 設定

安裝 Skill 後，執行自動設定腳本以設定 MCP 連線：

**macOS / Linux：**

```bash
cd ~/.claude/skills/unity-claude-code-setup
bash auto_setup.sh --auto          # 自動偵測最佳路徑
bash auto_setup.sh --path coplay   # 強制使用 Coplay MCP
bash auto_setup.sh --path unity    # 強制使用 Unity 官方 MCP
```

**Windows（PowerShell）：**

```powershell
cd "$env:USERPROFILE\.claude\skills\unity-claude-code-setup"
.\auto_setup.ps1 -Auto             # 自動偵測最佳路徑
.\auto_setup.ps1 -Path coplay      # 強制使用 Coplay MCP
.\auto_setup.ps1 -Path unity       # 強制使用 Unity 官方 MCP
```

**選項：**

- `--force` / `-Force` — 移除現有 MCP 設定後重新新增
- `--timeout <ms>` / `-Timeout <ms>` — 自訂逾時時間（預設：720000ms）
- `--coplay-version <ver>` / `-CoplayVersion <ver>` — Coplay 伺服器版本

## 使用方式

安裝並連線後，只需以自然語言與 Claude Code 對話：

**設定：**

- *「幫我設定 Claude Code 與 Unity 的連接」*
- *「我想透過 MCP 將 Unity 專案連接到 Claude Code」*

**操作：**

- *「建立一個叫 GameLevel 的新場景」*
- *「在位置 (0, 2, 0) 新增一個紅色方塊」*
- *「建立一個有 WASD 移動功能的 PlayerController 腳本」*
- *「設定標準專案資料夾結構」*
- *「檢查 Unity 主控台的錯誤」*

**快速原型製作：**

- *「幫我做一個滾球遊戲原型」*
- *「建立一個基本的 2D 平台遊戲」*
- *「建構一個主選單 UI 系統」*

**診斷：**

- *「MCP 連線不行，幫我修」*
- *「對我的 Unity 設定執行診斷」*

## 前置需求

| 工具 | 用途 | 安裝方式 |
|------|-------------|---------|
| Claude Code | 兩種路徑皆需 | `curl -fsSL https://claude.ai/install.sh \| bash`（macOS/Linux）或 `irm https://claude.ai/install.ps1 \| iex`（Windows） |
| Unity 6+ | 路徑 A | [unity.com](https://unity.com/download) |
| Unity 2022+ | 路徑 B | [unity.com](https://unity.com/download) |
| Python >= 3.11 | 僅路徑 B | [python.org](https://www.python.org/downloads/) |
| Git for Windows | 僅 Windows | [git-scm.com](https://git-scm.com/download/win) |

## 重要資源

- [Unity 官方 MCP 文件](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code 指南](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP 文件](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp GitHub](https://github.com/CoplayDev/unity-mcp)

## 貢獻

歡迎提交 PR！如果您發現某個步驟已過時，或想新增對 Linux 或其他 MCP
客戶端（Cursor、Windsurf 等）的支援，歡迎開啟 issue 或提交 pull request。

## 授權條款

MIT — 請參閱 [LICENSE](../../LICENSE)。
