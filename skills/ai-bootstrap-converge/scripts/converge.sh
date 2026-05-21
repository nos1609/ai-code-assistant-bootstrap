#!/bin/sh
set -eu

mode="Audit"
target="."
template="${AI_BOOTSTRAP_TEMPLATE:-}"
source_ref=""
include_claude=0
force_managed=0
json=0
operations_file=""
template_scratch=""

usage() {
  cat <<'USAGE'
Usage: converge.sh --mode audit|plan|apply|verify --target <repo> --template <template-path-or-git-url> [--source-ref <ref>] [--include-claude] [--force-managed-exact] [--json]
USAGE
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

cleanup() {
  if [ -n "$template_scratch" ] && [ -d "$template_scratch" ]; then
    rm -rf "$template_scratch"
  fi
  if [ -n "$operations_file" ] && [ -f "$operations_file" ]; then
    rm -f "$operations_file"
  fi
}
trap cleanup EXIT INT TERM

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mode|-Mode)
      [ "$#" -ge 2 ] || die "--mode requires a value"
      case "$2" in
        audit|Audit) mode="Audit" ;;
        plan|Plan) mode="Plan" ;;
        apply|Apply) mode="Apply" ;;
        verify|Verify) mode="Verify" ;;
        *) die "unsupported mode: $2" ;;
      esac
      shift 2
      ;;
    --target|-Target)
      [ "$#" -ge 2 ] || die "--target requires a value"
      target=$2
      shift 2
      ;;
    --template|-Template)
      [ "$#" -ge 2 ] || die "--template requires a value"
      template=$2
      shift 2
      ;;
    --source-ref|-SourceRef)
      [ "$#" -ge 2 ] || die "--source-ref requires a value"
      source_ref=$2
      shift 2
      ;;
    --include-claude|-IncludeClaude)
      include_claude=1
      shift
      ;;
    --force-managed-exact|-ForceManagedExact)
      force_managed=1
      shift
      ;;
    --json|-Json)
      json=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[ -d "$target" ] || die "target path does not exist: $target"
target=$(cd "$target" && pwd)

resolve_template() {
  [ -n "$template" ] || die "template is required; pass --template or set AI_BOOTSTRAP_TEMPLATE"
  if [ -d "$template" ]; then
    (cd "$template" && pwd)
    return
  fi
  command -v git >/dev/null 2>&1 || die "template is not a directory and git is unavailable"
  template_scratch=$(mktemp -d "${TMPDIR:-/tmp}/ai-bootstrap-template.XXXXXX")
  if [ -n "$source_ref" ]; then
    if ! git clone --depth 1 --branch "$source_ref" "$template" "$template_scratch" >/dev/null 2>&1; then
      rm -rf "$template_scratch"
      template_scratch=$(mktemp -d "${TMPDIR:-/tmp}/ai-bootstrap-template.XXXXXX")
      git clone "$template" "$template_scratch" >/dev/null 2>&1 || die "git clone failed for template: $template"
      git -C "$template_scratch" checkout "$source_ref" >/dev/null 2>&1 || die "git checkout failed for template ref: $source_ref"
    fi
  else
    git clone --depth 1 "$template" "$template_scratch" >/dev/null 2>&1 || die "git clone failed for template: $template"
  fi
  printf '%s\n' "$template_scratch"
}

template_root=$(resolve_template)
operations_file=$(mktemp "${TMPDIR:-/tmp}/ai-bootstrap-ops.XXXXXX")

emit() {
  status=$1
  type=$2
  path=$3
  safe=$4
  detail=$5
  printf '%s\t%s\t%s\t%s\t%s\n' "$status" "$type" "$path" "$safe" "$detail" >> "$operations_file"
}

same_file() {
  [ -f "$1" ] && [ -f "$2" ] || return 1
  if command -v sha256sum >/dev/null 2>&1; then
    [ "$(sha256sum "$1" | awk '{print $1}')" = "$(sha256sum "$2" | awk '{print $1}')" ]
  else
    cmp -s "$1" "$2"
  fi
}

copy_exact() {
  src=$1
  dst=$2
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

ensure_managed_file() {
  rel=$1
  src=$template_root/$rel
  dst=$target/$rel
  [ -f "$src" ] || return 0
  if [ ! -f "$dst" ]; then
    emit "MISSING" "EnsureManagedFile" "$rel" "true" "Create from template."
    [ "$mode" = "Apply" ] && copy_exact "$src" "$dst"
  elif same_file "$src" "$dst"; then
    emit "OK" "EnsureManagedFile" "$rel" "false" "Matches template."
  elif [ "$force_managed" -eq 1 ]; then
    emit "DRIFT" "EnsureManagedFile" "$rel" "true" "Replace with template because force was set."
    [ "$mode" = "Apply" ] && copy_exact "$src" "$dst"
  else
    emit "CONFLICT" "EnsureManagedFile" "$rel" "false" "Managed file differs; preserve target content and merge manually."
  fi
}

managed_files() {
  for rel in AGENTS.md README_snippet.md local/ai/bootstrap.ready; do
    [ -f "$template_root/$rel" ] && printf '%s\n' "$rel"
  done
  for root in local/ai/agents local/ai/scripts skills/ai-bootstrap-converge; do
    if [ -d "$template_root/$root" ]; then
      (cd "$template_root" && find "$root" -type f | sort)
    fi
  done
}

ensure_if_missing() {
  rel=$1
  src=$template_root/$rel
  dst=$target/$rel
  [ -f "$src" ] || return 0
  if [ -f "$dst" ]; then
    emit "OK" "EnsureIfMissing" "$rel" "false" "Existing project/local file preserved."
  else
    emit "MISSING" "EnsureIfMissing" "$rel" "true" "Create placeholder/sample from template."
    [ "$mode" = "Apply" ] && copy_exact "$src" "$dst"
  fi
}

ensure_if_missing_files() {
  for rel in local/ai/chat_context.md local/ai/project_addenda.md local/ai/session_history.md; do
    [ -f "$template_root/$rel" ] && printf '%s\n' "$rel"
  done
  if [ -d "$template_root/local/ai" ]; then
    find "$template_root/local/ai" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r dir; do
      name=$(basename "$dir")
      case "$name" in
        agents|scripts|context_packs|session_summaries) continue ;;
      esac
      for file in README.md requests.log sessions.log; do
        [ -f "$dir/$file" ] && printf 'local/ai/%s/%s\n' "$name" "$file"
      done
    done
  fi
}

readme_snippet() {
  [ -f "$template_root/README_snippet.md" ] && cat "$template_root/README_snippet.md" || true
}

ensure_readme_snippet() {
  rel=$1
  snippet_file=$2
  [ -s "$snippet_file" ] || return 0
  path=$target/$rel
  if [ ! -f "$path" ]; then
    emit "MISSING" "EnsureSnippetPresent" "$rel" "true" "Create README containing required hidden snippet."
    if [ "$mode" = "Apply" ]; then
      mkdir -p "$(dirname "$path")"
      cat "$snippet_file" > "$path"
      printf '\n' >> "$path"
    fi
    return
  fi
  if awk 'NR==FNR { s=s $0 "\n"; next } { t=t $0 "\n" } END { exit(index(t, s) == 1 ? 0 : 1) }' "$snippet_file" "$path"; then
    emit "OK" "EnsureSnippetPresent" "$rel" "false" "Snippet is already at the top."
  elif awk 'NR==FNR { s=s $0 "\n"; next } { t=t $0 "\n" } END { exit(index(t, s) > 0 ? 0 : 1) }' "$snippet_file" "$path"; then
    emit "DRIFT" "EnsureSnippetPresent" "$rel" "true" "Move existing snippet to the top without changing README body."
    if [ "$mode" = "Apply" ]; then
      tmp=$(mktemp "${TMPDIR:-/tmp}/readme.XXXXXX")
      awk '
        NR==FNR { s=s $0 "\n"; next }
        { t=t $0 "\n" }
        END {
          pos=index(t, s)
          if (pos == 0) exit 1
          after=substr(t, pos + length(s))
          sub(/^[\r\n]+/, "", after)
          printf "%s\n\n%s", s, after
        }
      ' "$snippet_file" "$path" > "$tmp"
      mv "$tmp" "$path"
    fi
  else
    emit "MISSING" "EnsureSnippetPresent" "$rel" "true" "Insert required hidden snippet at the top."
    if [ "$mode" = "Apply" ]; then
      tmp=$(mktemp "${TMPDIR:-/tmp}/readme.XXXXXX")
      cat "$snippet_file" > "$tmp"
      printf '\n\n' >> "$tmp"
      cat "$path" >> "$tmp"
      mv "$tmp" "$path"
    fi
  fi
}

exclude_lines() {
  if [ -f "$template_root/.gitignore" ]; then
    awk '
      /BEGIN EXCLUDE LIST/ { inside=1; next }
      /END EXCLUDE LIST/ { inside=0; next }
      inside {
        sub(/^[[:space:]]*#[[:space:]]?/, "")
        if ($0 !~ /^[[:space:]]*$/) print $0
      }
    ' "$template_root/.gitignore"
  fi
  printf '%s\n' ".codex/" "AGENTS.override.md"
}

ensure_exclude_lines() {
  [ -e "$target/.git" ] || {
    emit "SKIP" "EnsureExcludeLines" ".git/info/exclude" "false" "Target is not a git worktree or .git is not present."
    return
  }
  exclude=$target/.git/info/exclude
  mkdir -p "$(dirname "$exclude")"
  [ -f "$exclude" ] || : > "$exclude"
  exclude_lines | while IFS= read -r line; do
    [ -n "$line" ] || continue
    if grep -Fx -- "$line" "$exclude" >/dev/null 2>&1; then
      emit "OK" "EnsureExcludeLines" ".git/info/exclude" "false" "Line present: $line"
    else
      emit "MISSING" "EnsureExcludeLines" ".git/info/exclude" "true" "Append line: $line"
      [ "$mode" = "Apply" ] && printf '%s\n' "$line" >> "$exclude"
    fi
  done
}

link_ok() {
  path=$1
  agent=$target/AGENTS.md
  [ -e "$path" ] || return 1
  if [ -L "$path" ]; then
    link_target=$(readlink "$path")
    [ "$link_target" = "AGENTS.md" ] || [ "$link_target" = "../AGENTS.md" ] || case "$link_target" in */AGENTS.md) true ;; *) false ;; esac
  elif [ -f "$path" ] && [ -f "$agent" ]; then
    same_file "$path" "$agent"
  else
    return 1
  fi
}

ensure_instruction_link() {
  rel=$1
  rel_target=$2
  path=$target/$rel
  agent=$target/AGENTS.md
  if link_ok "$path"; then
    emit "OK" "EnsureInstructionLink" "$rel" "false" "Points to or matches AGENTS.md."
  elif [ -e "$path" ]; then
    emit "CONFLICT" "EnsureInstructionLink" "$rel" "false" "Existing instruction file differs; preserve and merge before replacing."
  else
    emit "MISSING" "EnsureInstructionLink" "$rel" "true" "Create symlink or hardlink to AGENTS.md."
    if [ "$mode" = "Apply" ]; then
      mkdir -p "$(dirname "$path")"
      ln -s "$rel_target" "$path" 2>/dev/null || ln "$agent" "$path"
    fi
  fi
}

symlink_ok() {
  path=$1
  expected=$2
  [ -L "$path" ] || return 1
  link_target=$(readlink "$path")
  [ "$link_target" = "$expected" ] || case "$link_target" in */skills/ai-bootstrap-converge) true ;; *) false ;; esac
}

ensure_skill_discovery_link() {
  rel=$1
  rel_target=$2
  path=$target/$rel
  if symlink_ok "$path" "$rel_target"; then
    emit "OK" "EnsureSkillDiscoveryLink" "$rel" "false" "Symlink points to canonical skills/ai-bootstrap-converge."
  elif [ -e "$path" ]; then
    emit "CONFLICT" "EnsureSkillDiscoveryLink" "$rel" "false" "Path exists but is not the required symlink; do not duplicate skill files here."
  else
    emit "MISSING" "EnsureSkillDiscoveryLink" "$rel" "true" "Create symlink to ../../skills/ai-bootstrap-converge."
    if [ "$mode" = "Apply" ]; then
      mkdir -p "$(dirname "$path")"
      if ! ln -s "$rel_target" "$path" 2>/dev/null; then
        emit "BLOCKED" "EnsureSkillDiscoveryLink" "$rel" "false" "Could not create directory symlink."
      fi
    fi
  fi
}

instruction_links() {
  cat <<'LINKS'
.github/copilot-instructions.md	../AGENTS.md
.gemini/GEMINI.md	../AGENTS.md
.qwen/QWEN.md	../AGENTS.md
GEMINI.md	AGENTS.md
QWEN.md	AGENTS.md
LINKS
  if [ "$include_claude" -eq 1 ] || [ -e "$template_root/.claude/CLAUDE.md" ] || [ -e "$template_root/CLAUDE.md" ]; then
    printf '%s\t%s\n' ".claude/CLAUDE.md" "../AGENTS.md"
    printf '%s\t%s\n' "CLAUDE.md" "AGENTS.md"
  fi
}

report_local_only_tracked() {
  [ -e "$target/.git" ] || return 0
  git -C "$target" ls-files -- \
    AGENTS.override.md \
    .codex/ \
    tmp/ai/ \
    local/ai/session_summaries/ \
    local/ai/context_packs/ \
    'local/ai/*/requests.log' \
    'local/ai/*/sessions.log' \
    'local/ai/*/*.session' 2>/dev/null | while IFS= read -r path; do
      [ -n "$path" ] && emit "DRIFT" "ReportLocalOnlyTracked" "$path" "false" "Local-only/runtime path is tracked by git."
    done
}

snippet_tmp=$(mktemp "${TMPDIR:-/tmp}/ai-bootstrap-snippet.XXXXXX")
readme_snippet > "$snippet_tmp"

managed_files | while IFS= read -r rel; do ensure_managed_file "$rel"; done
ensure_if_missing_files | while IFS= read -r rel; do ensure_if_missing "$rel"; done
ensure_readme_snippet "README.md" "$snippet_tmp"
ensure_readme_snippet "README.en.md" "$snippet_tmp"
rm -f "$snippet_tmp"
ensure_exclude_lines
instruction_links | while IFS="$(printf '\t')" read -r rel rel_target; do
  [ -n "$rel" ] && ensure_instruction_link "$rel" "$rel_target"
done
ensure_skill_discovery_link ".agents/skills/ai-bootstrap-converge" "../../skills/ai-bootstrap-converge"
ensure_skill_discovery_link ".claude/skills/ai-bootstrap-converge" "../../skills/ai-bootstrap-converge"
report_local_only_tracked

if [ "$json" -eq 1 ]; then
  awk -F '\t' 'BEGIN { print "[" } {
    gsub(/\\/,"\\\\",$3); gsub(/"/,"\\\"",$3); gsub(/\\/,"\\\\",$5); gsub(/"/,"\\\"",$5);
    printf "%s{\"Status\":\"%s\",\"Type\":\"%s\",\"Path\":\"%s\",\"Safe\":%s,\"Detail\":\"%s\"}", sep, $1, $2, $3, $4, $5;
    sep=","
  } END { print "]" }' "$operations_file"
else
  printf '%-10s %-24s %-45s %s\n' "Status" "Type" "Path" "Detail"
  sort "$operations_file" | awk -F '\t' '{ printf "%-10s %-24s %-45s %s\n", $1, $2, $3, $5 }'
fi

if [ "$mode" = "Verify" ]; then
  if awk -F '\t' '$1 == "MISSING" || $1 == "DRIFT" || $1 == "CONFLICT" || $1 == "BLOCKED" { found=1 } END { exit(found ? 0 : 1) }' "$operations_file"; then
    exit 1
  fi
fi

if [ "$mode" = "Apply" ]; then
  if awk -F '\t' '$1 == "CONFLICT" || $1 == "BLOCKED" { found=1 } END { exit(found ? 0 : 1) }' "$operations_file"; then
    exit 2
  fi
fi
