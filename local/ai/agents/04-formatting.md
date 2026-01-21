# Оформление ответов / Response formatting

## По умолчанию / Default
- RU: Коротко и по делу.
  EN: Be concise and actionable.
- RU: Предпочитать короткие списки, избегать длинной прозы.
  EN: Prefer short bullet lists; avoid long prose.
- RU: Команды/пути/идентификаторы оформлять моноширинным кодом.
  EN: Format commands/paths/identifiers as monospace code.
- RU: Избегать лишних вводных; начинать с сути и результата.
  EN: Avoid extra preambles; start with the outcome and the key changes.

## Структура / Structure
- RU: Заголовки — 1–3 слова в Title Case; без пустых строк перед первым маркером.
  EN: Use 1–3 word Title Case headers and avoid blank lines before the first bullet.
- RU: Маркеры — `-`; альтернативы — нумерованным списком; вложенные уровни избегать.
  EN: Use `-` bullets; list alternatives numerically and avoid nested levels.
- RU: Ссылки на файлы — `path:line`; диапазоны и дампы целых файлов не писать.
  EN: Reference files as `path:line`; avoid ranges and whole-file dumps.

## При изменениях кода / When changing code
- RU: Перечислить изменённые файлы и что сделано.
  EN: List changed files and what changed.
- RU: Предложить следующий шаг проверки (тесты/проверки), если применимо.
  EN: Suggest the next verification step (tests/checks) if applicable.

## Мини-чеклист сдачи / Delivery mini-checklist
- RU: Указать изменённые файлы с привязкой к строкам (`path:line`), если это помогает проверке.
  EN: List changed files with line anchors (`path:line`) when it helps review.
- RU: Если запускались проверки/скрипты — указать какие; если не запускались — явно сказать почему.
  EN: If checks/scripts were run, list them; if none were run, explicitly say why.
- RU: Если нужны ручные действия — дать команды, готовые к копипасте, и порядок выполнения.
  EN: If manual steps are needed, provide copy-paste-ready commands and ordering.
- RU: Кратко отметить статус логирования (включено/отключено, где логи лежат).
  EN: Briefly state logging status (enabled/disabled, where logs live).
- RU: Проверить отсутствие секретов/PII в выводе и артефактах; временные каталоги очистить или убедиться, что они скрыты через `.git/info/exclude`.
  EN: Ensure no secrets/PII leak into outputs/artifacts; clean temp dirs or ensure they are excluded via `.git/info/exclude`.
- RU: Зафиксировать шаги/решения в `local/ai/session_history.md`; новые договорённости продублировать в `local/ai/chat_context.md` (коротко).
  EN: Record steps/decisions in `local/ai/session_history.md`; mirror new agreements in `local/ai/chat_context.md` (briefly).
