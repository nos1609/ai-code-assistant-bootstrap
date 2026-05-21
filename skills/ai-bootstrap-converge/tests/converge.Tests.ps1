$SkillRoot = Split-Path -Parent $PSScriptRoot
$ConvergeScript = Join-Path $SkillRoot 'scripts/converge.ps1'

function New-TestTemplate {
    param([string]$Root)
    New-Item -ItemType Directory -Force -Path (Join-Path $Root 'local/ai/agents') | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $Root 'local/ai/scripts') | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $Root 'local/ai/codex') | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $Root 'skills/ai-bootstrap-converge') | Out-Null
    Set-Content -LiteralPath (Join-Path $Root 'AGENTS.md') -Value 'template agents' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $Root 'README_snippet.md') -Value '<!-- ai-bootstrap -->' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $Root 'local/ai/agents/01-bootstrap.md') -Value 'bootstrap module' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $Root 'local/ai/scripts/init.ps1') -Value 'Write-Output init' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $Root 'local/ai/chat_context.md') -Value 'template chat context' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $Root 'local/ai/codex/requests.log') -Value '{"timestamp":"YYYY-MM-DDTHH:MM:SSZ"}' -Encoding utf8NoBOM
    Set-Content -LiteralPath (Join-Path $Root 'skills/ai-bootstrap-converge/SKILL.md') -Value 'canonical skill' -Encoding utf8NoBOM
    @'
# BEGIN EXCLUDE LIST (for .git/info/exclude)
# AGENTS.md
# local/ai/
# tmp/ai/
# END EXCLUDE LIST
'@ | Set-Content -LiteralPath (Join-Path $Root '.gitignore') -Encoding utf8NoBOM
}

Describe 'ai-bootstrap-converge converge.ps1' {
    It 'plans missing framework files without writing in Plan mode' {
        $case = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-bootstrap-test-" + [guid]::NewGuid().ToString('N'))
        $template = Join-Path $case 'template'
        $target = Join-Path $case 'target'
        New-Item -ItemType Directory -Force -Path $template, $target | Out-Null
        try {
            New-TestTemplate $template
            Set-Content -LiteralPath (Join-Path $target 'README.md') -Value '# Project' -Encoding utf8NoBOM

            $json = & pwsh -NoProfile -File $ConvergeScript -Mode Plan -Target $target -Template $template -Json
            $LASTEXITCODE | Should Be 0
            $ops = $json | ConvertFrom-Json
            @($ops | Where-Object Path -eq 'AGENTS.md' | Where-Object Status -eq 'MISSING').Count | Should Be 1
            Test-Path -LiteralPath (Join-Path $target 'AGENTS.md') | Should Be $false
            @($ops | Where-Object Path -eq 'skills\ai-bootstrap-converge\SKILL.md' | Where-Object Status -eq 'MISSING').Count | Should Be 1
            @($ops | Where-Object Path -eq '.agents/skills/ai-bootstrap-converge' | Where-Object Type -eq 'EnsureSkillDiscoveryLink').Count | Should Be 1
        } finally {
            Remove-Item -LiteralPath $case -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'applies safe framework operations while preserving existing local context' {
        $case = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-bootstrap-test-" + [guid]::NewGuid().ToString('N'))
        $template = Join-Path $case 'template'
        $target = Join-Path $case 'target'
        New-Item -ItemType Directory -Force -Path $template, $target | Out-Null
        try {
            New-TestTemplate $template
            git -C $target init | Out-Null
            New-Item -ItemType Directory -Force -Path (Join-Path $target 'local/ai') | Out-Null
            Set-Content -LiteralPath (Join-Path $target 'local/ai/chat_context.md') -Value 'project context' -Encoding utf8NoBOM
            Set-Content -LiteralPath (Join-Path $target 'README.md') -Value '# Project' -Encoding utf8NoBOM

            $json = & pwsh -NoProfile -File $ConvergeScript -Mode Apply -Target $target -Template $template -Json
            $exitCode = $LASTEXITCODE
            ((0, 2) -contains $exitCode) | Should Be $true
            $ops = $json | ConvertFrom-Json

            Get-Content -Raw -LiteralPath (Join-Path $target 'local/ai/chat_context.md') | Should Be "project context`r`n"
            Get-Content -Raw -LiteralPath (Join-Path $target 'README.md') | Should Match '<!-- ai-bootstrap -->'
            (@(Get-Content -LiteralPath (Join-Path $target '.git/info/exclude')) -contains 'tmp/ai/') | Should Be $true
            Test-Path -LiteralPath (Join-Path $target '.github/copilot-instructions.md') | Should Be $true
            Test-Path -LiteralPath (Join-Path $target 'skills/ai-bootstrap-converge/SKILL.md') | Should Be $true
            if ($exitCode -eq 0) {
                (Get-Item -LiteralPath (Join-Path $target '.agents/skills/ai-bootstrap-converge') -Force).LinkType | Should Be 'SymbolicLink'
                (Get-Item -LiteralPath (Join-Path $target '.claude/skills/ai-bootstrap-converge') -Force).LinkType | Should Be 'SymbolicLink'
            } else {
                (@($ops | Where-Object Type -eq 'EnsureSkillDiscoveryLink' | Where-Object Status -eq 'BLOCKED').Count -gt 0) | Should Be $true
            }
        } finally {
            Remove-Item -LiteralPath $case -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'reports conflict instead of overwriting existing managed file' {
        $case = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-bootstrap-test-" + [guid]::NewGuid().ToString('N'))
        $template = Join-Path $case 'template'
        $target = Join-Path $case 'target'
        New-Item -ItemType Directory -Force -Path $template, $target | Out-Null
        try {
            New-TestTemplate $template
            Set-Content -LiteralPath (Join-Path $target 'AGENTS.md') -Value 'custom agents' -Encoding utf8NoBOM

            $json = & pwsh -NoProfile -File $ConvergeScript -Mode Plan -Target $target -Template $template -Json
            $ops = $json | ConvertFrom-Json
            @($ops | Where-Object Path -eq 'AGENTS.md' | Where-Object Status -eq 'CONFLICT').Count | Should Be 1
            Get-Content -Raw -LiteralPath (Join-Path $target 'AGENTS.md') | Should Be "custom agents`r`n"
        } finally {
            Remove-Item -LiteralPath $case -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
