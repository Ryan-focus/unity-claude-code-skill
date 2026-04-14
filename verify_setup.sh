#!/usr/bin/env bash
# verify_setup.sh — Check prerequisites for Unity + Claude Code + MCP
# Works on macOS and Linux. For Windows, use verify_setup.ps1.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass() { echo -e "${GREEN}✔ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
fail() { echo -e "${RED}✘ $1${NC}"; }

echo "=== Unity + Claude Code + MCP — Setup Verification ==="
echo ""

# 1. Claude Code
if command -v claude &>/dev/null; then
  CLAUDE_VER=$(claude --version 2>/dev/null || echo "unknown")
  pass "Claude Code found: $CLAUDE_VER"
else
  fail "Claude Code not found. Install: curl -fsSL https://claude.ai/install.sh | bash"
fi

# 2. Python (needed for Coplay MCP path)
if command -v python3 &>/dev/null; then
  PY_VER=$(python3 --version 2>/dev/null)
  pass "Python found: $PY_VER"
  # Check >= 3.11
  PY_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)' 2>/dev/null || echo "0")
  if [ "$PY_MINOR" -ge 11 ]; then
    pass "Python >= 3.11 (required for Coplay MCP)"
  else
    warn "Python < 3.11 detected. Coplay MCP requires >= 3.11."
  fi
else
  warn "Python3 not found. Required only if using Coplay MCP path."
fi

# 3. uvx (needed for Coplay MCP path)
if command -v uvx &>/dev/null; then
  pass "uvx found"
else
  warn "uvx not found. Install with: pip install uv (required for Coplay MCP)"
fi

# 4. Unity relay binary (needed for Unity Official MCP path)
RELAY_DIR="$HOME/.unity/relay"
if [ -d "$RELAY_DIR" ]; then
  pass "Unity relay directory found: $RELAY_DIR"
  # Check for platform-specific binary
  if [[ "$(uname)" == "Darwin" ]]; then
    if [ -f "$RELAY_DIR/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64" ] || \
       [ -f "$RELAY_DIR/relay_mac_x64.app/Contents/MacOS/relay_mac_x64" ]; then
      pass "Unity relay binary found (macOS)"
    else
      warn "Unity relay binary not found. Open Unity 6 project to auto-install."
    fi
  else
    if [ -f "$RELAY_DIR/relay_linux" ]; then
      pass "Unity relay binary found (Linux)"
    else
      warn "Unity relay binary not found. Open Unity 6 project to auto-install."
    fi
  fi
else
  warn "Unity relay directory not found at $RELAY_DIR"
  warn "This is expected if you haven't opened a Unity 6+ project yet."
fi

# 5. Claude MCP servers
echo ""
echo "--- Configured MCP Servers ---"
if command -v claude &>/dev/null; then
  claude mcp list 2>/dev/null || warn "Could not list MCP servers. Run 'claude mcp list' manually."
else
  warn "Skipping MCP list (Claude Code not installed)."
fi

echo ""
echo "=== Verification complete ==="
