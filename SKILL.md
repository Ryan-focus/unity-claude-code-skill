---
name: unity-claude-code-setup
description: >
  Step-by-step guide to install Claude Code, connect it to Unity Editor via MCP
  (Model Context Protocol), and verify the integration works. Covers both the
  Unity official MCP (com.unity.ai.assistant) and the community Coplay MCP.
  Supports Windows and macOS. Use this skill whenever the user mentions setting
  up Claude Code with Unity, connecting an AI assistant to Unity Editor,
  Unity MCP installation, Coplay MCP setup, or wants to use natural-language
  commands to control Unity scenes, GameObjects, assets, or scripts through
  Claude Code. Also trigger when the user asks about prerequisites for
  AI-assisted Unity development, troubleshooting Claude Code + Unity connections,
  or comparing Unity MCP vs Coplay MCP.
---

# Unity + Claude Code + MCP Setup Guide

This skill walks you through connecting Claude Code to Unity Editor via MCP so
you can control scenes, assets, scripts, and more with natural language.

There are **two main paths**. Pick the one that fits the user's situation:

| Path | When to use |
|------|-------------|
| **Path A – Unity Official MCP** | Unity 6+ with `com.unity.ai.assistant` package. Officially supported by Unity. |
| **Path B – Coplay MCP (community)** | Unity 2022+. More tools, faster iteration, community-driven. |

If the user is unsure, ask which Unity version they have. Unity 6+ users can
use either path; Unity 2022–2023 users should use Path B.

---

## Shared Prerequisites

Before either path, make sure these are in place:

### 1. Install Claude Code

Claude Code requires a paid Anthropic plan (Pro, Max, Team, or Enterprise).

**macOS / Linux:**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://claude.ai/install.ps1 | iex
```

> Windows also requires **Git for Windows** to be installed.

**Verify:**

```bash
claude --version
```

After first launch, run `claude` and follow the browser prompts to authenticate.

### 2. Verify Unity is installed

- Path A requires **Unity 6 (6000.0)** or later.
- Path B requires **Unity 2022** or later.

---

## Path A – Unity Official MCP

### A1. Install the AI Assistant package

In Unity, go to **Window > Package Manager**, click **+**, choose
**Add package by name**, and enter:

```text
com.unity.ai.assistant
```

### A2. Start the Unity Bridge

1. Go to **Edit > Project Settings > AI > Unity MCP**.
2. Confirm the **Unity Bridge** status shows **Running** (green).
3. If it shows **Stopped**, click **Start**.

The relay binary is auto-installed to `~/.unity/relay/`.

### A3. Configure Claude Code

**Option 1 – Auto-configure (recommended):**
In Unity's **Project Settings > AI > Unity MCP > Integrations**, find
**Claude Code** and click **Configure**.

**Option 2 – Manual:**

Run in terminal:

```bash
claude mcp add unity-mcp -- <RELAY_PATH> --mcp
```

Replace `<RELAY_PATH>` with the correct path for your platform:

| Platform | Relay path |
|----------|-----------|
| macOS (Apple Silicon) | `~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64` |
| macOS (Intel) | `~/.unity/relay/relay_mac_x64.app/Contents/MacOS/relay_mac_x64` |
| Windows | `%USERPROFILE%\.unity\relay\relay_win.exe` |

### A4. Approve the connection

1. Back in Unity: **Edit > Project Settings > AI > Unity MCP**.
2. Under **Pending Connections**, review and click **Accept**.

Previously approved clients reconnect automatically.

### A5. Test

In Claude Code, try:

```text
Read the Unity console messages and summarize any warnings or errors.
```

If Claude can invoke `Unity_ReadConsole`, the setup is complete.

---

## Path B – Coplay MCP (Community)

### B1. Install Python 3.11+

Coplay's MCP server requires Python ≥ 3.11.

**Verify:**

```bash
python3 --version   # macOS/Linux
python --version    # Windows
```

If not installed:

- macOS: `brew install python@3.11`
- Windows: download from <https://www.python.org/downloads/>

### B2. Install the Coplay Unity package

1. Open your Unity project.
2. **Window > Package Manager > + > Add package from git URL**
3. Enter:

   ```text
   https://github.com/CoplayDev/unity-plugin.git#beta
   ```

4. Ensure Coplay is enabled and running in the Editor.

### B3. Add Coplay MCP to Claude Code

```bash
claude mcp add \
  --scope user \
  --transport stdio \
  coplay-mcp \
  --env MCP_TOOL_TIMEOUT=720000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

> On Windows, run this in PowerShell. If `uvx` is not found, install it with
> `pip install uv` first.

### B4. Verify

```bash
claude mcp list
```

You should see `coplay-mcp` in the list.

### B5. Test

Open your Unity project, then in Claude Code:

```text
List all open Unity editors
```

Then try:

```text
Create a red cube at position (0, 1, 0) in the current Unity scene
```

---

## Troubleshooting

Read `references/troubleshooting.md` for common issues, including:

- `claude` command not found
- MCP server stuck on "connecting"
- Unity not detecting the MCP client
- macOS PATH issues when Unity is launched from Finder
- Timeout errors on large operations
- Windows-specific PowerShell issues

---

## Post-Setup Tips

- Run `claude /init` in your Unity project root to generate a `CLAUDE.md` that
  describes your project conventions to Claude Code.
- Use the `@` symbol in Claude Code to reference specific files, e.g.
  `@PlayerController.cs`.
- For Coplay MCP, increase `MCP_TOOL_TIMEOUT` if you hit timeout errors on
  long operations (default is 720000ms = 12 min).
