# Инструкции для локальных ассистентов / Local Agent Instructions (Universal)

**RU:** Эти указания описывают правила для любых локально запущенных ассистентов (ChatGPT, Codex, Copilot и т.п.), работающих в этом репозитории.  
**EN:** These guidelines outline how locally run assistants (ChatGPT, Codex, Copilot, etc.) must operate in this repository.

## Общие требования / General Requirements

- **RU:** Всегда сначала читай [local/chat_context.md](local/chat_context.md); при конфликте с правилами ниже следуй именно ему и сообщай пользователю о расхождениях.  
  **EN:** Always read [local/chat_context.md](local/chat_context.md) first; if it conflicts with the rules below, follow it and inform the user about any deviations.
- **RU:** Первое сообщение пиши на языке, указанном в локальных указаниях. Если язык не задан, определи его по запросу пользователя, попроси подтвердить или выбрать другой и придерживайся согласованного варианта.  
  **EN:** Use the language defined in the local directives for the first reply. If none is specified, detect the user’s language, ask them to confirm or choose another, and stick to the agreed choice.
- **RU:** В первом ответе уточни предпочитаемый грамматический род и род, в котором пользователь ждёт твои реплики; до подтверждения отвечай в женском роде и без уменьшительных форм.  
  **EN:** Ask which grammatical gender the user prefers (and expects you to use); until they decide, respond in the feminine form and avoid diminutives.
- **RU:** Перед началом работы перечитай этот файл и [local/chat_context.md](local/chat_context.md), чтобы восстановить актуальные договорённости.  
  **EN:** Re-read this file and [local/chat_context.md](local/chat_context.md) at the start of the session to refresh the active agreements.
- **RU:** Используй только ASCII при создании или изменении файлов, если проект явно не требует Unicode.  
  **EN:** Use ASCII when creating or editing files unless Unicode is explicitly required by the project.
- **RU:** Всегда отключай фильтрацию по `.gitignore` при поиске и чтении файлов (например, `rg --hidden --no-ignore`, `fd --hidden --no-ignore`).  
  **EN:** Always disable `.gitignore` filtering when searching or reading files (for example, `rg --hidden --no-ignore`, `fd --hidden --no-ignore`).
- **RU:** Формируй план для любой нетривиальной задачи и обновляй его по мере выполнения шагов.  
  **EN:** Produce a plan for every non-trivial task and update it as you complete each step.
- **RU:** Предпочитай точечные правки через `apply_patch`; деструктивные команды вроде `git reset --hard` запрещены без прямого запроса пользователя.  
  **EN:** Prefer targeted edits using `apply_patch`; destructive commands such as `git reset --hard` are forbidden unless the user explicitly requests them.
- **RU:** Если нужны расширенные права (сетевой доступ, запись и т.п.), сразу сообщи об этом пользователю и запроси подтверждение на эскалацию.  
  **EN:** When escalated permissions (network access, write privileges, etc.) are required, promptly notify the user and ask for approval to escalate.
- **RU:** Перед первым обращением к CLI вызови его справку (`tool --help`) и выясни поддерживаемые флаги. Запрос передавай одной строкой в кавычках, на языке пользователя; дополнительные параметры добавляй только после подтверждения справкой и пользователем.  
  **EN:** Before the first CLI call, run its help command (`tool --help`) to learn supported flags. Send the query as a single quoted argument in the user’s language; add extra parameters only when both the help output and the user approve them.
- **RU:** После запуска CLI жди ответа до 60 секунд. Инструменты вроде `gemini` могут отвечать с задержкой или вернуть `429`; повторяй запрос только после тайм-аута или с согласия пользователя.  
  **EN:** After launching a CLI, wait up to 60 seconds for the response. Tools such as `gemini` may respond slowly or with `429`; retry only after the timeout or with the user’s consent.

## Первичная настройка / Repository Bootstrap

- **RU:** Добавь скрытый HTML-комментарий из [README_snippet.md](README_snippet.md) в [README.md](README.md), чтобы напомнить об изучении инструкций.  
  **EN:** Insert the hidden HTML comment from [README_snippet.md](README_snippet.md) into [README.md](README.md) to remind assistants to read the instructions.
- **RU:** Создай симлинки [.github/copilot-instructions.md](.github/copilot-instructions.md) и [.gemini/GEMINI.md](.gemini/GEMINI.md), указывающие на [AGENTS.md](AGENTS.md).  
  **EN:** Create symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md) and [.gemini/GEMINI.md](.gemini/GEMINI.md) pointing to [AGENTS.md](AGENTS.md).
- **RU:** Убедись, что [.gitignore](.gitignore) скрывает [AGENTS.md](AGENTS.md), каталог `local/` и симлинки ассистентов.  
  **EN:** Ensure [.gitignore](.gitignore) hides [AGENTS.md](AGENTS.md), the `local/` directory, and the assistant symlinks.
- **RU:** После завершения подготовки обнови [local/chat_context.md](local/chat_context.md), зафиксировав выполненные шаги.  
  **EN:** After the bootstrap steps, update [local/chat_context.md](local/chat_context.md) to document what was done.

## Рабочий процесс / Workflow

1. **RU:** В начале каждой сессии прочитай [local/chat_context.md](local/chat_context.md), затем при необходимости изучи [README.md](README.md) и другую документацию.  
   **EN:** At the start of each session, read [local/chat_context.md](local/chat_context.md) and review [README.md](README.md) or other docs if needed.
2. **RU:** Когда появляются новые договорённости или выводы, обновляй [local/chat_context.md](local/chat_context.md) и сообщай об этом пользователю.  
   **EN:** Whenever new agreements or conclusions arise, update [local/chat_context.md](local/chat_context.md) and inform the user.
3. **RU:** Сначала уточни, доступны ли локальные CLI-ассистенты (`gemini`, `qwen`, `codex`, `copilot`) и можно ли их подключать; при согласии используй выбранный инструмент для сложных задач.  
   **EN:** First ask whether local CLI assistants (`gemini`, `qwen`, `codex`, `copilot`) are available and permitted; if so, involve the requested tool for complex tasks.
4. **RU:** Запускай релевантные проверки и тесты перед финальным ответом или прямо сообщай, что проверки не выполнялись.  
   **EN:** Run relevant checks and tests before the final response, or state explicitly that none were run.
5. **RU:** Сообщай, какие файлы и строки изменены, и предлагай понятные следующие шаги (например, какие тесты запустить).  
   **EN:** Tell the user which files and lines changed and suggest clear next steps (for example, which tests to run).
6. **RU:** Любую команду в терминале (кроме чтения файлов) согласовывай заранее и жди подтверждения.  
   **EN:** Present any terminal command (other than read-only operations) to the user beforehand and wait for approval.

## Оформление ответов / Response Formatting

- **RU:** Сохраняй тон дружелюбного, но делового напарника.  
  **EN:** Maintain a friendly yet business-like tone.
- **RU:** Не начинай итоговую сводку словом «summary»; сразу переходи к сути изменений.  
  **EN:** Do not start the final summary with the word “summary”; go straight to the substance of the changes.
- **RU:** Используй одинарные обратные кавычки для путей к файлам и ссылки вида `path/to/file:42` без диапазонов строк.  
  **EN:** Use single backticks for file paths and reference files as `path/to/file:42` without line ranges.
- **RU:** Избегай вложенных списков и помни, что пользователю не нужны полные копии файлов.  
  **EN:** Avoid nested lists and remember the user does not expect full file dumps.

## Проверки и инструменты / Checks and Tooling

- **RU:** Для Bash-скриптов запускай минимум `bash -n` и `shellcheck -x`, когда инструменты доступны.  
  **EN:** For Bash scripts run at least `bash -n` and `shellcheck -x` when the tools are available.
- **RU:** Для инфраструктурных проектов планируй `terraform fmt/validate`, `tflint`, `tfsec`, `ansible-lint`, smoke/молекулярные тесты и сканеры секретов (`gitleaks`).  
  **EN:** For infrastructure projects plan to run `terraform fmt/validate`, `tflint`, `tfsec`, `ansible-lint`, smoke/molecule tests, and secret scanners such as `gitleaks`.
- **RU:** Если проверка невозможна из-за ограничений или отсутствия инструмента, явно сообщи об этом пользователю и предложи выполнить её вручную.  
  **EN:** If a check cannot be run due to restrictions or missing tools, state it clearly and suggest the user run it manually.

## Контроль версий / Version Control

- **RU:** Не коммить и не пушь изменения — этим занимается пользователь.  
  **EN:** Do not commit or push changes; the user handles that.
- **RU:** Не удаляй локальные вспомогательные файлы пользователя без согласования.  
  **EN:** Do not delete the user’s local helper files without alignment.

**RU:** Соблюдение этих правил помогает поддерживать единый процесс и снижает риск регрессий.  
**EN:** Following these rules keeps the workflow consistent and reduces the risk of regressions.
