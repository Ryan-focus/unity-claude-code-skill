# auto_setup.ps1 — One-click MCP setup for Unity + Claude Code (Windows)
# Usage:
#   .\auto_setup.ps1 -Path coplay   # Install Coplay MCP
#   .\auto_setup.ps1 -Path unity    # Configure Unity Official MCP
#   .\auto_setup.ps1 -Auto          # Auto-detect best path

param(
    [ValidateSet("coplay", "unity", "")]
    [string]$Path = "",
    [switch]$Auto,
    [int]$Timeout = 720000,
    [string]$CoplayVersion = "1.5.5",
    [switch]$Force,
    [switch]$Help
)

function Write-Pass  { param($msg) Write-Host "[OK]   $msg" -ForegroundColor Green }
function Write-Warn  { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Fail  { param($msg) Write-Host "[FAIL] $msg" -ForegroundColor Red }
function Write-Info  { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }

if ($Help) {
    Write-Host "Usage: .\auto_setup.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Path coplay|unity   Choose MCP path"
    Write-Host "  -Auto                Auto-detect best MCP path"
    Write-Host "  -Timeout MS          Coplay MCP timeout in ms (default: 720000)"
    Write-Host "  -CoplayVersion VER   Coplay MCP server version (default: 1.5.5)"
    Write-Host "  -Force               Remove existing MCP config before setup"
    Write-Host "  -Help                Show this help"
    exit 0
}

if (-not $Path -and -not $Auto) {
    Write-Fail "Please specify -Path coplay, -Path unity, or -Auto"
    Write-Host ""
    Write-Host "Usage: .\auto_setup.ps1 -Path coplay|unity"
    Write-Host "       .\auto_setup.ps1 -Auto"
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Unity + Claude Code — Auto Setup"         -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# --- Step 1: Check Claude Code ---
Write-Info "Checking prerequisites..."

try {
    $claudeVer = claude --version 2>$null
    if ($claudeVer) {
        Write-Pass "Claude Code found: $claudeVer"
    } else {
        throw "not found"
    }
} catch {
    Write-Fail "Claude Code not found."
    Write-Host "  Install: irm https://claude.ai/install.ps1 | iex"
    exit 1
}

# Check Git
try {
    $gitVer = git --version 2>$null
    if ($gitVer) {
        Write-Pass "Git found: $gitVer"
    } else {
        throw "not found"
    }
} catch {
    Write-Fail "Git for Windows not found (required for Claude Code)."
    Write-Host "  Download: https://git-scm.com/download/win"
    exit 1
}

# --- Step 2: Auto-detect ---
if ($Auto) {
    Write-Info "Auto-detecting best MCP path..."
    $relayDir = Join-Path $env:USERPROFILE ".unity\relay"
    $relayExe = Join-Path $relayDir "relay_win.exe"

    if (Test-Path $relayExe) {
        Write-Info "Unity relay binary detected — using Unity Official MCP (Path A)"
        $Path = "unity"
    } else {
        Write-Info "No Unity relay found — using Coplay MCP (Path B)"
        $Path = "coplay"
    }
}

# --- Path A: Unity Official MCP ---
function Setup-UnityOfficial {
    Write-Info "Setting up Unity Official MCP..."
    Write-Host ""

    $relayDir = Join-Path $env:USERPROFILE ".unity\relay"
    $relayExe = Join-Path $relayDir "relay_win.exe"

    if (-not (Test-Path $relayExe)) {
        Write-Fail "Unity relay binary not found at $relayExe"
        Write-Host ""
        Write-Host "  To fix this:"
        Write-Host "  1. Open Unity 6+ and install com.unity.ai.assistant via Package Manager"
        Write-Host "  2. Go to Edit > Project Settings > AI > Unity MCP"
        Write-Host "  3. Make sure Unity Bridge shows 'Running'"
        Write-Host "  4. Re-run this script"
        exit 1
    }

    Write-Pass "Relay binary found: $relayExe"

    if ($Force) {
        Write-Info "Removing existing unity-mcp config..."
        claude mcp remove unity-mcp 2>$null
    }

    Write-Info "Configuring Claude Code MCP connection..."
    try {
        claude mcp add unity-mcp -- $relayExe --mcp 2>$null
        Write-Pass "unity-mcp added to Claude Code"
    } catch {
        Write-Warn "Failed to add unity-mcp. It may already exist. Use -Force to overwrite."
        return
    }

    Write-Host ""
    Write-Pass "Unity Official MCP setup complete!"
    Write-Host ""
    Write-Host "  Next steps:"
    Write-Host "  1. Open your Unity 6+ project"
    Write-Host "  2. Go to Edit > Project Settings > AI > Unity MCP"
    Write-Host "  3. Accept the pending connection from Claude Code"
    Write-Host "  4. Test: run 'claude' and ask it to read the Unity console"
}

# --- Path B: Coplay MCP ---
function Setup-Coplay {
    Write-Info "Setting up Coplay MCP..."
    Write-Host ""

    # Check Python >= 3.11
    try {
        $pyVer = python --version 2>$null
        if ($pyVer) {
            $pyMinor = python -c "import sys; print(sys.version_info.minor)" 2>$null
            if ([int]$pyMinor -ge 11) {
                Write-Pass "Python found: $pyVer (>= 3.11)"
            } else {
                Write-Fail "Python >= 3.11 required, found: $pyVer"
                Write-Host "  Download from: https://www.python.org/downloads/"
                exit 1
            }
        } else {
            throw "not found"
        }
    } catch {
        Write-Fail "Python not found."
        Write-Host "  Download from: https://www.python.org/downloads/"
        exit 1
    }

    # Check/install uvx
    try {
        Get-Command uvx -ErrorAction Stop | Out-Null
        Write-Pass "uvx found"
    } catch {
        Write-Info "uvx not found. Installing uv..."
        try {
            pip install --user uv 2>$null
            Get-Command uvx -ErrorAction Stop | Out-Null
            Write-Pass "uvx installed successfully"
        } catch {
            Write-Fail "Could not install uvx automatically."
            Write-Host "  Install manually: pip install uv"
            exit 1
        }
    }

    if ($Force) {
        Write-Info "Removing existing coplay-mcp config..."
        claude mcp remove coplay-mcp 2>$null
    }

    Write-Info "Configuring Claude Code MCP connection..."
    try {
        claude mcp add `
            --scope user `
            --transport stdio `
            coplay-mcp `
            --env "MCP_TOOL_TIMEOUT=$Timeout" `
            -- uvx --python ">=3.11" "coplay-mcp-server@$CoplayVersion" 2>$null
        Write-Pass "coplay-mcp added to Claude Code"
    } catch {
        Write-Warn "Failed to add coplay-mcp. It may already exist. Use -Force to overwrite."
        return
    }

    Write-Host ""
    Write-Pass "Coplay MCP setup complete!"
    Write-Host ""
    Write-Host "  Next steps:"
    Write-Host "  1. Open your Unity project (2022+)"
    Write-Host "  2. Install Coplay: Window > Package Manager > + > Add from git URL"
    Write-Host "     URL: https://github.com/CoplayDev/unity-plugin.git#beta"
    Write-Host "  3. Enable Coplay in the Editor"
    Write-Host "  4. Test: run 'claude' and ask it to list open Unity editors"
}

# --- Execute ---
switch ($Path) {
    "unity"  { Setup-UnityOfficial }
    "coplay" { Setup-Coplay }
}

# --- Verify ---
Write-Host ""
Write-Info "Verifying MCP configuration..."
Write-Host "--- Configured MCP Servers ---" -ForegroundColor Cyan
try {
    claude mcp list 2>$null
} catch {
    Write-Warn "Could not list MCP servers."
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Setup complete!"                           -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
