#!/usr/bin/env pwsh
# bootstrap.ps1
# One-time setup: installs init-project.ps1 to your PowerShell profile
# so you can run it from anywhere.
#
# Usage (run once):
#   irm https://raw.githubusercontent.com/Sahagan/sahagan_agent_template/main/scripts/bootstrap.ps1 | iex
#
# After bootstrap, from any folder:
#   init-project my-project
#   init-project my-project https://github.com/user/repo.git
#   init-project my-project https://github.com/user/repo.git D:\projects

param(
    [string]$InstallDir = "$HOME\.sahagan\scripts"
)

$ErrorActionPreference = "Stop"
$RAW_BASE = "https://raw.githubusercontent.com/Sahagan/sahagan_agent_template/main/scripts"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   Sahagan Agent Template — Bootstrap     ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ─── Step 1: Download init-project.ps1 ────────────────────────────────────────

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
$scriptPath = Join-Path $InstallDir "init-project.ps1"

Write-Host "  [1/3] Downloading init-project.ps1..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "$RAW_BASE/init-project.ps1" -OutFile $scriptPath
Write-Host "  [1/3] Saved to: $scriptPath" -ForegroundColor Green

# ─── Step 2: Add function to PowerShell profile ───────────────────────────────

Write-Host "  [2/3] Adding 'init-project' to PowerShell profile..." -ForegroundColor Yellow

$profileDir = Split-Path $PROFILE -Parent
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

$functionBlock = @"

# ── Sahagan Agent Template ──────────────────────────────────────────────────
function init-project {
    param(
        [Parameter(Mandatory=`$true)][string]`$ProjectName,
        [string]`$RepoUrl = "",
        [string]`$OutputDir = `$PWD
    )
    & "$scriptPath" -ProjectName `$ProjectName -RepoUrl `$RepoUrl -OutputDir `$OutputDir
}
# ────────────────────────────────────────────────────────────────────────────
"@

# Check if already installed
$profileContent = if (Test-Path $PROFILE) { Get-Content $PROFILE -Raw } else { "" }
if ($profileContent -notlike "*Sahagan Agent Template*") {
    Add-Content -Path $PROFILE -Value $functionBlock -Encoding UTF8
    Write-Host "  [2/3] Profile updated: $PROFILE" -ForegroundColor Green
} else {
    Write-Host "  [2/3] Already installed in profile (skipped)" -ForegroundColor DarkGray
}

# ─── Step 3: Load for current session ─────────────────────────────────────────

Write-Host "  [3/3] Loading for current session..." -ForegroundColor Yellow
function init-project {
    param(
        [Parameter(Mandatory=$true)][string]$ProjectName,
        [string]$RepoUrl = "",
        [string]$OutputDir = $PWD
    )
    & $scriptPath -ProjectName $ProjectName -RepoUrl $RepoUrl -OutputDir $OutputDir
}
Write-Host "  [3/3] Ready in this session" -ForegroundColor Green

# ─── Done ─────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║   Bootstrap complete!                    ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  From now on, run from ANY folder:" -ForegroundColor Cyan
Write-Host ""
Write-Host "    init-project my-project" -ForegroundColor White
Write-Host "    init-project my-project https://github.com/user/repo.git" -ForegroundColor White
Write-Host "    init-project my-project https://github.com/user/repo.git D:\projects" -ForegroundColor White
Write-Host ""
Write-Host "  (Restarts PowerShell to activate in new terminals)" -ForegroundColor DarkGray
Write-Host ""
