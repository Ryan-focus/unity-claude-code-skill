#!/usr/bin/env bash
# auto_setup.sh — One-click MCP setup for Unity + Claude Code
# Supports both Unity Official MCP (Path A) and Coplay MCP (Path B)
# Usage:
#   bash auto_setup.sh --path coplay   # Install Coplay MCP
#   bash auto_setup.sh --path unity    # Configure Unity Official MCP
#   bash auto_setup.sh --auto          # Auto-detect best path

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

pass()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "${RED}[FAIL]${NC} $1"; }
info()  { echo -e "${CYAN}[INFO]${NC} $1"; }

MCP_PATH=""
COPLAY_VERSION="1.5.5"
MCP_TIMEOUT=720000
FORCE=false

usage() {
    echo "Usage: bash auto_setup.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --path coplay|unity   Choose MCP path (required unless --auto)"
    echo "  --auto                Auto-detect best MCP path"
    echo "  --timeout MS          Coplay MCP timeout in ms (default: 720000)"
    echo "  --coplay-version VER  Coplay MCP server version (default: $COPLAY_VERSION)"
    echo "  --force               Remove existing MCP config before setup"
    echo "  -h, --help            Show this help"
    exit 0
}

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --path)
            if [[ $# -lt 2 ]]; then fail "--path requires a value (coplay or unity)"; exit 1; fi
            MCP_PATH="$2"; shift 2 ;;
        --auto)
            MCP_PATH="auto"; shift ;;
        --timeout)
            if [[ $# -lt 2 ]]; then fail "--timeout requires a value"; exit 1; fi
            if ! [[ "$2" =~ ^[0-9]+$ ]]; then fail "--timeout must be a positive integer (got: $2)"; exit 1; fi
            MCP_TIMEOUT="$2"; shift 2 ;;
        --coplay-version)
            if [[ $# -lt 2 ]]; then fail "--coplay-version requires a value"; exit 1; fi
            if ! [[ "$2" =~ ^[a-zA-Z0-9._-]+$ ]]; then fail "--coplay-version contains invalid characters (got: $2)"; exit 1; fi
            COPLAY_VERSION="$2"; shift 2 ;;
        --force)
            FORCE=true; shift ;;
        -h|--help)
            usage ;;
        *)
            fail "Unknown option: $1"; usage ;;
    esac
done

if [[ -z "$MCP_PATH" ]]; then
    fail "Please specify --path coplay, --path unity, or --auto"
    echo ""
    usage
fi

echo ""
echo "=========================================="
echo " Unity + Claude Code — Auto Setup"
echo "=========================================="
echo ""

# --- Step 1: Check Claude Code ---
info "Checking prerequisites..."

if ! command -v claude &>/dev/null; then
    fail "Claude Code not found."
    echo "  Install with: curl -fsSL https://claude.ai/install.sh | bash"
    exit 1
fi
CLAUDE_VER=$(claude --version 2>/dev/null || echo "unknown")
pass "Claude Code found: $CLAUDE_VER"

# --- Step 2: Auto-detect path if needed ---
if [[ "$MCP_PATH" == "auto" ]]; then
    info "Auto-detecting best MCP path..."
    RELAY_DIR="$HOME/.unity/relay"

    if [[ -d "$RELAY_DIR" ]]; then
        # Check for relay binary
        HAS_RELAY=false
        if [[ "$(uname)" == "Darwin" ]]; then
            if [[ -f "$RELAY_DIR/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64" ]] || \
               [[ -f "$RELAY_DIR/relay_mac_x64.app/Contents/MacOS/relay_mac_x64" ]]; then
                HAS_RELAY=true
            fi
        else
            if [[ -f "$RELAY_DIR/relay_linux" ]]; then
                HAS_RELAY=true
            fi
        fi

        if [[ "$HAS_RELAY" == true ]]; then
            info "Unity relay binary detected — using Unity Official MCP (Path A)"
            MCP_PATH="unity"
        else
            info "Relay directory exists but no binary — falling back to Coplay MCP (Path B)"
            MCP_PATH="coplay"
        fi
    else
        info "No Unity relay found — using Coplay MCP (Path B)"
        MCP_PATH="coplay"
    fi
fi

# --- Path A: Unity Official MCP ---
setup_unity_official() {
    info "Setting up Unity Official MCP..."
    echo ""

    RELAY_DIR="$HOME/.unity/relay"
    RELAY_BIN=""

    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS — detect ARM vs Intel
        if [[ -f "$RELAY_DIR/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64" ]]; then
            RELAY_BIN="$RELAY_DIR/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64"
        elif [[ -f "$RELAY_DIR/relay_mac_x64.app/Contents/MacOS/relay_mac_x64" ]]; then
            RELAY_BIN="$RELAY_DIR/relay_mac_x64.app/Contents/MacOS/relay_mac_x64"
        fi
    else
        # Linux
        if [[ -f "$RELAY_DIR/relay_linux" ]]; then
            RELAY_BIN="$RELAY_DIR/relay_linux"
        fi
    fi

    if [[ -z "$RELAY_BIN" ]]; then
        fail "Unity relay binary not found at $RELAY_DIR"
        echo ""
        echo "  To fix this:"
        echo "  1. Open Unity 6+ and install com.unity.ai.assistant via Package Manager"
        echo "  2. Go to Edit > Project Settings > AI > Unity MCP"
        echo "  3. Make sure Unity Bridge shows 'Running'"
        echo "  4. Re-run this script"
        exit 1
    fi

    pass "Relay binary found: $RELAY_BIN"

    # Remove existing config if --force
    if [[ "$FORCE" == true ]]; then
        info "Removing existing unity-mcp config..."
        claude mcp remove unity-mcp 2>/dev/null || true
    fi

    # Add MCP server
    info "Configuring Claude Code MCP connection..."
    if claude mcp add unity-mcp -- "$RELAY_BIN" --mcp 2>/dev/null; then
        pass "unity-mcp added to Claude Code"
    else
        warn "Failed to add unity-mcp. It may already exist. Use --force to overwrite."
        return 1
    fi

    echo ""
    pass "Unity Official MCP setup complete!"
    echo ""
    echo "  Next steps:"
    echo "  1. Open your Unity 6+ project"
    echo "  2. Go to Edit > Project Settings > AI > Unity MCP"
    echo "  3. Accept the pending connection from Claude Code"
    echo "  4. Test: run 'claude' and ask it to read the Unity console"
}

# --- Path B: Coplay MCP ---
setup_coplay() {
    info "Setting up Coplay MCP..."
    echo ""

    # Check Python >= 3.11
    if command -v python3 &>/dev/null; then
        PY_VER=$(python3 --version 2>/dev/null)
        PY_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)' 2>/dev/null || echo "0")
        if [[ "$PY_MINOR" -ge 11 ]]; then
            pass "Python found: $PY_VER (>= 3.11)"
        else
            fail "Python >= 3.11 required, found: $PY_VER"
            echo "  Install: brew install python@3.11 (macOS) or download from python.org"
            exit 1
        fi
    else
        fail "Python3 not found."
        echo "  Install: brew install python@3.11 (macOS) or download from python.org"
        exit 1
    fi

    # Check/install uvx
    if command -v uvx &>/dev/null; then
        pass "uvx found"
    else
        info "uvx not found. Installing uv..."
        if command -v pip3 &>/dev/null; then
            pip3 install --user uv 2>/dev/null
        elif command -v pip &>/dev/null; then
            pip install --user uv 2>/dev/null
        else
            fail "pip not found. Cannot install uv automatically."
            echo "  Install manually: pip install uv"
            exit 1
        fi

        if command -v uvx &>/dev/null; then
            pass "uvx installed successfully"
        else
            fail "uvx still not found after installing uv."
            echo "  Try: pip install uv && hash -r"
            exit 1
        fi
    fi

    # Remove existing config if --force
    if [[ "$FORCE" == true ]]; then
        info "Removing existing coplay-mcp config..."
        claude mcp remove coplay-mcp 2>/dev/null || true
    fi

    # Add MCP server
    info "Configuring Claude Code MCP connection..."
    if claude mcp add \
        --scope user \
        --transport stdio \
        coplay-mcp \
        --env "MCP_TOOL_TIMEOUT=$MCP_TIMEOUT" \
        -- uvx --python ">=3.11" "coplay-mcp-server@$COPLAY_VERSION" 2>/dev/null; then
        pass "coplay-mcp added to Claude Code"
    else
        warn "Failed to add coplay-mcp. It may already exist. Use --force to overwrite."
        return 1
    fi

    echo ""
    pass "Coplay MCP setup complete!"
    echo ""
    echo "  Next steps:"
    echo "  1. Open your Unity project (2022+)"
    echo "  2. Install Coplay package: Window > Package Manager > + > Add from git URL"
    echo "     URL: https://github.com/CoplayDev/unity-plugin.git#beta"
    echo "  3. Enable Coplay in the Editor"
    echo "  4. Test: run 'claude' and ask it to list open Unity editors"
}

# --- Execute ---
case "$MCP_PATH" in
    unity)
        setup_unity_official ;;
    coplay)
        setup_coplay ;;
    *)
        fail "Invalid path: $MCP_PATH (expected 'coplay' or 'unity')"
        exit 1 ;;
esac

# --- Verify ---
echo ""
info "Verifying MCP configuration..."
echo "--- Configured MCP Servers ---"
claude mcp list 2>/dev/null || warn "Could not list MCP servers."

echo ""
echo "=========================================="
echo " Setup complete!"
echo "=========================================="
