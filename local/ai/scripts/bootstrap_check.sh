#!/usr/bin/env bash
# RU: Проверяет базовые bootstrap-требования (README комментарий, симлинки, .git/info/exclude, логи).
# EN: Verifies baseline bootstrap requirements (README comment, symlinks, .git/info/exclude, logs).
set -euo pipefail

if command -v rg >/dev/null 2>&1; then
  USE_RG=1
else
  USE_RG=0
fi

contains_fixed() {
  local pattern=$1
  local file=$2
  if [[ $USE_RG -eq 1 ]]; then
    rg --hidden --no-ignore -F "$pattern" "$file" >/dev/null
  else
    grep -Fq "$pattern" "$file"
  fi
}

contains_fixed_gitignore() {
  local pattern=$1
  local file=$2
  if [[ $USE_RG -eq 1 ]]; then
    rg -F --no-ignore "$pattern" "$file" >/dev/null
  else
    grep -Fq "$pattern" "$file"
  fi
}

matches_iso() {
  local file=$1
  if [[ $USE_RG -eq 1 ]]; then
    rg -q '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z' "$file"
  else
    grep -Eq '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z' "$file"
  fi
}

ok() {
  echo "[OK] $1 / $2"
}

fail() {
  echo "[FAIL] $1 / $2"
  failures+=("$2")
}

warn() {
  echo "[WARN] $1 / $2"
}

failures=()

check_readme() {
  # RU: Ищем скрытый HTML-комментарий из README_snippet.md.
  # EN: Ensure the hidden README snippet from README_snippet.md exists.
  if contains_fixed "AI AGENT PROTOCOL TRIGGER" README.md; then
    ok "Найден скрытый фрагмент README" "README snippet found"
  else
    fail "Скрытый фрагмент README отсутствует" "README snippet missing"
  fi
}

check_symlink() {
  # RU: Проверяем, что симлинк существует и указывает на AGENTS.md.
  # EN: Verify the symlink exists and points to AGENTS.md.
  local path=$1
  if [[ -L "$path" ]] && [[ "$(readlink "$path")" == *"AGENTS.md" ]]; then
    ok "$path указывает на AGENTS.md" "$path -> $(readlink "$path")"
  else
    fail "$path не связан с AGENTS.md" "$path not linked to AGENTS.md"
  fi
}

check_symlinks() {
  # RU: Прогоняем все обязательные симлинки ассистентов.
  # EN: Iterate through all required assistant symlinks.
  local links=(
    ".github/copilot-instructions.md"
    ".gemini/GEMINI.md"
    "GEMINI.md"
    "QWEN.md"
    ".qwen/QWEN.md"
  )
  for link in "${links[@]}"; do
    check_symlink "$link"
  done
}

load_patterns_from_bootstrap_ready() {
  local file="local/ai/bootstrap.ready"
  patterns=()
  if [[ ! -f "$file" ]]; then
    fail "local/ai/bootstrap.ready отсутствует" "local/ai/bootstrap.ready missing"
    return 1
  fi
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    [[ "$line" == "true" ]] && continue
    patterns+=("$line")
  done < "$file"
  if [[ ${#patterns[@]} -eq 0 ]]; then
    fail "local/ai/bootstrap.ready не содержит списка exclude" "local/ai/bootstrap.ready missing exclude list"
    return 1
  fi
  return 0
}

check_gitignore() {
  # RU: Убеждаемся, что .git/info/exclude скрывает служебные файлы ассистента.  
  # EN: Confirm .git/info/exclude hides all assistant artifacts.
  local ignore_file=""
  if ! load_patterns_from_bootstrap_ready; then
    return
  fi
  if [[ -f ".git/info/exclude" ]]; then
    ignore_file=".git/info/exclude"
  elif [[ -d ".git" ]]; then
    fail "Файл .git/info/exclude отсутствует" ".git/info/exclude missing"
    return
  else
    warn "Git не инициализирован; проверка ignore-файла пропущена" "Git not initialized; ignore check skipped"
    return
  fi
  local missing=0
  for pat in "${patterns[@]}"; do
    if ! contains_fixed_gitignore "$pat" "$ignore_file"; then
      fail "$ignore_file не содержит $pat" "$ignore_file missing $pat"
      missing=1
    fi
  done
  if [[ $missing -eq 0 ]]; then
    ok "$ignore_file скрывает служебные файлы" "$ignore_file covers assistant artifacts"
  fi
}

check_logs() {
  # RU: Проверяем наличие логов и формат временных меток (ISO 8601 UTC).
  # EN: Validate logs exist and contain ISO 8601 UTC timestamps.
  shopt -s nullglob
  local found=0
  for log in local/ai/*/{sessions.log,requests.log}; do
    found=1
    if matches_iso "$log"; then
      ok "$log содержит ISO 8601 UTC" "$log format valid"
    else
      fail "$log не содержит ISO 8601 UTC" "$log missing ISO timestamps"
    fi
  done
  if [[ $found -eq 0 ]]; then
    warn "Логи ассистентов не найдены" "No assistant logs found in local/ai/*/{sessions,requests}.log"
  fi
}

check_readme
check_symlinks
check_gitignore
check_logs

if [[ ${#failures[@]} -gt 0 ]]; then
  echo "Bootstrap проверка провалена / Bootstrap check failed: ${failures[*]}"
  exit 1
fi

echo "Bootstrap проверка пройдена / Bootstrap check passed"
