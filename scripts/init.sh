#!/usr/bin/env bash
set -euo pipefail

# Скрипт готовит симлинки и настраивает .gitignore для шаблона агента.
# Helper script that prepares symlinks and ignore rules for the agent template.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

mkdir -p .github .gemini

ln -sfn ../AGENTS.md .github/copilot-instructions.md
ln -sfn ../AGENTS.md .gemini/GEMINI.md

if [ ! -f .gitignore ]; then
  touch .gitignore
fi

ensure_ignore_entry() {
  local entry="$1"
  if ! grep -Fxq "${entry}" .gitignore; then
    echo "${entry}" >> .gitignore
    echo "Added '${entry}' to .gitignore"
  fi
}

ensure_ignore_entry "AGENTS.md"
ensure_ignore_entry "local/"
ensure_ignore_entry "local/chat_context.md"
ensure_ignore_entry ".github/copilot-instructions.md"
ensure_ignore_entry ".gemini/GEMINI.md"

if ! grep -F "MUST немедленно изучить файлы" README.md >/dev/null 2>&1; then
  cat <<'EOF'
Не забудьте добавить скрытый HTML-комментарий для ассистентов в README.
Скопируйте его из README_snippet.md или README.md текущего шаблона.
Reminder: add the hidden HTML comment for assistants into README.
You can copy it from README_snippet.md or README.md in this template.
EOF
else
  echo "README уже содержит скрытый HTML-комментарий для ассистентов."
  echo "README already contains the hidden HTML comment for assistants."
fi

echo "Подготовка шаблона агента завершена."
echo "Agent template bootstrap complete."
