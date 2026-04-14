> **Language / 語言:** [English](../../README.md) | [한국어](../ko/README.md) | [日本語](../ja/README.md) | **繁體中文** | [简体中文](../zh-CN/README.md)

# unity-claude-code-skill

一個 **Claude Code 自訂 Skill**，引導使用者透過 MCP（Model Context Protocol）將 Claude Code 與 Unity Editor 進行連接設定。

> **什麼是 Claude Code Skill？**  
> Skill 是基於檔案系統的指令集，Claude Code 會在相關時自動載入。它們存放在包含 `SKILL.md` 檔案及選用腳本/參考資料的資料夾中。詳情請參閱
> [Claude Code Custom Skills 文件](https://code.claude.com/docs/en/skills)。

## 此 Skill 的功能

當使用者向 Claude Code 詢問任何與連接 Unity 相關的問題時，此 Skill 會提供以下逐步指南：

- **路徑 A – Unity 官方 MCP**（`com.unity.ai.assistant`）— 適用於 Unity 6+
- **路徑 B – Coplay MCP**（社群版）— 適用於 Unity 2022+

涵蓋安裝、設定、連線核准、驗證及疑難排解，同時支援 **Windows** 和 **macOS**。

## 儲存庫結構

```
unity-claude-code-skill/
├── SKILL.md                        # 核心 Skill 指令（由 Claude Code 自動載入）
├── README.md                       # 本檔案
├── LICENSE                         # MIT
├── scripts/
│   ├── verify_setup.sh             # macOS/Linux 前置需求檢查腳本
│   └── verify_setup.ps1            # Windows 前置需求檢查腳本
└── references/
    └── troubleshooting.md          # 常見問題與修復方式
```

## 快速安裝

### 選項 1：將儲存庫複製到 Claude Code skills 目錄

```bash
# 使用者層級 skill（在所有專案中可用）
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# 或專案層級 skill（僅在此專案中可用）
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### 選項 2：僅複製 SKILL.md

如果您只需要核心指令而不需要腳本：

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/<your-username>/unity-claude-code-skill/main/SKILL.md
```

## 使用方式

安裝完成後，只需以自然語言與 Claude Code 對話：

- *「幫我設定 Claude Code 與 Unity 的連接」*
- *「我想透過 MCP 將 Unity 專案連接到 Claude Code」*
- *「如何安裝 Coplay MCP for Unity？」*
- *「在 Windows 上設定 Unity MCP」*

Claude Code 會自動載入此 Skill 並引導您完成整個流程。

### 執行驗證腳本

設定完成後，您可以驗證一切是否就緒：

**macOS/Linux：**
```bash
bash ~/.claude/skills/unity-claude-code-setup/scripts/verify_setup.sh
```

**Windows（PowerShell）：**
```powershell
. "$env:USERPROFILE\.claude\skills\unity-claude-code-setup\scripts\verify_setup.ps1"
```

## 前置需求

| 工具 | 用途 | 安裝方式 |
|------|------|----------|
| Claude Code | 兩種路徑皆需 | `curl -fsSL https://claude.ai/install.sh \| bash`（macOS/Linux）或 `irm https://claude.ai/install.ps1 \| iex`（Windows） |
| Unity 6+ | 路徑 A | [unity.com](https://unity.com/download) |
| Unity 2022+ | 路徑 B | [unity.com](https://unity.com/download) |
| Python ≥ 3.11 | 僅路徑 B | [python.org](https://www.python.org/downloads/) |
| Git for Windows | 僅 Windows | [git-scm.com](https://git-scm.com/download/win) |

## 重要資源

- [Unity 官方 MCP 文件](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code 指南](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP 文件](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp GitHub](https://github.com/CoplayDev/unity-mcp)

## 貢獻

歡迎提交 PR！如果您發現某個步驟已過時，或想新增對 Linux 或其他 MCP 客戶端（Cursor、Windsurf 等）的支援，歡迎開啟 issue 或提交 pull request。

## 授權條款

MIT — 請參閱 [LICENSE](../../LICENSE)。
