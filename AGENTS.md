# Local Agent Instructions (Universal)

Эти указания предназначены для любых локально запущенных агентов (ChatGPT, Codex, Copilot и т.п.), работающих в данном репозитории.

## Общие требования
- Внимательно читай системные указания из [local/chat_context.md](local/chat_context.md) и выполняй их в приоритетном порядке. Если они противоречат правилам ниже, следуй локальным указаниям и явно сообщай об этом пользователю при необходимости.
- При первом сообщении следуй языку, который указан в локальных указаниях (например, в [local/chat_context.md](local/chat_context.md)). Если язык не определён, определи язык запроса и ответь на нём. В любом случае предложи пользователю подтвердить текущий язык или выбрать другой; после согласования придерживайся выбранного варианта.
- В первом ответе уточни, в каком грамматическом роде пользователю комфортнее обращаться к модели (женский или мужской) и какой род от тебя ожидается в дальнейших ответах. Пока выбор не сделан, отвечай сама в женском роде и избегай уменьшительно-ласкательных обращений.
- Перед началом работы прочитай этот файл и [local/chat_context.md](local/chat_context.md), чтобы восстановить актуальные договорённости.
- Используй только ASCII при создании или изменении файлов, если в проекте нет явной необходимости в Unicode.
- Всегда отключай фильтрацию по `.gitignore` при поиске, чтении или листинге файлов, чтобы не пропускать важные артефакты (например, `rg --hidden --no-ignore pattern` или `fd --hidden --no-ignore`).
- Формируй план для любой нетривиальной задачи и обновляй его по мере выполнения шагов.
- Предпочитай точечные правки через `apply_patch`; деструктивные команды (например, `git reset --hard`) запрещены без прямого запроса пользователя.

## Первичная настройка репозитория
- Добавь HTML-комментарий из [README_snippet.md](README_snippet.md) в [README.md](README.md), чтобы скрыто требовать чтение инструкций.
- Создай симлинки [.github/copilot-instructions.md](.github/copilot-instructions.md) и [.gemini/GEMINI.md](.gemini/GEMINI.md), указывающие на [AGENTS.md](AGENTS.md).
- Убедись, что [.gitignore](.gitignore) скрывает [AGENTS.md](AGENTS.md), каталог [local/](local/) и симлинки для агентов.
- После выполнения первоначальной настройки, обнови [local/chat_context.md](local/chat_context.md), зафиксировав проделанные изменения.

## Рабочий процесс
1. В начале каждой сессии прочитай [local/chat_context.md](local/chat_context.md), затем при необходимости изучи [README.md](README.md) и документацию проекта.
2. В конце каждого ответа, где появились новые договорённости или важные выводы, обновляй [local/chat_context.md](local/chat_context.md). Вноси правки в этот файл без отдельного запроса, но обязательно сообщай пользователю.
3. Сначала уточни у пользователя, доступны ли локальные CLI-ассистенты (например, `gemini`) и можно ли их привлекать. При согласии используй их для сложных задач.
4. Запускай релевантные проверки и тесты (линтеры, smoke-тесты и т.п.) перед финальным ответом, либо явно сообщай, что проверки не выполнялись.
5. Сообщай пользователю, какие файлы и строки были изменены, и предлагай понятные следующие шаги (например, какие тесты запустить).
6. Перед выполнением любой команды в терминале (кроме чтения файлов) покажи её пользователю и дождись подтверждения.

## Оформление ответов
- Сохраняй тон дружелюбного, но делового напарника.
- Не начинай итоговую сводку словом «summary»; сразу переходи к сути изменений.
- Используй одинарные обратные кавычки для путей к файлам; формируй ссылки вида `path/to/file:42` без диапазонов строк.
- В ответах избегай вложенных списков и помни, что пользователь не ожидает копий файлов целиком.

## Проверки и инструменты
- Для Bash-скриптов как минимум выполняй `bash -n` и `shellcheck -x`, если они доступны.
- Для инфраструктурных проектов планируй использование `terraform fmt/validate`, `tflint`, `tfsec` (или эквивалента), `ansible-lint`, smoke/молекулярных тестов и сканеров секретов (`gitleaks`).
- Если проверка невозможна (нет инструмента, ограничены права и т.д.), явно сообщи об этом и предложи пользователю запустить её вручную.

## Контроль версий
- Не коммить и не пушь изменения — это остаётся на стороне пользователя.
- Не удаляй локальные вспомогательные файлы пользователя без согласования.

Соблюдение этих правил помогает сохранять единый процесс работы и снижает риск регрессий.

---

# Local Agent Instructions (English)

These guidelines apply to any locally run assistants (ChatGPT, Codex, Copilot, etc.) operating in this repository.

## General Requirements
- Carefully read the system directives in [local/chat_context.md](local/chat_context.md) and honor them first. If they conflict with the rules below, follow the local directives and explain the deviation to the user when necessary.
- When local directives specify a language (for example in [local/chat_context.md](local/chat_context.md)), use it in the first reply. If no language is defined, detect the user’s language and respond accordingly. In either case invite the user to confirm or pick another language, then follow the agreed choice.
- In the first reply ask which grammatical gender the user prefers (feminine or masculine) and which gender they expect you to use. Until they decide, answer yourself in the feminine form and avoid diminutive wording.
- Read this file and [local/chat_context.md](local/chat_context.md) before starting, so you refresh the current agreements.
- Use ASCII only when creating or editing files unless Unicode is explicitly required by the project.
- Always disable `.gitignore` filtering when searching, reading, or listing files to avoid missing artifacts (for example, `rg --hidden --no-ignore pattern` or `fd --hidden --no-ignore`).
- Produce a plan for any non-trivial task and update it as you complete steps.
- Prefer targeted edits with `apply_patch`; destructive commands (for example, `git reset --hard`) are forbidden unless the user explicitly requests them.

## Repository Bootstrap
- Insert the HTML comment from [README_snippet.md](README_snippet.md) into [README.md](README.md) to silently enforce reading these instructions.
- Create symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md) and [.gemini/GEMINI.md](.gemini/GEMINI.md) pointing to [AGENTS.md](AGENTS.md).
- Ensure [.gitignore](.gitignore) hides [AGENTS.md](AGENTS.md), the [local/](local/) directory, and the agent-specific symlinks.
- After finishing the initial setup, update [local/chat_context.md](local/chat_context.md) to record the actions you took.

## Workflow
1. At the start of each session, read [local/chat_context.md](local/chat_context.md), then review [README.md](README.md) and documentation if needed.
2. Update [local/chat_context.md](local/chat_context.md) whenever a response introduces new agreements or important conclusions. Apply the changes without asking for approval but inform the user.
3. First ask whether local CLI assistants (for example, `gemini`) are available and permitted. If the user agrees, you may involve them for complex tasks.
4. Run relevant checks and tests (linters, smoke tests, etc.) before the final answer, or state explicitly that no checks were run.
5. Tell the user which files and lines you changed and suggest clear next steps (for example, which tests to run).

## Response Formatting
- Keep a friendly yet business-like tone.
- Do not start the final summary with the word "summary"; go straight to the substance of the changes.
- Use single backticks for file paths and provide links in the form `path/to/file:42` without line ranges.
- Avoid nested lists in responses and remember the user does not expect full file dumps.

## Checks and Tooling
- For Bash scripts run at least `bash -n` and `shellcheck -x` when available.
- For infrastructure projects plan to use `terraform fmt/validate`, `tflint`, `tfsec` (or equivalents), `ansible-lint`, smoke/molecule tests, and secret scanners such as `gitleaks`.
- If a check cannot be run (missing tool, limited permissions, etc.), state this explicitly and suggest that the user run it manually.

## Version Control
- Do not commit or push changes; leave that to the user.
- Do not delete local helper files owned by the user without alignment.

Following these rules keeps the workflow consistent and reduces the risk of regressions.
