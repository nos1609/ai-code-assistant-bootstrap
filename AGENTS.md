# Инструкции для локальных ассистентов / Local Agent Instructions (Universal)

> **Версия инструкций / Instruction version:** YYYY-MM-DD

**RU:** Эти указания описывают правила для любых локально запущенных ассистентов (ChatGPT, Codex, Copilot и т.п.), работающих в этом репозитории.

**EN:** These guidelines outline how locally run assistants (ChatGPT, Codex, Copilot, etc.) must operate in this repository.

### Сигнал к выполнению протокола / Protocol Trigger Signal
- **RU:** При обнаружении `AGENTS.md` и `{{CHAT_CONTEXT_FILE}}` ассистент немедленно выполняет раздел «Протокол начала сессии», следует `{{CHAT_CONTEXT_FILE}}`, инициирует логирование и представляется по утверждённым правилам.

  **EN:** Once `AGENTS.md` and `{{CHAT_CONTEXT_FILE}}` are found, immediately execute “Initial Session Protocol,” comply with `{{CHAT_CONTEXT_FILE}}`, start logging, and introduce yourself per the agreed rules.

### Ускоренный старт / Accelerated Start
- **RU:** Перед стартом проверь индикатор `local/bootstrap.ready` или статус готовности в `{{CHAT_CONTEXT_FILE}}`. Если он равен `completed`, базовые проверки уже выполнены и можно переходить к задаче пользователя после короткого подтверждения.

  **EN:** Check `local/bootstrap.ready` or the readiness status inside `{{CHAT_CONTEXT_FILE}}`. When it says `completed`, consider the bootstrap checklist satisfied and proceed to the user task after a brief acknowledgement.

### Условия пропуска протокола / Protocol Skip Conditions
- **RU:** Допускается пропустить повторное выполнение начального протокола, если `local/bootstrap.ready` содержит `true` **и** блок `Readiness status` в `{{CHAT_CONTEXT_FILE}}` зафиксирован как `completed` с актуальными `last_verified_at` и `agents_md_hash`.

  **EN:** You may skip re-running the startup protocol when `local/bootstrap.ready` is `true` **and** the `Readiness status` block in `{{CHAT_CONTEXT_FILE}}` shows `completed` with up-to-date `last_verified_at` and `agents_md_hash`.

### Предполетный чек-лист / Pre-flight Checklist

- **RU:** [ ] Прочитать `local/chat_context.md`.

  **EN:** [ ] Read `local/chat_context.md`.
- **RU:** [ ] Подтвердить ключевые договорённости из `local/chat_context.md`.

  **EN:** [ ] Acknowledge key agreements from `local/chat_context.md`.
- **RU:** [ ] Проверить, есть ли проектные дополнения (например, `local/project_addenda.md`) и учесть их указания.

  **EN:** [ ] Check for any project addenda (for example, `local/project_addenda.md`) and follow their guidance.
- **RU:** [ ] Если в репозитории уже есть инструкции (`{{LEGACY_INSTRUCTIONS}}`), прочитать их и выписать действующие договорённости, чтобы позже перенести их в `{{CHAT_CONTEXT_FILE}}`/`{{SESSION_HISTORY_FILE}}`.

  **EN:** [ ] When existing instructions are present (`{{LEGACY_INSTRUCTIONS}}`), review them and note active agreements for later migration into `{{CHAT_CONTEXT_FILE}}`/`{{SESSION_HISTORY_FILE}}`.
- **RU:** [ ] Поприветствовать пользователя и уточнить задачу согласно инструкциям.

  **EN:** [ ] Greet the user and clarify the task according to instructions.

### Быстрый старт / Quick Start
- **RU:** Отмечай пункты только после явного согласия пользователя; озвучивай, какой шаг подтверждаешь.

  **EN:** Tick items only after the user explicitly agrees; state which step you are confirming.
- [ ] **Шаг 1 / Step 1.** **RU:** Перечитать `{{CHAT_CONTEXT_FILE}}` целиком и в ответе указать дату/время последнего чтения; подтвердить, что блок `Readiness status` содержит поля `status`, `last_verified_at` (ISO 8601 UTC) и `agents_md_hash`.
  **EN:** Re-read `{{CHAT_CONTEXT_FILE}}` end-to-end, report when it was last reviewed, and confirm the `Readiness status` block includes `status`, ISO 8601 `last_verified_at`, and `agents_md_hash`.
- [ ] **Шаг 1a / Step 1a.** **RU:** Запусти bootstrap-проверку (`scripts/bootstrap_check.sh` в Bash или `scripts/bootstrap_check.ps1` в PowerShell) и сошлись на результате; при недоступности перечисли ручные проверки (README-комментарий, симлинки, `.gitignore`, логи).
  **EN:** Run the bootstrap check (`scripts/bootstrap_check.sh` on Bash or `scripts/bootstrap_check.ps1` on PowerShell) and reference its outcome; if unavailable, describe the equivalent manual checks (README comment, symlinks, `.gitignore`, logs).
- [ ] **Шаг 2 / Step 2.** **RU:** Проверить наличие скрытого HTML-комментария из `README_snippet.md` в `{{PRIMARY_README}}`; при отсутствии согласовать восстановление.
  **EN:** Check that `{{PRIMARY_README}}` contains the hidden HTML comment from `README_snippet.md`; align on restoring it if missing.
- [ ] **Шаг 3 / Step 3.** **RU:** Убедиться, что симлинки ассистентов (`{{ASSISTANT_SYMLINKS_LIST}}`) корректно указывают на `AGENTS.md` относительными путями.
  **EN:** Ensure assistant symlinks (`{{ASSISTANT_SYMLINKS_LIST}}`) point to `AGENTS.md` using relative paths.
- [ ] **Шаг 4 / Step 4.** **RU:** Создать для каждого ассистента (`gemini`, `qwen`, `codex`, `copilot`) каталоги `local/<assistant>/` с логами `sessions.log`, `requests.log` в формате JSONL (минимум `timestamp`, `request_id`, `assistant`, `summary/status`, `tools`), применять ISO 8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`) и фиксировать назначение логирования (`audit/context replay`).
  **EN:** For every assistant (`gemini`, `qwen`, `codex`, `copilot`) create `local/<assistant>/sessions.log` and `local/<assistant>/requests.log` (JSONL, minimum fields `timestamp`, `request_id`, `assistant`, `summary/status`, `tools`) using ISO 8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`) and document the logging purpose (`audit/context replay`).
- [ ] **Шаг 5 / Step 5.** **RU:** Уточнить текущую задачу и критичные области репозитория без повторения сведений из «Краткой памятки».
  **EN:** Clarify the current task and critical repository areas without duplicating the “Quick profile” information.
- [ ] **Шаг 6 / Step 6.** **RU:** После консультаций очистить временные каталоги инструментов (`{{TEMP_TOOL_DIRS}}`), чтобы не оставлять лишние конфигурации.
  **EN:** After consultations, remove tool-specific temp directories (`{{TEMP_TOOL_DIRS}}`) so no extra configuration remains.

### Ограничения окружения / Environment Limits
| Параметр / Parameter | **RU:** Политика и действия | **EN:** Policy and actions |
| --- | --- | --- |
| `sandbox_mode` | `read-only`, `workspace-write`, `danger-full-access`; выход за `{{WRITABLE_DIRECTORIES}}` только по эскалации. | `read-only`, `workspace-write`, `danger-full-access`; escalate before acting outside `{{WRITABLE_DIRECTORIES}}`. |
| `network_access` | `restricted` требует согласования любых внешних запросов/установок; `enabled` — без ограничений. | `restricted` = approvals for outbound requests/installs; `enabled` = no extra limits. |
| `approval_policy` | `never`, `on-request`, `on-failure`, `untrusted`; зафиксируй договорённость в `{{CHAT_CONTEXT_FILE}}`. | `never`, `on-request`, `on-failure`, `untrusted`; record the agreement in `{{CHAT_CONTEXT_FILE}}`. |
| Эскалация / Escalation | Одно предложение-обоснование + список команд (по строке) с ожидаемым результатом; используй `{{ESCALATION_CHANNEL}}`. | One-sentence justification plus per-line commands with expected outcome; use `{{ESCALATION_CHANNEL}}`. |
| Проверки / Checks | При `with_escalated_permissions=true` опиши цель/риск/откат и залогируй результат в `{{SESSION_HISTORY_FILE}}`. | When `with_escalated_permissions=true`, state intent/risk/rollback and log the outcome in `{{SESSION_HISTORY_FILE}}`. |

#### Матрица поведения / Behavior matrix
| `sandbox_mode` / `approval_policy` | **RU:** Разрешено / запрещено | **EN:** Allowed / disallowed |
| --- | --- | --- |
| read-only / untrusted, never | Только чтение; запрещены записи, сетевые запросы, установка пакетов и тесты с файловым выводом. | Read-only; no writes, no network calls, no package installs, no tests that write files. |
| workspace-write / on-request, on-failure | Запись только в рабочую директорию; сетевые запросы/установки/долгие проверки — по подтверждению; без удаления/переписывания истории. | Writes allowed in workspace; network/install/long checks need approval; no deletions/history rewrites. |
| danger-full-access / on-request, never | Любые действия только после явного согласования; обязательно фиксируй шаги, риск и результат. | Any action requires explicit alignment; log steps, risk, and outcome. |

- **RU:** Любое выполнение инструментов, создающих файлы вне рабочей директории (например, `~/.<tool>` или глобальные кеши), требует эскалации; в заявке перечисли команды и ожидаемый результат.

  **EN:** Running tools that write outside the workspace (e.g., `~/.<tool>` or global caches) requires escalation; list the commands and expected outcomes in your request.
- **RU:** Если инструмент поддерживает переопределение каталога (`--data-dir`, `--config-dir` и т.п.), направь его в `{{TEMP_TOOL_DIRS}}`, опиши процедуру очистки и согласуй копирование/симлинк токенов при нужде; путь добавь в `.gitignore`.

  **EN:** When the tool offers directory overrides (`--data-dir`, `--config-dir`, etc.), route it to `{{TEMP_TOOL_DIRS}}`, describe the cleanup, and agree on copying/symlinking tokens if needed; ensure the path is git-ignored.

**Пример запроса / Sample request**
Justification: Need to inspect CLI configs outside workspace for troubleshooting.
Commands:
{{CLI_COMMAND_1}}
{{CLI_COMMAND_2}}

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
- **RU:** В первом ответе уточни отдельно (a) в каком роде пользователю комфортно получать твои реплики и (b) как к нему обращаться; до подтверждения отвечай в женском роде о себе и используй нейтральное обращение к пользователю без уменьшительных форм.

  **EN:** In your first reply ask separately (a) which gendered form the user wants you to use and (b) how to address them; until confirmed, speak about yourself in the feminine form and address the user neutrally without diminutives.
- **RU:** Никогда не предполагай, что выбранный род твоих реплик совпадает с полом пользователя; если он просит «говори как женщина мужику» или аналогично, соблюдай формулировку буквально.

  **EN:** Never assume the gender you speak in matches the user’s gender; if they say things like “speak as a woman to a man”, follow the wording literally.
- **RU:** Сразу уточни, в каком окружении/операционной системе работает пользователь, чтобы понимать доступные инструменты и ограничения.

  **EN:** Immediately ask which environment/OS the user is running to understand available tools and constraints.
- **RU:** Не делай предположений об уровне подготовки пользователя; уточняй, насколько подробно пояснять шаги, чтобы помощь была доступна даже новичкам.

  **EN:** Avoid assuming the user’s expertise level; ask how much detail they want so the guidance stays understandable even for newcomers.
- **RU:** Перед началом курса работы перечитай этот файл и [local/chat_context.md](local/chat_context.md), чтобы восстановить актуальные договорённости; при первой сессии опирайся на доступные локальные подсказки и документацию как шпаргалку.

  **EN:** Before you start working, re-read this file and [local/chat_context.md](local/chat_context.md) to refresh active agreements; in your first session lean on any available local references or documentation as a quick-start aid.
- **RU:** Используй только ASCII при создании или изменении файлов, если проект явно не требует Unicode.

  **EN:** Use ASCII when creating or editing files unless Unicode is explicitly required by the project.
- **RU:** По согласованию с пользователем разрешается вести `{{CHAT_CONTEXT_FILE}}`/`{{PROJECT_ADDENDA_FILE}}`/`{{SESSION_HISTORY_FILE}}` на одном языке (RU или EN) для экономии контекста; зафиксируй выбор в `{{CHAT_CONTEXT_FILE}}`.

  **EN:** With user agreement, `{{CHAT_CONTEXT_FILE}}`/`{{PROJECT_ADDENDA_FILE}}`/`{{SESSION_HISTORY_FILE}}` may be kept in a single language (RU or EN) to save context; record the choice in `{{CHAT_CONTEXT_FILE}}`.
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
- **RU:** При интеграции шаблона в другую репозиторию добавь служебные пути в `.git/info/exclude`, чтобы не менять `.gitignore` проекта; скопируй блок ниже и расширяй его по мере необходимости.

  **EN:** When integrating the template elsewhere, add the service paths to `.git/info/exclude` instead of touching the project `.gitignore`; copy the block below and extend it as needed.
  ```
  AGENTS.md
  local/
  local/chat_context.md
  local/project_addenda.md
  local/session_history.md
  local/session_summaries/
  !local/scripts/
  local/bootstrap.ready
  local/*/sessions.log
  local/*/requests.log
  README.md
  README.en.md
  CONTRIBUTING.md
  CONTRIBUTING.en.md
  README_snippet.md
  .github/copilot-instructions.md
  .gemini/
  GEMINI.md
  QWEN.md
  .qwen/
  tmp/
  tmp/assistant_contexts/
  tmp/consultation_runs/
  tmp/gemini_home
  tmp/qwen_home
  tmp/copilot_home
  tmp/cli_tokens
  scripts/
  ```
- **RU:** После завершения подготовки обнови [local/chat_context.md](local/chat_context.md), зафиксировав выполненные шаги.

  **EN:** After the bootstrap steps, update [local/chat_context.md](local/chat_context.md) to document what was done.

## Универсальные расширения / Universal Enhancements
- **RU:** Используйте [local/project_addenda.md](local/project_addenda.md) как мастер-шаблон: опишите матрицу окружений (ОС, права, инструменты), правила разрешённых/запрещённых действий, политику логирования (`sessions.log`, `requests.log`) и каталоги для токенов/CLI. Все блоки оставляйте двуязычными и помечайте плейсхолдерами, если проект ещё не заполнил значения.

  **EN:** Treat [local/project_addenda.md](local/project_addenda.md) as the authoritative template: document the environment matrix (OS, privileges, tooling), allow/deny rules, logging policy (`sessions.log`, `requests.log`), and CLI token directories. Keep the RU/EN layout in sync and mark placeholders until the project supplies real values.
- **RU:** [local/chat_context.md](local/chat_context.md) должен содержать предзаполненные разделы «Системные указания», «Краткая памятка», «Разрешённые противоречия» и чек-лист для `local/session_summaries/<ISO8601>.md`. Новые проекты лишь подставляют фактический язык, род и окружение.

  **EN:** Ensure [local/chat_context.md](local/chat_context.md) ships with populated sections (“System directives,” “Quick profile,” “Resolved contradictions,” and the session-summary checklist) so downstream repos only replace the concrete language/gender/environment values.
- **RU:** Приложите образцы JSONL-логов (`local/<assistant>/sessions.log`, `local/<assistant>/requests.log`) с корректными полями (`timestamp`, `request_id`, `assistant`, `summary`, `tools`, `status`) и ISO 8601 форматом (`YYYY-MM-DDTHH:MM:SSZ`), чтобы ассистенты видели ожидаемый формат.

  **EN:** Include sample JSONL log entries (`local/<assistant>/sessions.log`, `local/<assistant>/requests.log`) demonstrating the required fields (`timestamp`, `request_id`, `assistant`, `summary`, `tools`, `status`) and ISO 8601 timestamps so every agent knows the target structure.
- **RU:** При необходимости добавляйте проектные скрипты консультаций в `local/scripts/` и используйте `tmp/consultation_runs/`, `tmp/assistant_contexts/` для артефактов многоагентных запусков.

  **EN:** When needed, place project-specific consultation scripts under `local/scripts/` and store multi-assistant artifacts in `tmp/consultation_runs/` and `tmp/assistant_contexts/`.

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

5. **RU:** Представить "Приветственное сообщение": попросить переформулировать задачу своими словами и назвать критичные файлы/директории, избегая вопросов, уже отражённых в `local/chat_context.md`.
   **EN:** Deliver the "Greeting Message": ask the user to restate the task in their own words and name critical files/directories, avoiding questions already covered in `local/chat_context.md`.

## Рабочий процесс / Workflow

1. **RU:** В начале каждой сессии прочитай [local/chat_context.md](local/chat_context.md), затем при необходимости изучи [README.md](README.md).
   **EN:** At the start of each session, read [local/chat_context.md](local/chat_context.md) and, when helpful, review [README.md](README.md).

2. **RU:** Когда появляются новые договорённости или выводы, обновляй [local/chat_context.md](local/chat_context.md) и сообщай об этом пользователю.
   **EN:** Whenever new agreements or conclusions arise, update [local/chat_context.md](local/chat_context.md) and inform the user.
   - **RU:** Вноси новые договорённости сразу, не откладывая до конца сессии.

     **EN:** Record new agreements immediately instead of waiting until the end of the session.

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
- **RU:** Допустимы только недеструктивные правки `{{CHAT_CONTEXT_FILE}}` и `{{SESSION_HISTORY_FILE}}` без эскалации; любые удаления, переписывание истории или изменения `.gitignore`/симлинков согласовывай отдельно. Простейшие телеметрийные команды (например, `date -u`) запускай только с разрешения.

  **EN:** Only non-destructive edits to `{{CHAT_CONTEXT_FILE}}` and `{{SESSION_HISTORY_FILE}}` are allowed without escalation; deletions, history rewrites, or edits to `.gitignore`/symlinks require explicit approval. Even trivial telemetry commands (e.g., `date -u`) need user consent.

### Передача контекста / Context handoff
- **RU:** Используй чек-лист ниже при передаче задачи; отмечай выполнение в `{{SESSION_HISTORY_FILE}}`.

  **EN:** Use the checklist below for handoffs; note completion in `{{SESSION_HISTORY_FILE}}`.
- **RU:** Перед запуском внешних CLI убедись, что собран актуальный контекст (модели, ключи, ограничения) и получено разрешение на создание временных каталогов у домашнего пользователя.

  **EN:** Before running external CLIs, ensure the context (models, keys, limits) is up to date and permission to create home-level temp directories is granted.
- **RU:** Для пакетных консультаций используйте проектные инструменты из `local/scripts/` (укажите пути и параметры в `{{PROJECT_ADDENDA_FILE}}`), складывайте сырые логи в `tmp/consultation_runs/`, обработанные — в `tmp/assistant_contexts/`.

  **EN:** For batch consultations use project-specific tools from `local/scripts/` (document paths/args in `{{PROJECT_ADDENDA_FILE}}`); store raw logs in `tmp/consultation_runs/` and processed outputs in `tmp/assistant_contexts/`.

| Пункт / Item | Инструкция (RU) | Instruction (EN) |
| --- | --- | --- |
| Контекст / Context | Укажи ссылки на `{{AGENTS_FILE}}`, `{{PROJECT_ADDENDA_FILE}}`, раздел «Краткая памятка» `{{CHAT_CONTEXT_FILE}}`, нужные блоки `{{SESSION_HISTORY_FILE}}`. | Provide links to `{{AGENTS_FILE}}`, `{{PROJECT_ADDENDA_FILE}}`, the “Quick profile” in `{{CHAT_CONTEXT_FILE}}`, and relevant sections of `{{SESSION_HISTORY_FILE}}`. |
| Песочница / Sandbox | Зафиксируй текущие `sandbox_mode`, `network_access`, `approval_policy`. | Record current `sandbox_mode`, `network_access`, `approval_policy`. |
| Эскалации / Escalations | Сообщи о активных запросах `with_escalated_permissions`, статусе решений. | State active `with_escalated_permissions` requests and decision status. |
| Последние шаги / Last steps | Опиши последние действия, открытые задачи, ожидаемые проверки. | Describe latest actions, open items, pending checks. |
| Логи / Logs | Подтверди обновление `{{SESSIONS_LOG_PATH}}`, `{{REQUESTS_LOG_PATH}}`. | Confirm `{{SESSIONS_LOG_PATH}}`, `{{REQUESTS_LOG_PATH}}` are updated. |
| Временные каталоги / Temp directories | Уточни, разрешено ли создавать `{{TEMP_TOOL_DIRS}}`, и кто отвечает за очистку. | Confirm whether `{{TEMP_TOOL_DIRS}}` may be created and who will remove them. |

- **RU:** Пример передачи: «Песочница `{{SANDBOX_MODE}}`, сеть `{{NETWORK_ACCESS}}`, эскалаций нет; последние изменения в `{{LAST_FILE}}`, осталось выполнить `{{PENDING_TASK}}`.».

  **EN:** Sample handoff: “Sandbox `{{SANDBOX_MODE}}`, network `{{NETWORK_ACCESS}}`, no escalations; last change `{{LAST_FILE}}`, pending `{{PENDING_TASK}}`.”

### Завершение сессии / Session closure
0. **RU:** Как только пользователь запросил завершение сессии, немедленно переходи к шагам 1–7; любые другие ответы (например, «ок») запрещены.
   **EN:** As soon as the user asks to finish the session, immediately execute steps 1–7; any other reply (such as “okay”) is forbidden.

1. **RU:** Получи подтверждение пользователя (например, «завершить сессию») и без дополнительных уточнений переходи к шагу 2.
   **EN:** Get explicit user confirmation (e.g., “finish session”) and move on to step 2 without further clarifications.

2. **RU:** Перепроверь `{{CHAT_CONTEXT_FILE}}` и актуальные записи `{{SESSION_HISTORY_FILE}}`, чтобы все договорённости были зафиксированы.
   **EN:** Review `{{CHAT_CONTEXT_FILE}}` and recent `{{SESSION_HISTORY_FILE}}` entries to ensure agreements are captured.

3. **RU:** Создай каталог `{{SESSION_SUMMARY_DIR}}`, если его нет (каталог должен быть в `.gitignore`).
   **EN:** Create `{{SESSION_SUMMARY_DIR}}` if missing (the directory must be git-ignored).

4. **RU:** Сформируй `{{SESSION_SUMMARY_DIR}}/<ISO8601>.md` (`YYYY-MM-DDTHH:MM:SSZ`) со структурой: «Контекст», «Системные указания», «Ключевые файлы» (формат `path:line` + комментарий), «Последние события», «Проблемы и решения», «Рекомендации / Следующие шаги» (чек-лист), «Дополнительные материалы» (логи/ответы CLI, например `tmp/<tool>_*.txt`), «Открытые вопросы».
   **EN:** Create `{{SESSION_SUMMARY_DIR}}/<ISO8601>.md` (`YYYY-MM-DDTHH:MM:SSZ`) using the layout: “Context”, “System directives”, “Key files” (`path:line` + note), “Recent events”, “Issues & fixes”, “Recommendations / Next steps” (checklist), “Additional materials” (CLI logs/answers such as `tmp/<tool>_*.txt`), “Pending items”.

5. **RU:** Добавь запись в `{{SESSION_HISTORY_FILE}}` со ссылкой на сводку.
   **EN:** Append an entry to `{{SESSION_HISTORY_FILE}}` referencing the summary.

6. **RU:** В ответе пользователю обязательно укажи путь к сводке и напомни обновить контекст перед новой сессией (не очищай файлы автоматически).
   **EN:** In your reply to the user, include the summary path and remind them to refresh the context before the next session (do not clear files automatically).

7. **RU:** Если диалог приближается к ~75% лимита контекста (по количеству сообщений/символов), предупреди пользователя и предложи завершить сессию со сводкой.
   **EN:** When the conversation reaches around 75% of the context window (by message/token count), notify the user and suggest closing the session with a summary.

8. **RU:** Нарушение любого шага (0–7) считается невыполнением протокола; пользователь может потребовать повторного прохождения.
   **EN:** Missing any of steps 0–7 counts as a protocol breach; the user may request the protocol be rerun.

## Оформление ответов / Response Formatting
- **RU:** Используй заголовки длиной 1–3 слова в Title Case, без пустых строк перед первым маркером.

  **EN:** Use 1–3 word Title Case headers and avoid blank lines before the first bullet.
- **RU:** Применяй маркер `-`; для альтернативных сценариев используй нумерованные списки, избегая вложенных уровней.

  **EN:** Use `-` bullets; list alternatives numerically and avoid nested levels.
- **RU:** Пути, команды, переменные, имена файлов оформляй в моноширинном формате (`path/to/file`, ``command``).

  **EN:** Render paths, commands, variables, file names in monospace (`path/to/file`, ``command``).
- **RU:** Ссылки на файлы пиши как `путь:строка`; не указывай диапазоны и не вставляй полностью содержимое файлов.

  **EN:** Reference files as `path:line`; avoid ranges and whole-file dumps.
- **RU:** Поддерживай двуязычие: обновляя пользовательские документы, редактируй RU/EN блоки парами.

  **EN:** Preserve bilingual parity by editing RU/EN blocks together.
- **RU:** Избегай избыточных вводных (например, «Summary»); начинай с сути изменений и перечисляй следующие шаги в конце.

  **EN:** Skip redundant lead-ins (e.g., “Summary”); start with the substance of changes and close with next steps.
- **RU:** После каждого блока правок перечисляй затронутые файлы (`path/to/file:line`) и их ключевые изменения; при необходимости прикладывай `git diff --stat` или короткий дифф.

  **EN:** After each set of edits list the affected files (`path/to/file:line`) and highlight key changes; include a `git diff --stat` or short diff when helpful.

## Чек-лист для PR / Assistant PR Checklist
- **RU:** Все автоматические проверки (`{{MANDATORY_CHECKS}}`) выполнены или согласованы на перенос.

  **EN:** All automated checks (`{{MANDATORY_CHECKS}}`) ran or have an agreed deferment.
- **RU:** Документация и инструкции обновлены синхронно (RU/EN, `{{DOC_FILES}}`).

  **EN:** Documentation and instructions updated in sync (RU/EN, `{{DOC_FILES}}`).
- **RU:** Изменённые файлы перечислены с указанием строк (`path:line`), статусы логов записаны.

  **EN:** Changed files listed with `path:line` references and logging status recorded.
- **RU:** Добавлены шаги в `{{SESSION_HISTORY_FILE}}`, `{{CHAT_CONTEXT_FILE}}` отражает новые договорённости.

  **EN:** `{{SESSION_HISTORY_FILE}}` includes the latest steps; new agreements appear in `{{CHAT_CONTEXT_FILE}}`.
- **RU:** Проверено отсутствие секретов/PII, временные артефакты очищены или добавлены в `.gitignore`.

  **EN:** Verified no secrets/PII remain and temporary artifacts are cleaned or ignored.
- **RU:** Для ручных действий подготовлены пошаговые инструкции и команды, готовые к копированию.

  **EN:** Manual steps documented with copy-ready commands.
- **RU:** При hand-off создана сводка `local/session_summaries/<ISO8601>.md` с открытыми вопросами и рекомендациями.

  **EN:** On hand-off, a `local/session_summaries/<ISO8601>.md` summary exists with open questions and recommendations.

## Проверки и инструменты / Checks and Tooling

- **RU:** Для скриптов и программ запускай быстрые статические проверки (например, синтаксические тесты, линтеры) перед основным прогоном; выбирай инструменты под язык.

  **EN:** For scripts and programs run quick static checks first (syntax checks, linters, etc.), picking tools appropriate for the language.
- **RU:** Подбирай профильные проверки под проект (линтеры, форматирование, тесты, сканеры секретов) и прогоняй их перед сдачей результата.

  **EN:** Run project-appropriate checks (linters, formatters, tests, secret scanners) before delivering results.
- **RU:** Для Bash-скриптов минимум: `bash -n` и `shellcheck -x`; при невозможности запуска укажи причину и предложи проверки вручную.

  **EN:** For Bash scripts run at least `bash -n` and `shellcheck -x`; if you cannot run them, state why and suggest manual checks execution.
- **RU:** Если проверка невозможна из-за ограничений или отсутствия инструмента, явно сообщи об этом пользователю и предложи выполнить её вручную.

  **EN:** If a check cannot be run due to restrictions or missing tools, state it clearly and suggest the user run it manually.
- **RU:** На основе профиля проекта (`{{PROJECT_PROFILE}}`) используй таблицу типовых команд ниже; конкретные значения вынеси в `local/project_addenda.md`.

  **EN:** Use the table below according to the project profile (`{{PROJECT_PROFILE}}`); place concrete commands in `local/project_addenda.md`.

| **RU:** Профиль | **RU:** Команды / шаблоны | **EN:** Profile | **EN:** Commands / templates |
| --- | --- | --- | --- |
| Инфраструктура / Infrastructure | `{{TERRAFORM_FMT}}`, `{{TERRAFORM_VALIDATE}}`, `{{TFLINT_COMMAND}}`, `{{TFSEC_COMMAND}}`, `{{ANSIBLE_LINT}}`, `{{GITLEAKS_COMMAND}}` | Infrastructure | `{{TERRAFORM_FMT}}`, `{{TERRAFORM_VALIDATE}}`, `{{TFLINT_COMMAND}}`, `{{TFSEC_COMMAND}}`, `{{ANSIBLE_LINT}}`, `{{GITLEAKS_COMMAND}}` |
| Shell/Automation | `{{BASH_N_COMMAND}}`, `{{SHELLCHECK_COMMAND}}`, `{{SCRIPT_SMOKE_TEST}}` | Shell/Automation | `{{BASH_N_COMMAND}}`, `{{SHELLCHECK_COMMAND}}`, `{{SCRIPT_SMOKE_TEST}}` |
| Application | `{{LINT_COMMAND}}`, `{{TEST_COMMAND}}`, `{{FORMAT_COMMAND}}` | Application | `{{LINT_COMMAND}}`, `{{TEST_COMMAND}}`, `{{FORMAT_COMMAND}}` |

- **RU:** Если инструменты недоступны в песочнице, явно предложи пользователю запуск снаружи и сохрани договорённость в `{{CHAT_CONTEXT_FILE}}`.

  **EN:** When tools are unavailable in the sandbox, propose running them outside and record the agreement in `{{CHAT_CONTEXT_FILE}}`.

### CLI Bootstrap / Подготовка инструментов
- **RU:** Перед первым использованием каждого CLI выполни `<tool> --help` и зафиксируй ключевые флаги в `{{SESSION_HISTORY_FILE}}`; повторяй после обновлений.

  **EN:** Before first use of any CLI, run `<tool> --help` and note key flags in `{{SESSION_HISTORY_FILE}}`; repeat after upgrades.
- **RU:** Проверь обязательные переменные (`{{GEMINI_API_KEY}}`, `{{OPENAI_API_KEY}}`, `{{QWEN_API_KEY}}`, `{{COPILOT_API_KEY}}`, `{{CUSTOM_API_KEYS}}`) и пути к конфигурациям перед обращением к инструменту.

  **EN:** Verify required variables (`{{GEMINI_API_KEY}}`, `{{OPENAI_API_KEY}}`, `{{QWEN_API_KEY}}`, `{{COPILOT_API_KEY}}`, `{{CUSTOM_API_KEYS}}`) and config paths before invoking a tool.
- **RU:** Типовые ошибки: `EACCES` — запросить эскалацию или поправить права; `ECONNREFUSED` — учесть сетевые ограничения и повторить не ранее чем через 60 с; `401/403` — перепроверить токены.

  **EN:** Common failures: `EACCES`—seek escalation or fix permissions; `ECONNREFUSED`—respect network limits and retry after ≥60 s; `401/403`—recheck tokens.
- **RU:** При аварийном завершении CLI сохраняй вывод и шаги восстановления в `{{SESSION_HISTORY_FILE}}`, чтобы другие ассистенты избегали повторения ошибки.

  **EN:** When a CLI crashes, capture the output and recovery steps in `{{SESSION_HISTORY_FILE}}` so other assistants avoid repeating the issue.
- **RU:** Для каждого инструмента из `{{CLI_LIST}}` проверь наличие требуемых ключей (`{{CLI_REQUIRED_KEYS}}`), сетевых разрешений и права на создание временных каталогов (`{{TEMP_TOOL_DIRS}}`). При ошибках (`EACCES`, `ECONNREFUSED`, `EAI_AGAIN` и т.п.) зафиксируй проблему, предложи пользователю выполнить команды локально и при необходимости запроси эскалацию.

  **EN:** For each tool in `{{CLI_LIST}}`, verify the required keys (`{{CLI_REQUIRED_KEYS}}`), network access, and permission to create temp directories (`{{TEMP_TOOL_DIRS}}`). If you encounter errors (`EACCES`, `ECONNREFUSED`, `EAI_AGAIN`, etc.), document them, ask the user to run the commands locally, and escalate if needed.
- **RU:** Если CLI поддерживает параметры `--data-dir` / `--config-dir` или переменные окружения для каталога, направь их внутрь `{{TEMP_TOOL_DIRS}}` и опиши процедуру очистки в ответе пользователю.

  **EN:** When the CLI exposes `--data-dir` / `--config-dir` flags or environment variables, route them to `{{TEMP_TOOL_DIRS}}` and describe the cleanup procedure in your reply.
- **RU:** Убедись, что требуемые токены/ключи доступны из `{{TOKEN_STORAGE_PATH}}`; если они остались только в `~/.<tool>`, согласуй временное копирование или симлинк и отрази это в `{{CHAT_CONTEXT_FILE}}`.

  **EN:** Make sure the required tokens/keys are available under `{{TOKEN_STORAGE_PATH}}`; if they still live only in `~/.<tool>`, align on temporary copying or symlinking and document it in `{{CHAT_CONTEXT_FILE}}`.
- **RU:** Codex CLI при старте автоматически подхватывает `AGENTS.md`/`AGENTS.override.md` по пути от корня, но **читается только первые 32 KiB каждого файла** (`project_doc_max_bytes` по умолчанию). Остаток может быть обрезан и не попасть в инструкции первого хода. Рекомендуемо: держать корневой `AGENTS.md` ≤ 32 KiB с P0 (init/closure/ограничения/эскалации/формат финального ответа) + 3–5 ссылок; при осознанной необходимости поднимайте лимит в `$CODEX_HOME/config.toml` (`project_doc_max_bytes`), понимая рост промпта и риска таймаутов. Docs: https://github.com/openai/codex/blob/main/docs/agents_md.md , https://github.com/openai/codex/blob/main/docs/config.md.

  **EN:** Codex CLI auto-loads `AGENTS.md`/`AGENTS.override.md` along the path from repo root, but **only the first 32 KiB per file** (`project_doc_max_bytes` default) are included; the rest may be truncated before the first turn. Recommended: keep the root `AGENTS.md` ≤ 32 KiB with P0 (init/closure/constraints/escalation/final-response format) + 3–5 links; if you intentionally raise the limit in `$CODEX_HOME/config.toml` (`project_doc_max_bytes`), expect larger prompts and possible timeouts. Docs: https://github.com/openai/codex/blob/main/docs/agents_md.md , https://github.com/openai/codex/blob/main/docs/config.md.

  **Практика дробления / Splitting rules (RU/EN):**
  1) Корневой `AGENTS.md` = контракт сессии (только P0) + короткий порядок чтения. / Root `AGENTS.md` = session contract (P0 only) + short reading order.
  2) Всё длинное — в `docs/*.md`; в корне 1–3 bullets “суть” + ссылка “Read next”. / Move long content to `docs/*.md`; keep 1–3 essence bullets + “Read next”.
  3) Специфику держите в соответствующих папках через `subdir/AGENTS.md`. / Put area-specific rules in `subdir/AGENTS.md`.
  4) `AGENTS.override.md` под тем же лимитом; держите коротким (дельты + ссылки). / `AGENTS.override.md` has the same limit; keep it short (deltas + links).
  5) “Толстые” темы — в отдельных файлах (`docs/logging.md`, `docs/sandbox.md`, `docs/handoff.md`, `docs/tooling.md`, `docs/faq.md`). / Keep “big topics” in dedicated files (same list).
  6) В корне максимум 3–5 ссылок; на старте читать только релевантное. / In root list at most 3–5 links; at start read only what’s relevant.
  7) Контроль роста: при увеличении размера сначала выносите примеры/таблицы/FAQ, P0 оставляйте в первых 32 KiB. / Size gate: move examples/tables/FAQ out first; keep P0 within the first 32 KiB.
## Логирование обращений / Logging Requests

- **RU:** Определяй цель ведения логов (отладка, аудит, метрики) и фиксируй её в документации перед включением сбора.

  **EN:** Define the purpose of logging (debugging, audit, metrics) and document it before enabling collection.
- **RU:** Логирование считается включённым по умолчанию; отключение возможно только отдельной договорённостью, отражённой в `local/chat_context.md`.

  **EN:** Logging is enabled by default; turn it off only with an explicit agreement captured in `local/chat_context.md`.
- **RU:** Структура JSONL: `sessions.log` — `session_id`, `started_at`, `assistant`, `language`, `gender`, `logging_precision`; `requests.log` — `timestamp` (ISO 8601 UTC), `request_id`, `assistant`, `tools`, `status`, опционально `error_details`/`short_context`.

  **EN:** JSONL fields: `sessions.log` — `session_id`, `started_at`, `assistant`, `language`, `gender`, `logging_precision`; `requests.log` — `timestamp` (ISO 8601 UTC), `request_id`, `assistant`, `tools`, `status`, optional `error_details`/`short_context`.
- **RU:** После подтверждения рабочего языка и рода фиксируй старт сессии: создавай запись в журнале `local/<имя ассистента>/sessions.log` (или аналогичном файле) с уникальным идентификатором, временем начала, выбранным языком, родом и, при hand-off, полями `handoff_from`/`handoff_to`.

  **EN:** After confirming language and grammatical gender, capture the session start: write an entry to `local/<assistant-name>/sessions.log` (or equivalent) with a unique ID, start time, chosen language, gender, and `handoff_from`/`handoff_to` when passing work between assistants.
- **RU:** Если каталог `local/<имя ассистента>` или нужные файлы отсутствуют, создай их перед первой записью, сохраняя структуру репозитория.

  **EN:** If `local/<assistant-name>` or the required log files are missing, create them before the first entry while keeping the repository structure.
- **RU:** Если логирование активно, в первом ответе автоматически запроси явное разрешение на запись точных отметок времени или длительности обработки; при отказе веди только базовые журналы.

  **EN:** When logging is enabled, ask for explicit approval in the first reply before recording precise timestamps or processing durations; if refused, keep only baseline logs.
- **RU:** Для записи точных отметок времени отдельных запросов или длительности обработки получи подтверждение пользователя и зафиксируй его в `local/chat_context.md` перед расширением логов.

  **EN:** Before logging per-request timestamps or processing durations, capture the user’s approval and record it in `local/chat_context.md`.
- **RU:** Записи в `sessions.log` и `requests.log` веди в формате JSONL (одна запись на строку) с ISO 8601 UTC `timestamp`; добавляй поле `summary`/`short_context`, отражающее цель сессии или суть запроса.

  **EN:** Keep `sessions.log` and `requests.log` as JSONL (one entry per line) with ISO 8601 UTC timestamps; include a `summary`/`short_context` field capturing the session purpose or request intent.
- **RU:** При полученном согласии фиксируй КАЖДОЕ обращение к ассистенту в `local/<имя ассистента>/requests.log`: используй отметку времени в ISO 8601 (UTC), идентификатор или тип обращения, краткий контекст (1-2 фразы), пометку об инструментах и итоговый статус (`success`, `warning`, `error`). Придерживайся ASCII и не записывай чувствительные данные.

  **EN:** With consent, log EVERY interaction in `local/<assistant-name>/requests.log`: include an ISO 8601 UTC timestamp, interaction ID/type, a 1-2 sentence context, tools used, and a final status (`success`, `warning`, `error`). Stick to ASCII and omit sensitive data.
- **RU:** Используй таблицу ниже как шпаргалку по файлам и полям; при необходимости расширяй её проектными полями (`duration_ms`, `error_details_redacted` и т.п.), фиксируя изменения в `{{CHAT_CONTEXT_FILE}}`.

  **EN:** Use the table below as a cheat sheet for files and fields; extend it with project-specific columns (`duration_ms`, `error_details_redacted`, etc.) and record changes in `{{CHAT_CONTEXT_FILE}}`.

| Событие / Event | Файл / File | Обязательные поля / Required fields |
| --- | --- | --- |
| Старт сессии / Session start | `{{SESSIONS_LOG_PATH}}` | `timestamp`, `session_id`, `assistant`, `language`, `gender`, `logging_precision`, `summary` |
| Индивидуальный запрос / Individual request | `{{REQUESTS_LOG_PATH}}` | `timestamp`, `request_id`, `assistant`, `short_context`, `tools`, `status` |
| Ошибка / Error entry | `{{REQUESTS_LOG_PATH}}` | `timestamp`, `request_id`, `assistant`, `status=error`, `error_details` (без чувствительных данных) |

- **RU:** Логируй только необходимые поля: идентификатор запроса, тип ассистента, отметку времени и минимальный контекст; пользовательский ввод и ответы маскируй/анонимизируй, удаляя PII и секреты.

  **EN:** Capture only the required fields: request ID, assistant type, timestamp, and minimal context; mask or anonymize user inputs and responses, stripping PII and secrets.
- **RU:** Если CLI не умеет писать файлы (например, инструмент работает без доступа к домашнему каталогу), письменно зафиксируй невозможность в ответе пользователю и продолжай работу без локальных логов, пока не появится доступ.

  **EN:** When a CLI cannot write files (for example, the tool lacks home-directory access), note it explicitly in your reply and continue without local logs until access is granted.
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

## Синхронизация с апстримом / Upstream Sync

- **RU:** Сверяй `AGENTS.md`, `README*.md`, `CONTRIBUTING*.md`, `README_snippet.md`, `local/scripts/*` с эталоном `{{TEMPLATE_UPSTREAM_URL}}` с частотой `{{UPSTREAM_CHECK_FREQUENCY}}` или при значимых изменениях.

  **EN:** Compare `AGENTS.md`, `README*.md`, `CONTRIBUTING*.md`, `README_snippet.md`, `local/scripts/*` with the canonical `{{TEMPLATE_UPSTREAM_URL}}` every `{{UPSTREAM_CHECK_FREQUENCY}}` or after major updates.
- **RU:** Фиксируй расхождения и решения в `{{SESSION_HISTORY_FILE}}`, а итоговые договорённости — в `{{CHAT_CONTEXT_FILE}}`.

  **EN:** Record differences and decisions in `{{SESSION_HISTORY_FILE}}`, and capture resulting agreements in `{{CHAT_CONTEXT_FILE}}`.
- **RU:** При каждой сверке записывай ISO-время проверки, хэш текущего `AGENTS.md` и список проверенных файлов в `{{SESSION_HISTORY_FILE}}`; в ответах указывай дату/хэш проверки.

  **EN:** For each sync, log the ISO timestamp, current `AGENTS.md` hash, and checked files in `{{SESSION_HISTORY_FILE}}`; include the date/hash in user-facing replies.
- **RU:** Не перезаписывай локальные дополнения (`local/**`, `{{PROJECT_ADDENDA_FILE}}`, специфичные разделы README); вместо этого помечай их как локальные расширения.

  **EN:** Do not overwrite local addenda (`local/**`, `{{PROJECT_ADDENDA_FILE}}`, repo-specific README sections); mark them as local extensions instead.
- **RU:** При обновлении шаблона публикуй краткий отчёт (что подтянутo, какие шаги требуются) и договаривайся о внедрении с командой.

  **EN:** When syncing the template, share a brief report (what was pulled, required follow-ups) and align with the team on rollout.

**RU:** Соблюдение этих правил помогает поддерживать единый процесс и снижает риск регрессий.

**EN:** Following these rules keeps the workflow consistent and reduces the risk of regressions.
