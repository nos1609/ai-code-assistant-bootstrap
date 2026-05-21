[CmdletBinding()]
param(
    [ValidateSet("Audit", "Plan", "Apply", "Verify")]
    [string]$Mode = "Audit",

    [string]$Target = ".",

    [string]$Template = $env:AI_BOOTSTRAP_TEMPLATE,

    [string]$SourceRef = "",

    [switch]$IncludeClaude,

    [switch]$ForceManagedExact,

    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:Operations = New-Object System.Collections.Generic.List[object]
$script:TemplateScratch = $null

function Resolve-Directory([string]$Path, [string]$Label) {
    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw "$Label path is required."
    }
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        throw "$Label path does not exist or is not a directory: $Path"
    }
    return (Resolve-Path -LiteralPath $Path).Path
}

function Add-Operation {
    param(
        [string]$Status,
        [string]$Type,
        [string]$Path,
        [string]$Detail,
        [bool]$Safe = $false
    )
    $script:Operations.Add([pscustomobject]@{
        Status = $Status
        Type = $Type
        Path = $Path
        Detail = $Detail
        Safe = $Safe
    }) | Out-Null
}

function Get-RelativePath([string]$Base, [string]$Path) {
    $baseUri = [Uri]((Resolve-Path -LiteralPath $Base).Path.TrimEnd('\') + '\')
    $pathUri = [Uri]((Resolve-Path -LiteralPath $Path).Path)
    return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($pathUri).ToString()).Replace('/', '\')
}

function Read-Text([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Write-Text([string]$Path, [string]$Text) {
    $dir = Split-Path -Parent $Path
    if ($dir) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Copy-FileExact([string]$Source, [string]$Destination) {
    $dir = Split-Path -Parent $Destination
    if ($dir) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
}

function Resolve-TemplateRoot {
    param([string]$TemplateValue, [string]$Ref)

    if ([string]::IsNullOrWhiteSpace($TemplateValue)) {
        throw "Template is required. Pass -Template or set AI_BOOTSTRAP_TEMPLATE."
    }

    if (Test-Path -LiteralPath $TemplateValue -PathType Container) {
        return (Resolve-Path -LiteralPath $TemplateValue).Path
    }

    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        throw "Template '$TemplateValue' is not a local directory and git is unavailable."
    }

    $scratchRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-bootstrap-template-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $scratchRoot | Out-Null
    $script:TemplateScratch = $scratchRoot

    if ([string]::IsNullOrWhiteSpace($Ref)) {
        & git clone --depth 1 $TemplateValue $scratchRoot | Out-Null
    } else {
        & git clone --depth 1 --branch $Ref $TemplateValue $scratchRoot | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Remove-Item -LiteralPath $scratchRoot -Recurse -Force -ErrorAction SilentlyContinue
            $scratchRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-bootstrap-template-" + [guid]::NewGuid().ToString("N"))
            $script:TemplateScratch = $scratchRoot
            & git clone $TemplateValue $scratchRoot | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "git clone failed for template: $TemplateValue" }
            & git -C $scratchRoot checkout $Ref | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "git checkout failed for template ref: $Ref" }
        }
    }

    if ($LASTEXITCODE -ne 0) {
        throw "git clone failed for template: $TemplateValue"
    }
    return $scratchRoot
}

function Get-TemplateFilesByRoots {
    param([string]$TemplateRoot, [string[]]$Roots)
    $files = New-Object System.Collections.Generic.List[string]
    foreach ($root in $Roots) {
        $path = Join-Path $TemplateRoot $root
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            $files.Add($path) | Out-Null
        } elseif (Test-Path -LiteralPath $path -PathType Container) {
            Get-ChildItem -LiteralPath $path -Recurse -File -Force | ForEach-Object {
                $files.Add($_.FullName) | Out-Null
            }
        }
    }
    return $files
}

function Test-FileSame([string]$A, [string]$B) {
    if (-not (Test-Path -LiteralPath $A -PathType Leaf) -or -not (Test-Path -LiteralPath $B -PathType Leaf)) {
        return $false
    }
    $hashA = Get-FileHash -LiteralPath $A -Algorithm SHA256
    $hashB = Get-FileHash -LiteralPath $B -Algorithm SHA256
    return $hashA.Hash -eq $hashB.Hash
}

function Ensure-ManagedExact {
    param([string]$TemplateRoot, [string]$TargetRoot, [string]$Relative)
    $src = Join-Path $TemplateRoot $Relative
    $dst = Join-Path $TargetRoot $Relative
    if (-not (Test-Path -LiteralPath $dst -PathType Leaf)) {
        Add-Operation "MISSING" "EnsureManagedFile" $Relative "Create from template." $true
        if ($Mode -eq "Apply") { Copy-FileExact $src $dst }
        return
    }
    if (Test-FileSame $src $dst) {
        Add-Operation "OK" "EnsureManagedFile" $Relative "Matches template." $false
        return
    }
    if ($ForceManagedExact) {
        Add-Operation "DRIFT" "EnsureManagedFile" $Relative "Replace with template because -ForceManagedExact was set." $true
        if ($Mode -eq "Apply") { Copy-FileExact $src $dst }
    } else {
        Add-Operation "CONFLICT" "EnsureManagedFile" $Relative "Managed file differs. Preserve target content and merge manually, or rerun with -ForceManagedExact after approval." $false
    }
}

function Ensure-IfMissing {
    param([string]$TemplateRoot, [string]$TargetRoot, [string]$Relative)
    $src = Join-Path $TemplateRoot $Relative
    $dst = Join-Path $TargetRoot $Relative
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { return }
    if (Test-Path -LiteralPath $dst -PathType Leaf) {
        Add-Operation "OK" "EnsureIfMissing" $Relative "Existing project/local file preserved." $false
    } else {
        Add-Operation "MISSING" "EnsureIfMissing" $Relative "Create placeholder/sample from template." $true
        if ($Mode -eq "Apply") { Copy-FileExact $src $dst }
    }
}

function Get-ReadmeSnippet([string]$TemplateRoot) {
    $snippet = Join-Path $TemplateRoot "README_snippet.md"
    if (-not (Test-Path -LiteralPath $snippet -PathType Leaf)) {
        return ""
    }
    return Read-Text $snippet
}

function Ensure-ReadmeSnippet {
    param([string]$TargetRoot, [string]$Relative, [string]$Snippet)
    if ([string]::IsNullOrWhiteSpace($Snippet)) { return }
    $path = Join-Path $TargetRoot $Relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Add-Operation "MISSING" "EnsureSnippetPresent" $Relative "Create README containing the required hidden snippet." $true
        if ($Mode -eq "Apply") { Write-Text $path ($Snippet.TrimEnd() + [Environment]::NewLine) }
        return
    }
    $text = Read-Text $path
    if ($text.StartsWith($Snippet)) {
        Add-Operation "OK" "EnsureSnippetPresent" $Relative "Snippet is already at the top." $false
        return
    }
    if ($text.Contains($Snippet)) {
        Add-Operation "DRIFT" "EnsureSnippetPresent" $Relative "Move existing snippet to the top without changing README body." $true
        if ($Mode -eq "Apply") {
            $updated = $text.Replace($Snippet, "")
            Write-Text $path ($Snippet.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $updated.TrimStart())
        }
    } else {
        Add-Operation "MISSING" "EnsureSnippetPresent" $Relative "Insert required hidden snippet at the top." $true
        if ($Mode -eq "Apply") {
            Write-Text $path ($Snippet.TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $text)
        }
    }
}

function Get-TemplateExcludeLines([string]$TemplateRoot) {
    $gitignore = Join-Path $TemplateRoot ".gitignore"
    $required = New-Object System.Collections.Generic.List[string]
    if (Test-Path -LiteralPath $gitignore -PathType Leaf) {
        $inside = $false
        foreach ($line in Get-Content -LiteralPath $gitignore) {
            if ($line -match "BEGIN EXCLUDE LIST") { $inside = $true; continue }
            if ($line -match "END EXCLUDE LIST") { $inside = $false; continue }
            if ($inside) {
                $clean = $line -replace "^\s*#\s?", ""
                if (-not [string]::IsNullOrWhiteSpace($clean)) {
                    $required.Add($clean.Trim()) | Out-Null
                }
            }
        }
    }
    foreach ($extra in @(".codex/", "AGENTS.override.md")) {
        if (-not $required.Contains($extra)) { $required.Add($extra) | Out-Null }
    }
    return $required
}

function Ensure-ExcludeLines {
    param([string]$TargetRoot, [string[]]$Lines)
    $gitDir = Join-Path $TargetRoot ".git"
    if (-not (Test-Path -LiteralPath $gitDir)) {
        Add-Operation "SKIP" "EnsureExcludeLines" ".git/info/exclude" "Target is not a git worktree or .git is not present." $false
        return
    }
    $exclude = Join-Path $gitDir "info\exclude"
    $existing = @()
    if (Test-Path -LiteralPath $exclude -PathType Leaf) {
        $existing = @(Get-Content -LiteralPath $exclude)
    }
    foreach ($line in $Lines) {
        if ($existing -contains $line) {
            Add-Operation "OK" "EnsureExcludeLines" ".git/info/exclude" "Line present: $line" $false
        } else {
            Add-Operation "MISSING" "EnsureExcludeLines" ".git/info/exclude" "Append line: $line" $true
            if ($Mode -eq "Apply") {
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $exclude) | Out-Null
                $updated = @()
                if (Test-Path -LiteralPath $exclude -PathType Leaf) {
                    $updated = @(Get-Content -LiteralPath $exclude)
                }
                $updated += $line
                [System.IO.File]::WriteAllLines($exclude, [string[]]$updated, [System.Text.UTF8Encoding]::new($false))
                $existing += $line
            }
        }
    }
}

function Test-LinkOrSameContent {
    param([string]$Path, [string]$AgentPath)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    $linkType = $null
    if ($item.PSObject.Properties.Name -contains "LinkType") {
        $linkType = $item.LinkType
    }
    if ($linkType -eq "SymbolicLink") {
        $target = [string]$item.Target
        return ($target -eq "AGENTS.md" -or $target -eq "../AGENTS.md" -or $target.EndsWith("\AGENTS.md") -or $target.EndsWith("/AGENTS.md"))
    }
    if ((Test-Path -LiteralPath $Path -PathType Leaf) -and (Test-Path -LiteralPath $AgentPath -PathType Leaf)) {
        return Test-FileSame $Path $AgentPath
    }
    return $false
}

function New-AgentLink {
    param([string]$Path, [string]$RelativeTarget, [string]$HardlinkSource)
    $dir = Split-Path -Parent $Path
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    try {
        New-Item -ItemType SymbolicLink -Path $Path -Target $RelativeTarget -Force | Out-Null
    } catch {
        New-Item -ItemType HardLink -Path $Path -Target $HardlinkSource -Force | Out-Null
    }
}

function Test-DirectorySymlinkTarget {
    param([string]$Path, [string]$RelativeTarget)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    $linkType = $null
    if ($item.PSObject.Properties.Name -contains "LinkType") {
        $linkType = $item.LinkType
    }
    if ($linkType -ne "SymbolicLink") { return $false }
    $target = [string]$item.Target
    $normalizedTarget = $target.Replace("/", "\")
    $normalizedExpected = $RelativeTarget.Replace("/", "\")
    return ($normalizedTarget -eq $normalizedExpected -or $normalizedTarget.EndsWith("\skills\ai-bootstrap-converge"))
}

function Ensure-SkillDiscoveryLink {
    param([string]$TargetRoot, [string]$Relative, [string]$RelativeTarget)
    $path = Join-Path $TargetRoot $Relative
    if (Test-DirectorySymlinkTarget $path $RelativeTarget) {
        Add-Operation "OK" "EnsureSkillDiscoveryLink" $Relative "Symlink points to canonical skills/ai-bootstrap-converge." $false
        return
    }
    if (Test-Path -LiteralPath $path) {
        Add-Operation "CONFLICT" "EnsureSkillDiscoveryLink" $Relative "Path exists but is not the required symlink. Do not duplicate skill files here." $false
        return
    }
    Add-Operation "MISSING" "EnsureSkillDiscoveryLink" $Relative "Create symlink to ../../skills/ai-bootstrap-converge." $true
    if ($Mode -eq "Apply") {
        $dir = Split-Path -Parent $path
        if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
        try {
            New-Item -ItemType SymbolicLink -Path $path -Target $RelativeTarget -ErrorAction Stop | Out-Null
        } catch {
            Add-Operation "BLOCKED" "EnsureSkillDiscoveryLink" $Relative "Could not create directory symlink: $($_.Exception.Message)" $false
        }
    }
}

function Ensure-InstructionLink {
    param([string]$TargetRoot, [string]$Relative, [string]$RelativeTarget)
    $path = Join-Path $TargetRoot $Relative
    $agent = Join-Path $TargetRoot "AGENTS.md"
    if (Test-LinkOrSameContent $path $agent) {
        Add-Operation "OK" "EnsureInstructionLink" $Relative "Points to or matches AGENTS.md." $false
        return
    }
    if (Test-Path -LiteralPath $path) {
        Add-Operation "CONFLICT" "EnsureInstructionLink" $Relative "Existing instruction file differs. Preserve it and merge project-specific content before replacing." $false
        return
    }
    Add-Operation "MISSING" "EnsureInstructionLink" $Relative "Create symlink or hardlink to AGENTS.md." $true
    if ($Mode -eq "Apply") {
        New-AgentLink $path $RelativeTarget $agent
    }
}

function Get-InstructionLinks {
    param([string]$TemplateRoot, [switch]$WithClaude)
    $links = @(
        @{ Path = ".github/copilot-instructions.md"; Target = "../AGENTS.md" },
        @{ Path = ".gemini/GEMINI.md"; Target = "../AGENTS.md" },
        @{ Path = ".qwen/QWEN.md"; Target = "../AGENTS.md" },
        @{ Path = "GEMINI.md"; Target = "AGENTS.md" },
        @{ Path = "QWEN.md"; Target = "AGENTS.md" }
    )
    $templateHasClaude = (Test-Path -LiteralPath (Join-Path $TemplateRoot ".claude\CLAUDE.md")) -or (Test-Path -LiteralPath (Join-Path $TemplateRoot "CLAUDE.md"))
    if ($WithClaude -or $templateHasClaude) {
        $links += @{ Path = ".claude/CLAUDE.md"; Target = "../AGENTS.md" }
        $links += @{ Path = "CLAUDE.md"; Target = "AGENTS.md" }
    }
    return $links
}

function Get-EnsureIfMissingFiles {
    param([string]$TemplateRoot)
    $candidates = New-Object System.Collections.Generic.List[string]
    foreach ($relative in @(
        "local/ai/chat_context.md",
        "local/ai/project_addenda.md",
        "local/ai/session_history.md"
    )) {
        if (Test-Path -LiteralPath (Join-Path $TemplateRoot $relative) -PathType Leaf) {
            $candidates.Add($relative) | Out-Null
        }
    }
    $localAi = Join-Path $TemplateRoot "local\ai"
    if (Test-Path -LiteralPath $localAi -PathType Container) {
        Get-ChildItem -LiteralPath $localAi -Directory -Force | Where-Object {
            $_.Name -notin @("agents", "scripts", "context_packs", "session_summaries")
        } | ForEach-Object {
            foreach ($name in @("README.md", "requests.log", "sessions.log")) {
                $file = Join-Path $_.FullName $name
                if (Test-Path -LiteralPath $file -PathType Leaf) {
                    $candidates.Add((Get-RelativePath $TemplateRoot $file)) | Out-Null
                }
            }
        }
    }
    return $candidates
}

function Report-LocalOnlyTracked {
    param([string]$TargetRoot)
    $gitDir = Join-Path $TargetRoot ".git"
    if (-not (Test-Path -LiteralPath $gitDir)) { return }
    $patterns = @(
        "AGENTS.override.md",
        ".codex/",
        "tmp/ai/",
        "local/ai/session_summaries/",
        "local/ai/context_packs/",
        "local/ai/*/requests.log",
        "local/ai/*/sessions.log",
        "local/ai/*/*.session"
    )
    $tracked = @(& git -C $TargetRoot ls-files -- $patterns 2>$null)
    foreach ($path in $tracked) {
        if (-not [string]::IsNullOrWhiteSpace($path)) {
            Add-Operation "DRIFT" "ReportLocalOnlyTracked" $path "Local-only/runtime path is tracked by git; remove from index only after user approval." $false
        }
    }
}

function Build-Plan {
    param([string]$TargetRoot, [string]$TemplateRoot)

    $managedRoots = @(
        "AGENTS.md",
        "README_snippet.md",
        "local/ai/agents",
        "local/ai/scripts",
        "local/ai/bootstrap.ready",
        "skills/ai-bootstrap-converge"
    )
    foreach ($src in Get-TemplateFilesByRoots $TemplateRoot $managedRoots) {
        Ensure-ManagedExact $TemplateRoot $TargetRoot (Get-RelativePath $TemplateRoot $src)
    }

    foreach ($relative in Get-EnsureIfMissingFiles $TemplateRoot) {
        Ensure-IfMissing $TemplateRoot $TargetRoot $relative
    }

    $snippet = Get-ReadmeSnippet $TemplateRoot
    foreach ($readme in @("README.md", "README.en.md")) {
        Ensure-ReadmeSnippet $TargetRoot $readme $snippet
    }

    Ensure-ExcludeLines $TargetRoot (Get-TemplateExcludeLines $TemplateRoot)

    foreach ($link in Get-InstructionLinks $TemplateRoot $IncludeClaude) {
        Ensure-InstructionLink $TargetRoot $link.Path $link.Target
    }

    Ensure-SkillDiscoveryLink $TargetRoot ".agents/skills/ai-bootstrap-converge" "../../skills/ai-bootstrap-converge"
    Ensure-SkillDiscoveryLink $TargetRoot ".claude/skills/ai-bootstrap-converge" "../../skills/ai-bootstrap-converge"

    Report-LocalOnlyTracked $TargetRoot
}

try {
    $targetRoot = Resolve-Directory $Target "Target"
    $templateRoot = Resolve-TemplateRoot $Template $SourceRef
    Build-Plan $targetRoot $templateRoot

    if ($Json) {
        $script:Operations | ConvertTo-Json -Depth 4
    } else {
        $script:Operations |
            Sort-Object Status, Type, Path |
            Format-Table Status, Type, Path, Detail -AutoSize -Wrap
    }

    $bad = @($script:Operations | Where-Object {
        $_.Status -in @("MISSING", "DRIFT", "CONFLICT", "BLOCKED") -and
        -not ($Mode -eq "Apply" -and $_.Safe)
    })
    if ($Mode -eq "Verify" -and $bad.Count -gt 0) {
        exit 1
    }
    if ($Mode -eq "Apply") {
        $remaining = @($script:Operations | Where-Object { $_.Status -in @("CONFLICT", "BLOCKED") })
        if ($remaining.Count -gt 0) { exit 2 }
    }
} finally {
    if ($script:TemplateScratch -and (Test-Path -LiteralPath $script:TemplateScratch)) {
        Remove-Item -LiteralPath $script:TemplateScratch -Recurse -Force -ErrorAction SilentlyContinue
    }
}
