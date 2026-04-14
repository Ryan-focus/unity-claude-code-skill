> **Language / 語言:** English | [한국어](i18n/ko/README.md) | [日本語](i18n/ja/README.md) | [繁體中文](i18n/zh-TW/README.md) | [简体中文](i18n/zh-CN/README.md)

# unity-claude-code-skill

A **Claude Code Custom Skill** that turns Claude Code into a Unity AI
development assistant — one-click MCP setup, auto-diagnosis, and direct
Unity Editor operations via natural language.

> **What is a Claude Code Skill?**
> Skills are filesystem-based instruction sets that Claude Code loads
> automatically when relevant. They live in a folder with a `SKILL.md` file and
> optional scripts/references. See
> [Claude Code Custom Skills docs](https://code.claude.com/docs/en/skills)
> for details.

## What This Skill Does

| Feature | Description |
|---------|-------------|
| **One-click setup** | Auto-setup scripts configure MCP with a single command |
| **Auto-diagnosis** | Detects and suggests fixes for connection issues |
| **Unity operations** | Templates and workflows for controlling Unity via MCP tools |
| **Rapid prototyping** | Step-by-step workflows for common game types |
| **Script generation** | C# templates for PlayerController, GameManager, UI, and more |

### MCP Paths Supported

- **Path A — Unity Official MCP** (`com.unity.ai.assistant`) — for Unity 6+
- **Path B — Coplay MCP** (community) — for Unity 2022+

## Repo Structure

```text
unity-claude-code-skill/
├── SKILL.md                        # Core skill: setup + operations + workflows
├── README.md                       # This file
├── LICENSE                         # MIT
├── auto_setup.sh                   # One-click MCP setup (macOS/Linux)
├── auto_setup.ps1                  # One-click MCP setup (Windows)
├── unity_operations.md             # Detailed MCP tool reference & code templates
├── verify_setup.sh                 # Prerequisite checker (macOS/Linux)
├── verify_setup.ps1                # Prerequisite checker (Windows)
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
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  ~/.claude/skills/unity-claude-code-setup

# Or project-level skill (available only in this project)
git clone https://github.com/ryan-focus/unity-claude-code-skill.git \
  .claude/skills/unity-claude-code-setup
```

### Option 2: Just copy SKILL.md

If you only want the core instructions without scripts:

```bash
mkdir -p ~/.claude/skills/unity-claude-code-setup
curl -o ~/.claude/skills/unity-claude-code-setup/SKILL.md \
  https://raw.githubusercontent.com/ryan-focus/unity-claude-code-skill/main/SKILL.md
```

## One-Click MCP Setup

After installing the skill, run the auto-setup script to configure the MCP
connection:

**macOS / Linux:**

```bash
cd ~/.claude/skills/unity-claude-code-setup
bash auto_setup.sh --auto          # Auto-detect best path
bash auto_setup.sh --path coplay   # Force Coplay MCP
bash auto_setup.sh --path unity    # Force Unity Official MCP
```

**Windows (PowerShell):**

```powershell
cd "$env:USERPROFILE\.claude\skills\unity-claude-code-setup"
.\auto_setup.ps1 -Auto             # Auto-detect best path
.\auto_setup.ps1 -Path coplay      # Force Coplay MCP
.\auto_setup.ps1 -Path unity       # Force Unity Official MCP
```

**Options:**

- `--force` / `-Force` — Remove existing MCP config before re-adding
- `--timeout <ms>` / `-Timeout <ms>` — Custom timeout (default: 720000ms)
- `--coplay-version <ver>` / `-CoplayVersion <ver>` — Coplay server version

## Usage

Once installed and connected, just talk to Claude Code naturally:

**Setup:**

- *"Help me set up Claude Code with Unity"*
- *"Connect my Unity project to Claude Code via MCP"*

**Operations:**

- *"Create a new scene called GameLevel"*
- *"Add a red cube at position (0, 2, 0)"*
- *"Create a PlayerController script with WASD movement"*
- *"Set up a standard project folder structure"*
- *"Check the Unity console for errors"*

**Rapid prototyping:**

- *"Help me prototype a ball-rolling game"*
- *"Create a basic 2D platformer"*
- *"Build a main menu UI system"*

**Diagnostics:**

- *"The MCP connection isn't working, help me fix it"*
- *"Run diagnostics on my Unity setup"*

## Prerequisites

| Tool | Required for | Install |
|------|-------------|---------|
| Claude Code | Both paths | `curl -fsSL https://claude.ai/install.sh \| bash` (macOS/Linux) or `irm https://claude.ai/install.ps1 \| iex` (Windows) |
| Unity 6+ | Path A | [unity.com](https://unity.com/download) |
| Unity 2022+ | Path B | [unity.com](https://unity.com/download) |
| Python >= 3.11 | Path B only | [python.org](https://www.python.org/downloads/) |
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

> **Note on i18n:** The translations under `i18n/` currently reflect the
> original setup-guide version of this skill. They have not yet been updated
> to cover the new auto-setup scripts, operations guide, or rapid prototyping
> workflows. Contributions to update them are especially welcome.

## License

MIT — see [LICENSE](LICENSE).
