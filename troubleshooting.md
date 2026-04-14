# Troubleshooting – Unity + Claude Code + MCP

## `claude` command not found

**macOS/Linux:**
The native installer adds `claude` to your PATH automatically. If it's still
not found after installation, restart your terminal or run:

```bash
source ~/.bashrc   # or ~/.zshrc
```

**Windows:**
Make sure Git for Windows is installed (required for the native installer).
Restart PowerShell after installation. If still missing, try:

```powershell
irm https://claude.ai/install.ps1 | iex
```

If you installed via npm (deprecated), ensure your global npm bin is on PATH:

```bash
npm config get prefix
# Add <prefix>/bin to your PATH
```

---

## MCP server not connecting / stuck on "connecting"

### Path A (Unity Official MCP)

1. Confirm Unity Bridge is **Running** in Project Settings > AI > Unity MCP.
2. Verify the relay binary exists at `~/.unity/relay/`.
3. Re-run the Configure step or manually re-add:

   ```bash
   claude mcp remove unity-mcp
   claude mcp add unity-mcp -- <RELAY_PATH> --mcp
   ```

4. Restart Claude Code.

### Path B (Coplay MCP)

1. Verify Python ≥ 3.11: `python3 --version`
2. Remove and re-add:

   ```bash
   claude mcp remove coplay-mcp
   claude mcp add --scope user --transport stdio coplay-mcp \
     --env MCP_TOOL_TIMEOUT=720000 \
     -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
   ```

3. Restart Claude Code.

---

## Unity not detecting the MCP client

- Make sure Unity Editor is open **before** starting Claude Code.
- For Path A, check **Pending Connections** in Project Settings and click Accept.
- For Path B, ensure the Coplay package is installed and enabled in the Editor.

---

## macOS PATH issue – Unity launched from Finder/Hub

When you launch Unity via Finder or Unity Hub (not from Terminal), the Editor
may not inherit your shell PATH. This means `claude` might not be found by
Unity's internal processes.

**Solutions:**

1. Launch Unity Hub from Terminal so PATH propagates:

   ```bash
   open -a "Unity Hub"
   ```

2. In Unity MCP settings, use the "Choose Claude Install Location" option to
   set the absolute path to the `claude` binary (e.g., `/usr/local/bin/claude`
   or the path shown by `which claude`).

---

## Timeout errors on large operations

**Coplay MCP:** Increase the timeout by removing and re-adding with a higher
value:

```bash
claude mcp remove coplay-mcp
claude mcp add --scope user --transport stdio coplay-mcp \
  --env MCP_TOOL_TIMEOUT=1800000 \
  -- uvx --python ">=3.11" coplay-mcp-server@1.5.5
```

(1800000ms = 30 minutes)

**Unity Official MCP:** Timeout is managed by the relay binary. If you
experience issues, check Unity's console for errors and ensure your project
isn't in a heavy compilation state.

---

## Windows PowerShell-specific issues

- If you see `The token '&&' is not a valid statement separator`, you're in
  PowerShell. Use `;` instead of `&&`, or run commands one at a time.
- If `uvx` is not recognized, install it first:

  ```powershell
  pip install uv
  ```

- Make sure Python is added to your system PATH during installation (check the
  box in the Python installer).

---

## Switching between HTTP and stdio transport

If you change the transport mode in the MCP for Unity window (e.g., from HTTP
to stdio), you **must restart Claude Code** for it to pick up the change.

---

## Still stuck?

- Unity Official MCP: <https://docs.unity3d.com/Packages/com.unity.ai.assistant@2.0/manual/unity-mcp-troubleshooting.html>
- Coplay MCP: <https://docs.coplay.dev/essentials/troubleshooting>
- Claude Code: <https://code.claude.com/docs/en/troubleshooting>
- CoplayDev/unity-mcp GitHub Issues: <https://github.com/CoplayDev/unity-mcp/issues>
