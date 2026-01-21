# Подготовка CLI / CLI bootstrap
#
# RU: Минимальные правила безопасного запуска внешних CLI.
# EN: Minimal rules for safely running external CLIs.

## Перед первым использованием / Before first use
- RU: Всегда сначала выполнить `<tool> --help` и зафиксировать ключевые флаги/режимы в `local/ai/session_history.md`.
  EN: Always run `<tool> --help` first and record key flags/modes in `local/ai/session_history.md`.
- RU: Запросы CLI передавать одной строкой (как один аргумент) на языке пользователя; дополнительные параметры добавлять только после сверки со справкой и согласования с пользователем.
  EN: Pass CLI prompts as a single-line argument in the user’s language; add extra parameters only after checking `--help` and aligning with the user.
- RU: Если CLI падал/ломался — сохранить вывод и шаги восстановления в `local/ai/session_history.md`, чтобы не повторять проблему.
  EN: If a CLI crashed, capture output and recovery steps in `local/ai/session_history.md` so others don’t repeat it.
  - RU: Таймаут ожидания ответа CLI: до ~60 секунд; если `429`/rate limit — повторять только после таймаута или по явному согласию.
    EN: CLI wait timeout: up to ~60 seconds; if you hit `429`/rate limits, retry only after timeout or with explicit consent.

## Ключи/токены / Keys & tokens
- RU: Не угадывать переменные окружения/пути к токенам; спросить пользователя и следовать `local/ai/project_addenda.md` (если есть).
  EN: Do not guess env vars/paths for tokens; ask the user and follow `local/ai/project_addenda.md` if present.
- RU: Типовые переменные окружения (пример, не гарантия): `OPENAI_API_KEY`, `GEMINI_API_KEY`, `QWEN_API_KEY`, а также любые проектные ключи.
  EN: Typical env vars (examples, not guaranteed): `OPENAI_API_KEY`, `GEMINI_API_KEY`, `QWEN_API_KEY`, plus any project-specific keys.
- RU: Если инструмент хранит токены/конфиги вне репозитория — это должно быть явно согласовано и задокументировано в `local/ai/chat_context.md`.
  EN: If a tool stores tokens/config outside the repo, this must be explicitly aligned and documented in `local/ai/chat_context.md`.

## Временные каталоги / Temp directories
- RU: Если CLI умеет `--data-dir` / `--config-dir` (или аналоги) — направлять в `tmp/ai/**` и затем чистить (см. `local/ai/agents/03-sandbox.md`).
  EN: If a CLI supports `--data-dir` / `--config-dir` (or equivalents), route it under `tmp/ai/**` and clean up afterwards (see `local/ai/agents/03-sandbox.md`).

## Ограничения окружения / Environment constraints
- RU: При ограничениях sandbox/сети — явно попросить пользователя выполнить команду локально и зафиксировать это в `local/ai/chat_context.md`.
  EN: If sandbox/network constraints block execution, explicitly ask the user to run the command locally and record it in `local/ai/chat_context.md`.
