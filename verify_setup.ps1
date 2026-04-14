# verify_setup.ps1 — Check prerequisites for Unity + Claude Code + MCP (Windows)

Write-Host "=== Unity + Claude Code + MCP — Setup Verification ===" -ForegroundColor Cyan
Write-Host ""

# 1. Claude Code
try {
    $claudeVer = claude --version 2>$null
    if ($claudeVer) {
        Write-Host "[PASS] Claude Code found: $claudeVer" -ForegroundColor Green
    } else {
        throw "not found"
    }
} catch {
    Write-Host "[FAIL] Claude Code not found." -ForegroundColor Red
    Write-Host "       Install: irm https://claude.ai/install.ps1 | iex" -ForegroundColor Yellow
}

# 2. Git for Windows
try {
    $gitVer = git --version 2>$null
    if ($gitVer) {
        Write-Host "[PASS] Git found: $gitVer" -ForegroundColor Green
    } else {
        throw "not found"
    }
} catch {
    Write-Host "[FAIL] Git for Windows not found (required for Claude Code on Windows)." -ForegroundColor Red
    Write-Host "       Download: https://git-scm.com/download/win" -ForegroundColor Yellow
}

# 3. Python (needed for Coplay MCP)
try {
    $pyVer = python --version 2>$null
    if ($pyVer) {
        Write-Host "[PASS] Python found: $pyVer" -ForegroundColor Green
        $pyMinor = python -c "import sys; print(sys.version_info.minor)" 2>$null
        if ([int]$pyMinor -ge 11) {
            Write-Host "[PASS] Python >= 3.11 (required for Coplay MCP)" -ForegroundColor Green
        } else {
            Write-Host "[WARN] Python < 3.11 detected. Coplay MCP requires >= 3.11." -ForegroundColor Yellow
        }
    } else {
        throw "not found"
    }
} catch {
    Write-Host "[WARN] Python not found. Required only for Coplay MCP path." -ForegroundColor Yellow
}

# 4. uvx (needed for Coplay MCP)
try {
    $uvxCheck = Get-Command uvx -ErrorAction Stop
    Write-Host "[PASS] uvx found" -ForegroundColor Green
} catch {
    Write-Host "[WARN] uvx not found. Install: pip install uv (required for Coplay MCP)" -ForegroundColor Yellow
}

# 5. Unity relay binary (needed for Unity Official MCP)
$relayDir = Join-Path $env:USERPROFILE ".unity\relay"
if (Test-Path $relayDir) {
    Write-Host "[PASS] Unity relay directory found: $relayDir" -ForegroundColor Green
    $relayExe = Join-Path $relayDir "relay_win.exe"
    if (Test-Path $relayExe) {
        Write-Host "[PASS] Unity relay binary found (Windows)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] relay_win.exe not found. Open a Unity 6+ project to auto-install." -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARN] Unity relay directory not found at $relayDir" -ForegroundColor Yellow
    Write-Host "       Expected if you haven't opened a Unity 6+ project yet." -ForegroundColor Yellow
}

# 6. MCP servers list
Write-Host ""
Write-Host "--- Configured MCP Servers ---" -ForegroundColor Cyan
try {
    claude mcp list 2>$null
} catch {
    Write-Host "[WARN] Could not list MCP servers. Run 'claude mcp list' manually." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Verification complete ===" -ForegroundColor Cyan
