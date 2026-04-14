> **Language / 语言:** [English](../../README.md) | [한국어](../ko/README.md) | [日本語](../ja/README.md) | [繁體中文](../zh-TW/README.md) | **简体中文**

# unity-claude-code-skill

一个 **Claude Code 自定义 Skill**，用于引导用户通过 MCP（Model Context Protocol）将 Claude Code 与 Unity Editor 连接起来。

> **什么是 Claude Code Skill？**
> Skill 是基于文件系统的指令集，Claude Code 在相关场景下会自动加载。它们存放在包含 `SKILL.md` 文件的文件夹中，并可选包含脚本和参考资料。详情请参阅
> [Claude Code Custom Skills 文档](https://code.claude.com/docs/en/skills)。

## 这个 Skill 做什么

当用户向 Claude Code 询问任何与 Unity 连接相关的问题时，此 Skill 会提供以下内容的分步指导：

- **路径 A – Unity Official MCP**（`com.unity.ai.assistant`）— 适用于 Unity 6+
- **路径 B – Coplay MCP**（社区版）— 适用于 Unity 2022+

涵盖 **Windows** 和 **macOS** 的安装、配置、连接审批、验证及故障排除。

## 仓库结构

```text
unity-claude-code-skill/
├── SKILL.md                        # 核心 Skill 指令（Claude Code 自动加载）
├── README.md                       # 本文件
├── LICENSE                         # MIT
├── scripts/
│   ├── verify_setup.sh             # macOS/Linux 前置条件检查脚本
│   └── verify_setup.ps1            # Windows 前置条件检查脚本
└── references/
    └── troubleshooting.md          # 常见问题与解决方案
```

## 快速安装

### 选项 1：克隆到 Claude Code skills 目录

```bash
# 用户级 skill（所有项目中均可用）
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# 或项目级 skill（仅在当前项目中可用）
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### 选项 2：仅复制 SKILL.md

如果你只需要核心指令而不需要脚本：

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/<your-username>/unity-claude-code-skill/main/SKILL.md
```

## 使用方法

安装完成后，只需用自然语言与 Claude Code 对话：

- *"帮我设置 Claude Code 与 Unity 的连接"*
- *"我想通过 MCP 将我的 Unity 项目连接到 Claude Code"*
- *"如何为 Unity 安装 Coplay MCP？"*
- *"在 Windows 上设置 Unity MCP"*

Claude Code 将自动加载此 Skill 并引导你完成整个流程。

### 运行验证脚本

设置完成后，你可以验证一切是否就绪：

**macOS/Linux：**

```bash
bash ~/.claude/skills/unity-claude-code-setup/scripts/verify_setup.sh
```

**Windows (PowerShell)：**

```powershell
. "$env:USERPROFILE\.claude\skills\unity-claude-code-setup\scripts\verify_setup.ps1"
```

## 前置条件

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| Claude Code | 两条路径均需要 | `curl -fsSL https://claude.ai/install.sh \| bash`（macOS/Linux）或 `irm https://claude.ai/install.ps1 \| iex`（Windows） |
| Unity 6+ | 路径 A | [unity.com](https://unity.com/download) |
| Unity 2022+ | 路径 B | [unity.com](https://unity.com/download) |
| Python ≥ 3.11 | 仅路径 B | [python.org](https://www.python.org/downloads/) |
| Git for Windows | 仅 Windows | [git-scm.com](https://git-scm.com/download/win) |

## 关键资源

- [Unity Official MCP 文档](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code 指南](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP 文档](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp GitHub 仓库](https://github.com/CoplayDev/unity-mcp)

## 贡献

欢迎提交 PR！如果你发现某个步骤已过时，或希望添加对 Linux 或其他 MCP 客户端（Cursor、Windsurf 等）的支持，请随时提交 issue 或 pull request。

## 许可证

MIT — 详见 [LICENSE](../../LICENSE)。
