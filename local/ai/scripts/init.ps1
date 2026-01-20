#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..\\..")
Set-Location $repoRoot

# Ensure directories for symlink targets exist.
New-Item -ItemType Directory -Force .github, .gemini, .qwen | Out-Null

# Ensure local temp workspace exists.
New-Item -ItemType Directory -Force "tmp/ai" | Out-Null

# Refresh symlinks so every assistant reads the same instructions.
$links = @(
    @{ Path = ".github/copilot-instructions.md"; Target = "../AGENTS.md" },
    @{ Path = ".gemini/GEMINI.md"; Target = "../AGENTS.md" },
    @{ Path = "GEMINI.md"; Target = "AGENTS.md" },
    @{ Path = "QWEN.md"; Target = "AGENTS.md" },
    @{ Path = ".qwen/QWEN.md"; Target = "../AGENTS.md" }
)
foreach ($link in $links) {
    if (Test-Path -LiteralPath $link.Path) {
        Remove-Item -LiteralPath $link.Path -Force
    }
    New-Item -ItemType SymbolicLink -Path $link.Path -Target $link.Target | Out-Null
}

# Pick ignore file: use .git/info/exclude when this is a git repo.
$ignoreFile = $null
if (Test-Path -LiteralPath ".git") {
    New-Item -ItemType Directory -Force ".git/info" | Out-Null
    $ignoreFile = ".git/info/exclude"
    if (-not (Test-Path -LiteralPath $ignoreFile)) {
        New-Item -ItemType File -Force $ignoreFile | Out-Null
    }
} else {
    Write-Host "Warning: .git not found; skip exclude entries (use .git/info/exclude after git init)."
}

function Ensure-IgnoreEntry {
    param([string]$Entry)
    if (-not $ignoreFile) {
        return
    }
    if (-not (Select-String -LiteralPath $ignoreFile -Pattern ([regex]::Escape($Entry)) -Quiet)) {
        Add-Content -LiteralPath $ignoreFile -Value $Entry
        Write-Host "Added '$Entry' to $ignoreFile"
    }
}

function Get-ExcludePatterns {
    $file = ".gitignore"
    if (-not (Test-Path -LiteralPath $file)) {
        Write-Host "Warning: .gitignore not found; skip exclude entries."
        return @()
    }
    $patterns = @()
    $inBlock = $false
    foreach ($line in Get-Content -LiteralPath $file) {
        if ($line -like "# BEGIN EXCLUDE LIST (for .git/info/exclude)*") {
            $inBlock = $true
            continue
        }
        if ($line -like "# END EXCLUDE LIST*") {
            $inBlock = $false
            break
        }
        if ($inBlock -and $line.StartsWith("#")) {
            $entry = $line.Substring(1).TrimStart()
            if ($entry) {
                $patterns += $entry
            }
        }
    }
    return $patterns
}

$patterns = Get-ExcludePatterns
foreach ($entry in $patterns) {
    Ensure-IgnoreEntry $entry
}

# Remind about README snippet.
if (Test-Path -LiteralPath "README.md") {
    if (-not (Select-String -LiteralPath "README.md" -Pattern "AI AGENT PROTOCOL TRIGGER" -Quiet)) {
        Write-Host "Reminder: add the hidden README snippet for assistants (see README_snippet.md)."
    } else {
        Write-Host "README already contains the hidden assistant snippet."
    }
} else {
    Write-Host "README.md not found."
}

Write-Host "Reminder: prepare local/ai/<assistant>/ sessions.log and requests.log (JSONL, ISO 8601 UTC)."

# Readiness marker
New-Item -ItemType Directory -Force "local/ai" | Out-Null
$readyLines = @("true")
if (Test-Path -LiteralPath ".gitignore") {
    $inBlock = $false
    foreach ($line in Get-Content -LiteralPath ".gitignore") {
        if ($line -like "# BEGIN EXCLUDE LIST (for .git/info/exclude)*") {
            $inBlock = $true
            continue
        }
        if ($line -like "# END EXCLUDE LIST*") {
            $inBlock = $false
            break
        }
        if ($inBlock -and $line.StartsWith("#")) {
            $entry = $line.Substring(1).TrimStart()
            if ($entry) {
                $readyLines += $entry
            }
        }
    }
}
Set-Content -LiteralPath "local/ai/bootstrap.ready" -Value $readyLines
Write-Host "local/ai/bootstrap.ready set"

# Ensure readiness block exists in chat_context.
$chatContext = "local/ai/chat_context.md"
if (Test-Path -LiteralPath $chatContext) {
    if (-not (Select-String -LiteralPath $chatContext -Pattern "## Статус готовности / Readiness status" -SimpleMatch -Quiet)) {
        $block = @"
## Статус готовности / Readiness status
- `status`: `pending`
- `last_verified_at`: `YYYY-MM-DDTHH:MM:SSZ`
- `agents_md_hash`: `sha256:<fill-after-bootstrap>`
- **RU:** После выполнения bootstrap-проверок обнови статус на `completed`, зафиксируй время (UTC) и актуальный хеш `AGENTS.md`; когда протокол пересматривается, перезапиши значения.
  **EN:** Once bootstrap checks pass, switch the status to `completed`, record the UTC timestamp, and store the current `AGENTS.md` hash; refresh the fields whenever the protocol is revisited.

"@
        $existing = Get-Content -LiteralPath $chatContext -Raw
        Set-Content -LiteralPath $chatContext -Value ($block + $existing)
        Write-Host "Readiness block injected into $chatContext"
    }
}

Write-Host "Agent template bootstrap complete."
