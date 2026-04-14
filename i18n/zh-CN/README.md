> **Language / 语言:** [English](../../README.md) | [한국어](../ko/README.md) | [日本語](../ja/README.md) | [繁體中文](../zh-TW/README.md) | **简体中文**

# unity-claude-code-skill

一个将 Claude Code 转变为 Unity AI 开发助手的 **Claude Code 自定义 Skill**
— 支持一键 MCP 设置、自动诊断，以及通过自然语言直接操作
Unity Editor。

> **什么是 Claude Code Skill？**
> Skill 是基于文件系统的指令集，Claude Code 在相关场景下会自动加载。
> 它们存放在包含 `SKILL.md` 文件的文件夹中，并可选包含脚本和参考资料。
> 详情请参阅
> [Claude Code Custom Skills 文档](https://code.claude.com/docs/en/skills)。

## 这个 Skill 做什么

| 功能 | 描述 |
|---------|-------------|
| **一键设置** | 自动设置脚本通过单一命令配置 MCP |
| **自动诊断** | 检测并建议修复连接问题 |
| **Unity 操作** | 通过 MCP 工具控制 Unity 的模板与工作流 |
| **快速原型** | 常见游戏类型的分步工作流 |
| **脚本生成** | PlayerController、GameManager、UI 等 C# 模板 |

### 支持的 MCP 路径

- **路径 A — Unity 官方 MCP**（`com.unity.ai.assistant`）— 适用于 Unity 6+
- **路径 B — Coplay MCP**（社区版）— 适用于 Unity 2022+

## 仓库结构

```text
unity-claude-code-skill/
├── SKILL.md                        # 核心 Skill：设置 + 操作 + 工作流
├── README.md                       # 本文件
├── LICENSE                         # MIT
├── auto_setup.sh                   # 一键 MCP 设置（macOS/Linux）
├── auto_setup.ps1                  # 一键 MCP 设置（Windows）
├── unity_operations.md             # 详细 MCP 工具参考 & 代码模板
├── verify_setup.sh                 # 前置条件检查器（macOS/Linux）
├── verify_setup.ps1                # 前置条件检查器（Windows）
├── troubleshooting.md              # 常见问题 & 解决方案
├── .github/workflows/ci.yml        # CI：Markdown lint、shellcheck、链接检查
└── i18n/                           # 翻译
    ├── ko/                         # 한국어 (Korean)
    ├── ja/                         # 日本語 (Japanese)
    ├── zh-TW/                      # 繁體中文 (Traditional Chinese)
    └── zh-CN/                      # 简体中文 (Simplified Chinese)
```

## 快速安装

### 选项 1：克隆到 Claude Code skills 目录

```bash
# 用户级 skill（所有项目中均可用）
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# 或项目级 skill（仅在当前项目中可用）
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### 选项 2：仅复制 SKILL.md

如果你只需要核心指令而不需要脚本：

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/ryan-focus/unity-claude-code-skill/main/SKILL.md
```

## 一键 MCP 设置

安装 Skill 后，运行自动设置脚本以配置 MCP 连接：

**macOS / Linux：**

```bash
cd ~/.claude/skills/unity-claude-code-setup
bash auto_setup.sh --auto          # 自动检测最佳路径
bash auto_setup.sh --path coplay   # 强制使用 Coplay MCP
bash auto_setup.sh --path unity    # 强制使用 Unity 官方 MCP
```

**Windows（PowerShell）：**

```powershell
cd "$env:USERPROFILE\.claude\skills\unity-claude-code-setup"
.\auto_setup.ps1 -Auto             # 自动检测最佳路径
.\auto_setup.ps1 -Path coplay      # 强制使用 Coplay MCP
.\auto_setup.ps1 -Path unity       # 强制使用 Unity 官方 MCP
```

**选项：**

- `--force` / `-Force` — 移除现有 MCP 配置后重新添加
- `--timeout <ms>` / `-Timeout <ms>` — 自定义超时时间（默认：720000ms）
- `--coplay-version <ver>` / `-CoplayVersion <ver>` — Coplay 服务器版本

## 使用方法

安装并连接后，只需用自然语言与 Claude Code 对话：

**设置：**

- *"帮我设置 Claude Code 与 Unity 的连接"*
- *"我想通过 MCP 将我的 Unity 项目连接到 Claude Code"*

**操作：**

- *"创建一个叫 GameLevel 的新场景"*
- *"在位置 (0, 2, 0) 添加一个红色方块"*
- *"创建一个带 WASD 移动的 PlayerController 脚本"*
- *"设置标准项目文件夹结构"*
- *"检查 Unity 控制台的错误"*

**快速原型：**

- *"帮我做一个滚球游戏原型"*
- *"创建一个基本的 2D 平台游戏"*
- *"构建一个主菜单 UI 系统"*

**诊断：**

- *"MCP 连接不上，帮我修一下"*
- *"对我的 Unity 设置运行诊断"*

## 前置条件

| 工具 | 用途 | 安装方式 |
|------|-------------|---------|
| Claude Code | 两条路径均需要 | `curl -fsSL https://claude.ai/install.sh \| bash`（macOS/Linux）或 `irm https://claude.ai/install.ps1 \| iex`（Windows） |
| Unity 6+ | 路径 A | [unity.com](https://unity.com/download) |
| Unity 2022+ | 路径 B | [unity.com](https://unity.com/download) |
| Python >= 3.11 | 仅路径 B | [python.org](https://www.python.org/downloads/) |
| Git for Windows | 仅 Windows | [git-scm.com](https://git-scm.com/download/win) |

## 关键资源

- [Unity 官方 MCP 文档](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code 指南](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP 文档](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp GitHub 仓库](https://github.com/CoplayDev/unity-mcp)

## 贡献

欢迎提交 PR！如果你发现某个步骤已过时，或希望添加对 Linux 或其他 MCP
客户端（Cursor、Windsurf 等）的支持，请随时提交 issue 或 pull request。

## 许可证

MIT — 详见 [LICENSE](../../LICENSE)。
