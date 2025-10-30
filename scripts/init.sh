#!/usr/bin/env bash
set -euo pipefail

# Скрипт готовит симлинки и настраивает .gitignore для шаблона агента.
# Helper script that prepares symlinks and ignore rules for the agent template.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

# Гарантируем наличие каталогов, куда будут складываться симлинки.
# Ensure directories for symlink targets exist.
mkdir -p .github .gemini

# Обновляем симлинки на единый набор инструкций для разных ассистентов.
# Refresh symlinks so every assistant reads the same instructions.
ln -sfn ../AGENTS.md .github/copilot-instructions.md
ln -sfn ../AGENTS.md .gemini/GEMINI.md
ln -sfn AGENTS.md GEMINI.md
ln -sfn AGENTS.md QWEN.md

# Создаём .gitignore, если он отсутствует в репозитории.
# Create .gitignore if the repository does not have one yet.
if [ ! -f .gitignore ]; then
  touch .gitignore
fi

# Добавляем запись в .gitignore, если её ещё нет.
# Append entry to .gitignore when it is missing.
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
ensure_ignore_entry "GEMINI.md"
ensure_ignore_entry "QWEN.md"

# Проверяем наличие скрытого HTML-комментария в README и напоминаем при необходимости.
# Remind the maintainer about the hidden HTML comment if README lacks it.
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
