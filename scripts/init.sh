#!/usr/bin/env bash
set -euo pipefail

# Скрипт готовит симлинки и настраивает .gitignore для шаблона агента.
# Helper script that prepares symlinks and ignore rules for the agent template.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

# Гарантируем наличие каталогов, куда будут складываться симлинки.
# Ensure directories for symlink targets exist.
mkdir -p .github .gemini .qwen

# Обновляем симлинки на единый набор инструкций для разных ассистентов.
# Refresh symlinks so every assistant reads the same instructions.
ln -sfn ../AGENTS.md .github/copilot-instructions.md
ln -sfn ../AGENTS.md .gemini/GEMINI.md
ln -sfn AGENTS.md GEMINI.md
ln -sfn AGENTS.md QWEN.md
ln -sfn ../AGENTS.md .qwen/QWEN.md

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
ensure_ignore_entry ".qwen/QWEN.md"

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

cat <<'EOF'
Напоминание: настройте каталоги local/<assistant-name>/, создайте sessions.log и requests.log и согласуйте точность времени согласно разделу Quick Start.
Reminder: prepare local/<assistant-name>/ directories, create sessions.log and requests.log, and align timestamp precision as described in the Quick Start section.
EOF

# Индикатор готовности / Readiness marker
READY_FILE="local/bootstrap.ready"
if [[ -f "$READY_FILE" ]]; then
  echo "true" > "$READY_FILE"
else
  mkdir -p local
  echo "true" > "$READY_FILE"
fi
echo "local/bootstrap.ready set to $(cat "$READY_FILE")"

# Убедимся, что в chat_context есть блок статуса / Ensure readiness block exists
CHAT_CONTEXT="local/chat_context.md"
if [[ -f "$CHAT_CONTEXT" ]] && ! grep -Fq "## Статус готовности / Readiness status" "$CHAT_CONTEXT"; then
  tmp_body="$(mktemp)"
  cp "$CHAT_CONTEXT" "$tmp_body"
  {
    cat <<'BLOCK'
## Статус готовности / Readiness status
- `status`: `pending`
- `last_verified_at`: `YYYY-MM-DDTHH:MM:SSZ`
- `agents_md_hash`: `sha256:<fill-after-bootstrap>`
- **RU:** После выполнения bootstrap-проверок обнови статус на `completed`, зафиксируй время (UTC) и актуальный хеш `AGENTS.md`; когда протокол пересматривается, перезапиши значения.
  **EN:** Once bootstrap checks pass, switch the status to `completed`, record the UTC timestamp, and store the current `AGENTS.md` hash; refresh the fields whenever the protocol is revisited.

BLOCK
    cat "$tmp_body"
  } > "$CHAT_CONTEXT"
  rm -f "$tmp_body"
  echo "Readiness block injected into $CHAT_CONTEXT"
fi

echo "Подготовка шаблона агента завершена."
echo "Agent template bootstrap complete."
