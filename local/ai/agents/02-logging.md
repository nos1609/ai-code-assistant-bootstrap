# Логирование / Logging

## Правила / Rules
- RU: Формат JSONL (1 событие = 1 строка).
  EN: JSONL format (1 event = 1 line).
- RU: Таймстемпы: ISO 8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`).
  EN: Timestamps: ISO 8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`).
- RU: Назначение: audit + context replay. Секреты не логировать.
  EN: Purpose: audit + context replay. Do not log secrets.

## Пути / Paths
- `local/ai/<assistant>/sessions.log`
- `local/ai/<assistant>/requests.log`

## Минимальные поля / Minimal fields
- `sessions.log`: `timestamp`, `session_id`, `assistant`, `summary`, `status`
- `requests.log`: `timestamp`, `request_id`, `assistant`, `short_context`, `tools`, `status`

## Примечания / Notes
- RU: В шаблоне допустимы плейсхолдеры; в реальных сессиях пишем реальные таймстемпы.
  EN: Placeholders are OK in the template; real sessions must write real timestamps.

## Логирование обращений / Logging Requests
- **RU:** Определяй цель ведения логов (отладка, аудит, метрики) и фиксируй её в документации перед включением сбора.
  **EN:** Define the purpose of logging (debugging, audit, metrics) and document it before enabling collection.
- **RU:** Логирование считается включённым по умолчанию; отключение возможно только отдельной договорённостью, отражённой в `local/ai/chat_context.md`.
  **EN:** Logging is enabled by default; turn it off only with an explicit agreement captured in `local/ai/chat_context.md`.
- **RU:** Структура JSONL: `sessions.log` — `session_id`, `started_at`, `assistant`, `language`, `gender`, `logging_precision`; `requests.log` — `timestamp` (ISO 8601 UTC), `request_id`, `assistant`, `tools`, `status`, опционально `error_details`/`short_context`.
  **EN:** JSONL fields: `sessions.log` — `session_id`, `started_at`, `assistant`, `language`, `gender`, `logging_precision`; `requests.log` — `timestamp` (ISO 8601 UTC), `request_id`, `assistant`, `tools`, `status`, optional `error_details`/`short_context`.
- **RU:** `started_at` допускается хранить как `timestamp` старта сессии (одно и то же значение, ISO 8601 UTC).
  **EN:** You may store `started_at` as the session-start `timestamp` (same value, ISO 8601 UTC).
- **RU:** `local/ai/project_addenda.md` можно использовать как мастер-шаблон: матрица окружений (ОС/права/инструменты), разрешённые/запрещённые действия, детализация логов и места хранения токенов/CLI-настроек.
  **EN:** You may use `local/ai/project_addenda.md` as a “master template”: environment matrix (OS/permissions/tools), allowed/disallowed actions, logging detail level, and token/tool config locations.
- **RU:** После подтверждения рабочего языка и рода фиксируй старт сессии: создавай запись в журнале `local/ai/<имя ассистента>/sessions.log` (или аналогичном файле) с уникальным идентификатором, временем начала, выбранным языком, родом и, при hand-off, полями `handoff_from`/`handoff_to`.
  **EN:** After confirming language and grammatical gender, capture the session start: write an entry to `local/ai/<assistant-name>/sessions.log` (or equivalent) with a unique ID, start time, chosen language, gender, and `handoff_from`/`handoff_to` when passing work between assistants.
- **RU:** Если каталог `local/ai/<имя ассистента>` или нужные файлы отсутствуют, создай их перед первой записью, сохраняя структуру репозитория.
  **EN:** If `local/ai/<assistant-name>` or the required log files are missing, create them before the first entry while keeping the repository structure.
- **RU:** Если логирование активно, в первом ответе автоматически запроси явное разрешение на запись точных отметок времени или длительности обработки; при отказе веди только базовые журналы.
  **EN:** When logging is enabled, ask for explicit approval in the first reply before recording precise timestamps or processing durations; if refused, keep only baseline logs.
- **RU:** Для записи точных отметок времени отдельных запросов или длительности обработки получи подтверждение пользователя и зафиксируй его в `local/ai/chat_context.md` перед расширением логов.
  **EN:** Before logging per-request timestamps or processing durations, capture the user’s approval and record it in `local/ai/chat_context.md`.
- **RU:** Записи в `sessions.log` и `requests.log` веди в формате JSONL (одна запись на строку) с ISO 8601 UTC `timestamp`; добавляй поле `summary`/`short_context`, отражающее цель сессии или суть запроса.
  **EN:** Keep `sessions.log` and `requests.log` as JSONL (one entry per line) with ISO 8601 UTC timestamps; include a `summary`/`short_context` field capturing the session purpose or request intent.
- **RU:** При полученном согласии фиксируй КАЖДОЕ обращение к ассистенту в `local/ai/<имя ассистента>/requests.log`: используй отметку времени в ISO 8601 (UTC), идентификатор или тип обращения, краткий контекст (1-2 фразы), пометку об инструментах и итоговый статус (`success`, `warning`, `error`). Придерживайся ASCII и не записывай чувствительные данные.
  **EN:** With consent, log EVERY interaction in `local/ai/<assistant-name>/requests.log`: include an ISO 8601 UTC timestamp, interaction ID/type, a 1-2 sentence context, tools used, and a final status (`success`, `warning`, `error`). Stick to ASCII and omit sensitive data.
- **RU:** Используй таблицу ниже как шпаргалку по файлам и полям; при необходимости расширяй её проектными полями (`duration_ms`, `error_details_redacted` и т.п.), фиксируя изменения в `local/ai/chat_context.md`.
  **EN:** Use the table below as a cheat sheet for files and fields; extend it with project-specific columns (`duration_ms`, `error_details_redacted`, etc.) and record changes in `local/ai/chat_context.md`.

| Событие / Event | Файл / File | Обязательные поля / Required fields |
| --- | --- | --- |
| Старт сессии / Session start | `local/ai/<assistant>/sessions.log` | `timestamp`, `session_id`, `assistant`, `language`, `gender`, `logging_precision`, `summary` |
| Индивидуальный запрос / Individual request | `local/ai/<assistant>/requests.log` | `timestamp`, `request_id`, `assistant`, `short_context`, `tools`, `status` |
| Ошибка / Error entry | `local/ai/<assistant>/requests.log` | `timestamp`, `request_id`, `assistant`, `status=error`, `error_details` (без чувствительных данных) |

- **RU:** Логируй только необходимые поля: идентификатор запроса, тип ассистента, отметку времени и минимальный контекст; пользовательский ввод и ответы маскируй/анонимизируй, удаляя PII и секреты.
  **EN:** Capture only the required fields: request ID, assistant type, timestamp, and minimal context; mask or anonymize user inputs and responses, stripping PII and secrets.
- **RU:** Если CLI не умеет писать файлы (например, инструмент работает без доступа к домашнему каталогу), письменно зафиксируй невозможность в ответе пользователю и продолжай работу без локальных логов, пока не появится доступ.
  **EN:** When a CLI cannot write files (for example, the tool lacks home-directory access), note it explicitly in your reply and continue without local logs until access is granted.
- **RU:** Храни журналы в подпапке `local/ai/<имя ассистента>` или во внешнем хранилище с ограниченным доступом; фиксируй формат и расположение в локальных инструкциях.
  **EN:** Store logs under `local/ai/<assistant-name>` or in restricted external storage; document the format and location in the local guidelines.
- **RU:** Устанавливай сроки хранения и процессы ротации, обеспечивай возможность удаления записей по запросу пользователя.
  **EN:** Define retention periods and rotation processes, and keep a path to delete entries on user request.
- **RU:** Перед анализом логов убеждайся, что обработка чувствительных данных соответствует политике безопасности и действующим законам.
  **EN:** Before analyzing logs, ensure handling of sensitive data complies with the security policy and applicable regulations.
- **RU:** Если обращаешься к другому ассистенту, требуй, чтобы он вёл свои журналы (`local/ai/<имя>/requests.log`, `sessions.log`) по тем же правилам и подтверждай, что записи созданы.
  **EN:** When you call another assistant, ensure they keep their own logs (`local/ai/<name>/requests.log`, `sessions.log`) under the same rules and confirm the entries exist.
- **RU:** Перед отправкой ответа убедись, что текущий запрос уже записан в `local/ai/<имя ассистента>/requests.log`; если записи нет, добавь её отдельной командой немедленно.
  **EN:** Before sending a reply, make sure the current interaction is already stored in `local/ai/<assistant-name>/requests.log`; if it is missing, append it immediately using a dedicated command.
- **RU:** **ВАЖНО:** Команды логирования (например, `echo '...' >> .../requests.log`) выполняй отдельным вызовом `run_shell_command`; остальные команды запускай только после согласования.
  **EN:** **IMPORTANT:** Execute logging commands (e.g., `echo '...' >> .../requests.log`) in a separate `run_shell_command`; run all other commands only after approval.
