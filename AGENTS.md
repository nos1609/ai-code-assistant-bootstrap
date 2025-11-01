# Инструкции для локальных ассистентов / Local Agent Instructions (Universal)

> **Версия инструкций / Instruction version:** YYYY-MM-DD

**RU:** Эти указания описывают правила для любых локально запущенных ассистентов (ChatGPT, Codex, Copilot и т.п.), работающих в этом репозитории.  
**EN:** These guidelines outline how locally run assistants (ChatGPT, Codex, Copilot, etc.) must operate in this repository.

### Предполетный чек-лист / Pre-flight Checklist

- **RU:** [ ] Прочитать `local/chat_context.md`.  
  **EN:** [ ] Read `local/chat_context.md`.
- **RU:** [ ] Подтвердить ключевые договорённости из `local/chat_context.md`.  
  **EN:** [ ] Acknowledge key agreements from `local/chat_context.md`.
- **RU:** [ ] Проверить, есть ли проектные дополнения (например, `local/project_addenda.md`) и учесть их указания.  
  **EN:** [ ] Check for any project addenda (for example, `local/project_addenda.md`) and follow their guidance.
- **RU:** [ ] Поприветствовать пользователя и уточнить задачу согласно инструкциям.  
  **EN:** [ ] Greet the user and clarify the task according to instructions.

## Общие требования / General Requirements

- **RU:** [P0_CRITICAL] Всегда сначала читай [local/chat_context.md](local/chat_context.md); при конфликте с правилами ниже следуй именно ему и сообщай пользователю о расхождениях.  
  **EN:** [P0_CRITICAL] Always read [local/chat_context.md](local/chat_context.md) first; if it conflicts with the rules below, follow it and inform the user about any deviations.
- **RU:** [P1_IMPORTANT] Раздел «Краткая памятка» в `local/chat_context.md` содержит подтверждённые язык, род, окружение, доступность CLI и статус логирования; опирайся на него вместо повторных вопросов.  
  **EN:** [P1_IMPORTANT] The “Quick profile” section in `local/chat_context.md` lists the confirmed language, gender, environment, CLI availability, and logging status; rely on it instead of re-asking.
- **RU:** [P2_BEST_PRACTICE] Подробная хронология, полезные ссылки и список изменений ведутся в `local/session_history.md`; обновляй его вместе с контекстом при появлении новых данных.  
  **EN:** [P2_BEST_PRACTICE] Detailed history, helpful links, and change tracking live in `local/session_history.md`; update it alongside the context when new information appears.
- **RU:** Учитывай двуязычный формат инструкции: при правках поддерживай синхронность русской и английской формулировок, сохраняя общий смысл и структуру.  
  **EN:** Respect the bilingual layout of this guide: when editing, update the Russian and English versions together, keeping their meaning and structure aligned.
- **RU:** Перед стандартными уточнениями (род, окружение, детализация, доступность CLI) сверяйся с `local/chat_context.md`; если сведения уже зафиксированы, подтверди их и предложи обновить при изменениях.  
  **EN:** Before asking the standard clarification questions (gender, environment, detail level, CLI availability), consult `local/chat_context.md`; when information is already recorded, acknowledge it and invite updates if something changed.
- **RU:** Первое сообщение пиши на языке, указанном в локальных указаниях. Если язык не задан, определи его по запросу пользователя, попроси подтвердить или выбрать другой и придерживайся согласованного варианта.  
  **EN:** Use the language defined in the local directives for the first reply. If none is specified, detect the user’s language, ask them to confirm or choose another, and stick to the agreed choice.
- **RU:** В первом ответе уточни предпочитаемый грамматический род и род, в котором пользователь ждёт твои реплики; до подтверждения отвечай в женском роде и без уменьшительных форм.  
  **EN:** Ask which grammatical gender the user prefers (and expects you to use); until they decide, respond in the feminine form and avoid diminutives.
- **RU:** Сразу уточни, в каком окружении/операционной системе работает пользователь, чтобы понимать доступные инструменты и ограничения.  
  **EN:** Immediately ask which environment/OS the user is running to understand available tools and constraints.
- **RU:** Не делай предположений об уровне подготовки пользователя; уточняй, насколько подробно пояснять шаги, чтобы помощь была доступна даже новичкам.  
  **EN:** Avoid assuming the user’s expertise level; ask how much detail they want so the guidance stays understandable even for newcomers.
- **RU:** Перед началом курса работы перечитай этот файл и [local/chat_context.md](local/chat_context.md), чтобы восстановить актуальные договорённости; при первой сессии опирайся на доступные локальные подсказки и документацию как шпаргалку.  
  **EN:** Before you start working, re-read this file and [local/chat_context.md](local/chat_context.md) to refresh active agreements; in your first session lean on any available local references or documentation as a quick-start aid.
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
  **EN:** After launching a CLI, wait up to 60 seconds for the response. Tools such as `gemini` may respond slowly or return `429`; retry only after the timeout or with the user’s consent.
## Первичная настройка / Repository Bootstrap

- **RU:** Добавь скрытый HTML-комментарий из [README_snippet.md](README_snippet.md) в [README.md](README.md), чтобы напомнить об изучении инструкций.  
  **EN:** Insert the hidden HTML comment from [README_snippet.md](README_snippet.md) into [README.md](README.md) to remind assistants to read the instructions.
- **RU:** Создай симлинки [.github/copilot-instructions.md](.github/copilot-instructions.md) и [.gemini/GEMINI.md](.gemini/GEMINI.md), указывающие на [AGENTS.md](AGENTS.md).  
  **EN:** Create symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md) and [.gemini/GEMINI.md](.gemini/GEMINI.md) pointing to [AGENTS.md](AGENTS.md).
- **RU:** Убедись, что [.gitignore](.gitignore) скрывает [AGENTS.md](AGENTS.md), каталог `local/` и симлинки ассистентов.  
  **EN:** Ensure [.gitignore](.gitignore) hides [AGENTS.md](AGENTS.md), the `local/` directory, and the assistant symlinks.
- **RU:** После завершения подготовки обнови [local/chat_context.md](local/chat_context.md), зафиксировав выполненные шаги.  
  **EN:** After the bootstrap steps, update [local/chat_context.md](local/chat_context.md) to document what was done.

## Протокол начала сессии / Initial Session Protocol

**RU:** В начале каждой сессии агент обязан выполнить следующую последовательность действий:  
**EN:** At the start of each session, the agent must perform the following sequence of actions:

1. **RU:** Прочитать `local/chat_context.md`, чтобы восстановить актуальные договорённости.  
   **EN:** Read `local/chat_context.md` to restore the active agreements.
2. **RU:** Выполнить все шаги из раздела «Первичная настройка / Repository Bootstrap».  
   **EN:** Execute every step from the “Первичная настройка / Repository Bootstrap” section.
3. **RU:** Обновить `local/chat_context.md`, задокументировав выполненные шаги первичной настройки.  
   **EN:** Update `local/chat_context.md`, documenting the completed bootstrap steps.
4. **RU:** Подтвердить ознакомление с разделом «Логирование обращений / Logging Requests» в `AGENTS.md` и `local/chat_context.md`, инициировать логирование сессии.  
   **EN:** Confirm familiarity with the “Логирование обращений / Logging Requests” section in `AGENTS.md` and `local/chat_context.md`, and initiate session logging.
5. **RU:** Представить «Приветственное сообщение», запрашивая задачу и релевантные области репозитория, исключая вопросы, ответы на которые уже отражены в `local/chat_context.md`.  
   **EN:** Deliver the “Greeting Message,” asking for the task and relevant repository areas while avoiding questions whose answers already appear in `local/chat_context.md`.

## Рабочий процесс / Workflow

1. **RU:** В начале каждой сессии прочитай [local/chat_context.md](local/chat_context.md), затем при необходимости изучи [README.md](README.md).  
   **EN:** At the start of each session, read [local/chat_context.md](local/chat_context.md) and, when helpful, review [README.md](README.md).
2. **RU:** Когда появляются новые договорённости или выводы, обновляй [local/chat_context.md](local/chat_context.md) и сообщай об этом пользователю.  
   **EN:** Whenever new agreements or conclusions arise, update [local/chat_context.md](local/chat_context.md) and inform the user.
3. **RU:** Подтверждай доступность локальных CLI-ассистентов (`gemini`, `qwen`, `codex`, `copilot`) и их режим работы; при согласии используйте выбранные инструменты для сложных задач.  
   **EN:** Confirm the availability and operating mode of local CLI assistants (`gemini`, `qwen`, `codex`, `copilot`); use the agreed tool for complex tasks.
4. **RU:** Перед выполнением команд уточняй у пользователя необходимость эскалации; команды (кроме чтения файлов и заранее одобренных логирующих вроде `date -u`, `echo >> local/...`) выполняй только после подтверждения.  
   **EN:** Discuss escalation needs with the user before running commands; execute commands (except file reads and pre-approved logging such as `date -u`, `echo >> local/...`) only after obtaining approval.
5. **RU:** Запускай релевантные проверки и тесты до финального ответа или прямо сообщай, что проверки не выполнялись.  
   **EN:** Run relevant checks and tests before the final response, or state explicitly that none were run.
6. **RU:** Сообщай пользователю, какие файлы и строки изменены, и предлагай осмысленные следующие шаги (какие тесты запустить, что перепроверить).  
   **EN:** Tell the user which files and lines changed, and suggest sensible next steps (tests to run, follow-up checks).
7. **RU:** Фиксируй ключевые шаги и решения в `local/session_history.md`; при появлении новых правил обновляй `local/chat_context.md`.  
   **EN:** Record key steps and decisions in `local/session_history.md`; update `local/chat_context.md` whenever agreements change.

### Протокол взаимодействия ассистентов / Inter-assistant protocol

- **RU:** Перед подключением другого ассистента передай пакет контекста: ссылки на `AGENTS.md`, `local/chat_context.md` (раздел «Краткая памятка»), `local/session_history.md` и краткое описание доступных CLI-инструментов.  
  **EN:** Before involving another assistant, share a context package: links to `AGENTS.md`, `local/chat_context.md` (its “Quick profile” section), `local/session_history.md`, and a short overview of available CLI tools.
- **RU:** Согласуй правила логирования: напомни вести `local/<имя>/sessions.log` и `local/<имя>/requests.log`, после обмена проверь, что записи созданы.  
  **EN:** Align on logging: remind them to append `local/<name>/sessions.log` and `local/<name>/requests.log`, and confirm the entries exist after the exchange.
- **RU:** Если нужно обратиться сразу к нескольким ассистентам, запроси одну эскалацию на весь набор команд: перечисли все вызовы CLI (одна команда — одна строка) и используй единое обоснование; после одобрения выполняй команды последовательно.  
  **EN:** When you need input from multiple assistants, request a single escalation covering the whole batch: list every CLI invocation (one command per line) with a shared justification; once approved, run the commands in sequence.
- **RU:** При распределении задач между ассистентами фиксируй роли и очередь (кто консультирует, кто проверяет), чтобы избежать конфликтов.  
  **EN:** When assigning tasks across assistants, document roles and sequencing (who advises, who verifies) to prevent conflicts.
- **RU:** По завершении консультации законспектируй выводы в `local/session_history.md` и при необходимости обнови `local/chat_context.md`.  
  **EN:** After the consultation, summarize the findings in `local/session_history.md` and update `local/chat_context.md` when needed.

## Проверки и инструменты / Checks and Tooling

- **RU:** Для скриптов и программ запускай быстрые статические проверки (например, синтаксические тесты, линтеры) перед основным прогоном; выбирай инструменты под язык.  
  **EN:** For scripts and programs run quick static checks first (syntax checks, linters, etc.), picking tools appropriate for the language.
- **RU:** Подбирай профильные проверки под проект (линтеры, форматирование, тесты, сканеры секретов) и прогоняй их перед сдачей результата.  
  **EN:** Run project-appropriate checks (linters, formatters, tests, secret scanners) before delivering results.
- **RU:** Если проверка невозможна из-за ограничений или отсутствия инструмента, явно сообщи об этом пользователю и предложи выполнить её вручную.  
  **EN:** If a check cannot be run due to restrictions or missing tools, state it clearly and suggest the user run it manually.
## Логирование обращений / Logging Requests

- **RU:** Определяй цель ведения логов (отладка, аудит, метрики) и фиксируй её в документации перед включением сбора.  
  **EN:** Define the purpose of logging (debugging, audit, metrics) and document it before enabling collection.
- **RU:** Логирование считается включённым по умолчанию; отключение возможно только отдельной договорённостью, отражённой в `local/chat_context.md`.  
  **EN:** Logging is enabled by default; turn it off only with an explicit agreement captured in `local/chat_context.md`.
- **RU:** После подтверждения рабочего языка и рода фиксируй старт сессии: создавай запись в журнале `local/<имя ассистента>/sessions.log` (или аналогичном файле) с уникальным идентификатором, временем начала, выбранным языком и родом.  
  **EN:** After confirming language and grammatical gender, capture the session start: write an entry to `local/<assistant-name>/sessions.log` (or an equivalent file) with a unique ID, start time, chosen language, and gender.
- **RU:** Если каталог `local/<имя ассистента>` или нужные файлы отсутствуют, создай их перед первой записью, сохраняя структуру репозитория.  
  **EN:** If `local/<assistant-name>` or the required log files are missing, create them before the first entry while keeping the repository structure.
- **RU:** Если логирование активно, в первом ответе автоматически запроси явное разрешение на запись точных отметок времени или длительности обработки; при отказе веди только базовые журналы.  
  **EN:** When logging is enabled, ask for explicit approval in the first reply before recording precise timestamps or processing durations; if refused, keep only baseline logs.
- **RU:** Для записи точных отметок времени отдельных запросов или длительности обработки получи подтверждение пользователя и зафиксируй его в `local/chat_context.md` перед расширением логов.  
  **EN:** Before logging per-request timestamps or processing durations, capture the user’s approval and record it in `local/chat_context.md`.
- **RU:** Записи в `sessions.log` и `requests.log` веди в формате JSONL (одна запись на строку); добавляй поле `summary`/`short_context`, отражающее цель сессии или суть запроса.  
  **EN:** Keep `sessions.log` and `requests.log` as JSONL (one entry per line); include a `summary`/`short_context` field capturing the session purpose or request intent.
- **RU:** При полученном согласии фиксируй КАЖДОЕ обращение к ассистенту в `local/<имя ассистента>/requests.log`: используй отметку времени в ISO 8601 (UTC), идентификатор или тип обращения, краткий контекст (1-2 фразы), пометку об инструментах и итоговый статус (`success`, `warning`, `error`). Придерживайся ASCII и не записывай чувствительные данные.  
  **EN:** With consent, log EVERY interaction in `local/<assistant-name>/requests.log`: include an ISO 8601 UTC timestamp, interaction ID/type, a 1-2 sentence context, tools used, and a final status (`success`, `warning`, `error`). Stick to ASCII and omit sensitive data.
- **RU:** Логируй только необходимые поля: идентификатор запроса, тип ассистента, отметку времени и минимальный контекст; пользовательский ввод и ответы маскируй/анонимизируй, удаляя PII и секреты.  
  **EN:** Capture only the required fields: request ID, assistant type, timestamp, and minimal context; mask or anonymize user inputs and responses, stripping PII and secrets.
- **RU:** Храни журналы в подпапке `local/<имя ассистента>` или во внешнем хранилище с ограниченным доступом; фиксируй формат и расположение в локальных инструкциях.  
  **EN:** Store logs under `local/<assistant-name>` or in restricted external storage; document the format and location in the local guidelines.
- **RU:** Устанавливай сроки хранения и процессы ротации, обеспечивай возможность удаления записей по запросу пользователя.  
  **EN:** Define retention periods and rotation processes, and keep a path to delete entries on user request.
- **RU:** Перед анализом логов убеждайся, что обработка чувствительных данных соответствует политике безопасности и действующим законам.  
  **EN:** Before analyzing logs, ensure handling of sensitive data complies with the security policy and applicable regulations.
- **RU:** Если обращаешься к другому ассистенту, требуй, чтобы он вёл свои журналы (`local/<имя>/requests.log`, `sessions.log`) по тем же правилам и подтверждай, что записи созданы.  
  **EN:** When you call another assistant, ensure they keep their own logs (`local/<name>/requests.log`, `sessions.log`) under the same rules and confirm the entries exist.
- **RU:** Перед отправкой ответа убедись, что текущий запрос уже записан в `local/<имя ассистента>/requests.log`; если записи нет, добавь её отдельной командой немедленно.  
  **EN:** Before sending a reply, make sure the current interaction is already stored in `local/<assistant-name>/requests.log`; if it is missing, append it immediately using a dedicated command.
- **RU:** **ВАЖНО:** Команды логирования (например, `echo '...' >> .../requests.log`) выполняй отдельным вызовом `run_shell_command`; остальные команды запускай только после согласования.  
  **EN:** **IMPORTANT:** Execute logging commands (e.g., `echo '...' >> .../requests.log`) in a separate `run_shell_command`; run all other commands only after approval.

## Управление контекстом / Context Management

- **RU:** Держи `local/session_history.md` как единственный источник истины: добавляй хронологию шагов, ссылки и выводы.  
  **EN:** Treat `local/session_history.md` as the single source of truth: append chronological steps, references, and findings there.
- **RU:** Пользуйся инструментами поиска и диффа контекста, как только они будут добавлены, чтобы быстро находить прошлые договорённости.  
  **EN:** Use the context search and diff tools as soon as they are available to retrieve past agreements quickly.
- **RU:** Планируй автоматическую очистку устаревших записей и сверяй её с требованиями к хранению.  
  **EN:** Plan automated cleanup of stale entries and align it with the retention requirements.
- **RU:** При работе нескольких ассистентов синхронизируй обновления сразу после консультации, чтобы исключить расхождения.  
  **EN:** When multiple assistants collaborate, sync updates immediately after the consultation to avoid drift.

## Проектные дополнения / Project-Specific Extensions

- **RU:** Если в репозитории есть дополнительные инструкции (например, `local/project_addenda.md` или `docs/assistant-addenda/`), сообщи об этом пользователю и действуй по ним после согласования.  
  **EN:** If the repository provides extra instructions (for example, `local/project_addenda.md` or `docs/assistant-addenda/`), inform the user and follow them once aligned.
- **RU:** При отсутствии явных дополнений уточни у пользователя, нужно ли учитывать внешние документы или рабочие соглашения.  
  **EN:** When no addenda exist, confirm with the user whether external documents or working agreements apply.
- **RU:** Перед использованием проектных дополнений сверяй дату/версию и при расхождениях уведомляй пользователя.  
  **EN:** Before relying on project addenda, check their date/version and alert the user about discrepancies.
- **RU:** Сохраняй двуязычный формат: расширяя шаблон, добавляй одинаковые блоки на русском и английском.  
  **EN:** Maintain the bilingual layout: whenever you extend the template, add matching Russian and English entries.
- **RU:** Если дополнения задают требования к инструментам или окружению, убедись, что они не конфликтуют с базовым шаблоном, и предупреди пользователя, если конфликт есть.  
  **EN:** When addenda define tooling or environment requirements, ensure they do not conflict with this template and warn the user if they do.

## Контроль версий / Version Control

- **RU:** Не коммить и не пушь изменения — этим занимается пользователь.  
  **EN:** Do not commit or push changes; the user handles that.
- **RU:** Не удаляй локальные вспомогательные файлы пользователя без согласования.  
  **EN:** Do not delete the user’s local helper files without alignment.

**RU:** Соблюдение этих правил помогает поддерживать единый процесс и снижает риск регрессий.  
**EN:** Following these rules keeps the workflow consistent and reduces the risk of regressions.
