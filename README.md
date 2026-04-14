> **Language / 語言:** English | [한국어](i18n/ko/README.md) | [日本語](i18n/ja/README.md) | [繁體中文](i18n/zh-TW/README.md) | [简体中文](i18n/zh-CN/README.md)

# unity-claude-code-skill

A **Claude Code Custom Skill** that guides users through setting up Claude Code
with Unity Editor via MCP (Model Context Protocol).

> **What is a Claude Code Skill?**  
> Skills are filesystem-based instruction sets that Claude Code loads
> automatically when relevant. They live in a folder with a `SKILL.md` file and
> optional scripts/references. See
> [Claude Code Custom Skills docs](https://code.claude.com/docs/en/skills)
> for details.

## What This Skill Does

When a user asks Claude Code anything related to connecting it with Unity, this
skill provides step-by-step guidance for:

- **Path A – Unity Official MCP** (`com.unity.ai.assistant`) — for Unity 6+
- **Path B – Coplay MCP** (community) — for Unity 2022+

It covers installation, configuration, connection approval, verification, and
troubleshooting for both **Windows** and **macOS**.

## Repo Structure

```
unity-claude-code-skill/
├── SKILL.md                        # Core skill instructions (auto-loaded by Claude Code)
├── README.md                       # This file
├── LICENSE                         # MIT
├── verify_setup.sh                 # macOS/Linux prerequisite checker
├── verify_setup.ps1                # Windows prerequisite checker
├── troubleshooting.md              # Common issues & fixes
├── .github/workflows/ci.yml        # CI: markdown lint, shellcheck, link check
└── i18n/                           # Translations
    ├── ko/                         # 한국어 (Korean)
    ├── ja/                         # 日本語 (Japanese)
    ├── zh-TW/                      # 繁體中文 (Traditional Chinese)
    └── zh-CN/                      # 简体中文 (Simplified Chinese)
```

## Quick Install

### Option 1: Clone into your Claude Code skills directory

```bash
# User-level skill (available in all projects)
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# Or project-level skill (available only in this project)
git clone https://github.com/<your-username>/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### Option 2: Just copy SKILL.md

If you only want the core instructions without scripts:

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/<your-username>/unity-claude-code-skill/main/SKILL.md
```

## Usage

Once installed, just talk to Claude Code naturally:

- *"Help me set up Claude Code with Unity"*
- *"I want to connect my Unity project to Claude Code via MCP"*
- *"How do I install Coplay MCP for Unity?"*
- *"Set up Unity MCP on Windows"*

Claude Code will automatically load this skill and walk you through the process.

### Run the Verification Script

After setup, you can verify everything is in place:

**macOS/Linux:**
```bash
bash ~/.claude/skills/unity-claude-code-setup/scripts/verify_setup.sh
```

**Windows (PowerShell):**
```powershell
. "$env:USERPROFILE\.claude\skills\unity-claude-code-setup\scripts\verify_setup.ps1"
```

## Prerequisites

| Tool | Required for | Install |
|------|-------------|---------|
| Claude Code | Both paths | `curl -fsSL https://claude.ai/install.sh \| bash` (macOS/Linux) or `irm https://claude.ai/install.ps1 \| iex` (Windows) |
| Unity 6+ | Path A | [unity.com](https://unity.com/download) |
| Unity 2022+ | Path B | [unity.com](https://unity.com/download) |
| Python ≥ 3.11 | Path B only | [python.org](https://www.python.org/downloads/) |
| Git for Windows | Windows only | [git-scm.com](https://git-scm.com/download/win) |

## Key Resources

- [Unity Official MCP Docs](https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-get-started.html)
- [Coplay MCP + Claude Code Guide](https://docs.coplay.dev/coplay-mcp/claude-code-guide)
- [Claude Code MCP Docs](https://code.claude.com/docs/en/mcp)
- [CoplayDev/unity-mcp on GitHub](https://github.com/CoplayDev/unity-mcp)

## Contributing

PRs welcome! If you find a step that's outdated or want to add support for
Linux or another MCP client (Cursor, Windsurf, etc.), feel free to open an
issue or submit a pull request.

## License

MIT — see [LICENSE](LICENSE).
