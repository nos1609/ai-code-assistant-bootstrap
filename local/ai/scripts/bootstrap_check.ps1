#!/usr/bin/env pwsh
# RU: Скрипт проверяет README-комментарий, симлинки, .git/info/exclude и формат логов ассистентов.
# EN: Script validates README comment, symlinks, .git/info/exclude, and assistant log format.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$failures = @()

function Write-Ok([string]$ru, [string]$en) {
    Write-Host "[OK] $ru / $en"
}

function Write-Fail([string]$ru, [string]$en) {
    Write-Host "[FAIL] $ru / $en"
    $script:failures += $en
}

function Write-Warn([string]$ru, [string]$en) {
    Write-Host "[WARN] $ru / $en"
}

if (-not (Test-Path README.md)) {
    Write-Fail "README.md не найден" "README.md missing"
} elseif (-not (Select-String -LiteralPath README.md -Pattern "AI AGENT PROTOCOL TRIGGER" -Quiet)) {
    Write-Fail "Скрытый фрагмент README отсутствует" "README snippet missing"
} else {
    Write-Ok "Найден скрытый фрагмент README" "README snippet found"
}

$links = @(
    ".github/copilot-instructions.md",
    ".gemini/GEMINI.md",
    "GEMINI.md",
    "QWEN.md",
    ".qwen/QWEN.md"
)

foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link)) {
        Write-Fail "$link отсутствует" "$link missing"
        continue
    }
    $item = Get-Item -LiteralPath $link -ErrorAction SilentlyContinue
    if ($null -eq $item -or $item.LinkType -ne "SymbolicLink" -or $item.Target -notlike "*AGENTS.md") {
        Write-Fail "$link не указывает на AGENTS.md" "$link not pointing to AGENTS.md"
    } else {
        Write-Ok "$link указывает на AGENTS.md" "$link -> $($item.Target)"
    }
}

$patterns = @()
$readyFile = "local/ai/bootstrap.ready"
if (-not (Test-Path -LiteralPath $readyFile)) {
    Write-Fail "local/ai/bootstrap.ready отсутствует" "local/ai/bootstrap.ready missing"
} else {
    foreach ($line in Get-Content -LiteralPath $readyFile) {
        if (-not [string]::IsNullOrWhiteSpace($line) -and $line -ne "true") {
            $patterns += $line
        }
    }
    if (-not $patterns) {
        Write-Fail "local/ai/bootstrap.ready не содержит списка exclude" "local/ai/bootstrap.ready missing exclude list"
    }
}

$ignoreFile = $null
if (Test-Path -LiteralPath ".git/info/exclude") {
    $ignoreFile = ".git/info/exclude"
} elseif (Test-Path -LiteralPath ".git") {
    Write-Fail ".git/info/exclude отсутствует" ".git/info/exclude missing"
} else {
    Write-Warn "Git не инициализирован; проверка ignore-файла пропущена" "Git not initialized; ignore check skipped"
}

if ($ignoreFile -and $patterns.Count -gt 0) {
    $missingPattern = $false
    foreach ($pat in $patterns) {
        if (-not (Select-String -LiteralPath $ignoreFile -Pattern ([regex]::Escape($pat)) -Quiet)) {
            Write-Fail "$ignoreFile не содержит $pat" "$ignoreFile missing $pat"
            $missingPattern = $true
        }
    }
    if (-not $missingPattern) {
        Write-Ok "$ignoreFile скрывает служебные файлы" "$ignoreFile covers assistant artifacts"
    }
}

$logs = Get-ChildItem -Path "local/ai" -Filter "*.log" -Recurse -ErrorAction SilentlyContinue
if (-not $logs) {
    Write-Warn "Логи ассистентов не найдены в local/" "No assistant logs found under local/"
} else {
    foreach ($log in $logs) {
        if (-not (Select-String -LiteralPath $log.FullName -Pattern '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z' -Quiet)) {
            Write-Fail "$($log.FullName) не содержит ISO 8601 UTC" "$($log.FullName) missing ISO timestamps"
        } else {
            Write-Ok "$($log.FullName) содержит ISO 8601 UTC" "$($log.FullName) format valid"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Error ("Bootstrap проверка провалена / Bootstrap check failed: " + ($failures -join ", "))
    exit 1
}

Write-Host "Bootstrap проверка пройдена / Bootstrap check passed"
