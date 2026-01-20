#!/usr/bin/env bash
set -euo pipefail

# Скрипт готовит симлинки и настраивает .git/info/exclude для шаблона агента.
# Helper script that prepares symlinks and .git/info/exclude entries for the agent template.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${REPO_ROOT}"

# Гарантируем наличие каталогов, куда будут складываться симлинки.
# Ensure directories for symlink targets exist.
mkdir -p .github .gemini .qwen

# Ensure local temp workspace exists.
mkdir -p tmp/ai

# Обновляем симлинки на единый набор инструкций для разных ассистентов.
# Refresh symlinks so every assistant reads the same instructions.
ln -sfn ../AGENTS.md .github/copilot-instructions.md
ln -sfn ../AGENTS.md .gemini/GEMINI.md
ln -sfn AGENTS.md GEMINI.md
ln -sfn AGENTS.md QWEN.md
ln -sfn ../AGENTS.md .qwen/QWEN.md

# Pick ignore file: use .git/info/exclude when this is a git repo.
EXCLUDE_FILE=""
if [ -d .git ]; then
  mkdir -p .git/info
  EXCLUDE_FILE=".git/info/exclude"
  if [ ! -f "${EXCLUDE_FILE}" ]; then
    touch "${EXCLUDE_FILE}"
  fi
else
  echo "Warning: .git not found; skip exclude entries (use .git/info/exclude after git init)."
fi

ensure_exclude_entry() {
  local entry="$1"
  if [ -z "${EXCLUDE_FILE}" ]; then
    return
  fi
  if ! grep -Fxq "${entry}" "${EXCLUDE_FILE}"; then
    echo "${entry}" >> "${EXCLUDE_FILE}"
    echo "Added '${entry}' to ${EXCLUDE_FILE}"
  fi
}

if [ -n "${EXCLUDE_FILE}" ] && [ -f .gitignore ]; then
  entries=()
  in_block=0
  while IFS= read -r line; do
    if [[ "${line}" == "# BEGIN EXCLUDE LIST (for .git/info/exclude)"* ]]; then
      in_block=1
      continue
    fi
    if [[ "${line}" == "# END EXCLUDE LIST"* ]]; then
      in_block=0
      break
    fi
    if [[ "${in_block}" -eq 1 && "${line}" == \#* ]]; then
      entry="${line#\# }"
      if [ -n "${entry}" ]; then
        entries+=("${entry}")
      fi
    fi
  done < .gitignore
  if [[ ${#entries[@]} -gt 0 ]]; then
    for entry in "${entries[@]}"; do
      ensure_exclude_entry "${entry}"
    done
  fi
fi

# Проверяем наличие скрытого HTML-комментария в README и напоминаем при необходимости.
# Remind the maintainer about the hidden HTML comment if README lacks it.
if ! grep -F "AI AGENT PROTOCOL TRIGGER" README.md >/dev/null 2>&1; then
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
Напоминание: настройте каталоги local/ai/<assistant-name>/, создайте sessions.log и requests.log и согласуйте точность времени согласно разделу Quick Start.
Reminder: prepare local/ai/<assistant-name>/ directories, create sessions.log and requests.log, and align timestamp precision as described in the Quick Start section.
EOF

# Индикатор готовности / Readiness marker
READY_FILE="local/ai/bootstrap.ready"
mkdir -p local/ai
{
  echo "true"
  if [ -n "${EXCLUDE_FILE}" ] && [ -f .gitignore ]; then
    in_block=0
    while IFS= read -r line; do
      if [[ "${line}" == "# BEGIN EXCLUDE LIST (for .git/info/exclude)"* ]]; then
        in_block=1
        continue
      fi
      if [[ "${line}" == "# END EXCLUDE LIST"* ]]; then
        in_block=0
        break
      fi
      if [[ "${in_block}" -eq 1 && "${line}" == \#* ]]; then
        entry="${line#\# }"
        if [ -n "${entry}" ]; then
          echo "${entry}"
        fi
      fi
    done < .gitignore
  fi
} > "$READY_FILE"
echo "local/ai/bootstrap.ready set"

# Убедимся, что в chat_context есть блок статуса / Ensure readiness block exists
CHAT_CONTEXT="local/ai/chat_context.md"
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
