# Ограничения окружения / Environment limits

## Оси / Core axes
- `sandbox_mode`: `read-only` | `workspace-write` | `danger-full-access`
- `network_access`: `restricted` | `enabled`
- `approval_policy`: `never` | `on-request` | `on-failure` | `untrusted`

## Дефолт для шаблона / Template default
- RU: Эксперименты и артефакты писать только в `tmp/ai/**`.
  EN: Write experiments/artifacts only under `tmp/ai/**`.

## Эскалация / Escalation
- RU: 1 предложение-обоснование + список команд (по строке) + ожидаемый результат.
  EN: 1-sentence justification + per-line command list + expected outcome.
- RU: Если требуется несколько команд/инструментов — согласуй единым запросом весь список команд (по строке), затем выполняй по порядку.
  EN: If multiple commands/tools are needed, align once on the full per-line command list, then execute sequentially.
- RU: Windows: перед любыми утверждениями “sudo не существует/не работает” ОБЯЗАТЕЛЬНО проверить факты командой `Get-Command sudo` и/или `sudo -h`. Запрещено спорить без проверки.
  EN: Windows: before claiming “sudo does not exist/does not work”, you MUST verify with `Get-Command sudo` and/or `sudo -h`. Arguing without checking is forbidden.
- RU: Windows: если `sudo` доступен, считать его основным механизмом эскалации (UAC prompt). Запрещено запускать `sudo` без явного запроса/согласия пользователя на повышение прав; факт эскалации зафиксировать в `local/ai/chat_context.md`.
  EN: Windows: if `sudo` is available, treat it as the primary elevation mechanism (UAC prompt). You MUST NOT run `sudo` unless the user explicitly requests/approves elevation; record the elevation event in `local/ai/chat_context.md`.
- RU: Справка: `https://learn.microsoft.com/en-us/windows/advanced-settings/sudo/`, `https://devblogs.microsoft.com/commandline/introducing-sudo-for-windows/`.
  EN: Reference: `https://learn.microsoft.com/en-us/windows/advanced-settings/sudo/`, `https://devblogs.microsoft.com/commandline/introducing-sudo-for-windows/`.

## Типовые ошибки / Common errors
- RU: `EACCES` — недостаточно прав/запрещена запись; согласуй эскалацию или измени подход (hardlink вместо symlink, другой каталог).
  EN: `EACCES` — insufficient permissions/write blocked; align on escalation or change the approach (hardlinks instead of symlinks, different directory).
- RU: `ECONNREFUSED` / `EAI_AGAIN` — сетевые ограничения/проблемы DNS; согласуй повтор и зафиксируй ограничения.
  EN: `ECONNREFUSED` / `EAI_AGAIN` — network/DNS issues; align on retry and record constraints.
- RU: `401/403` — проблема с токеном/правами; перепроверь источник токена с пользователем.
  EN: `401/403` — token/permissions issue; re-check token source with the user.

## Очистка / Cleanup
- RU: После работы удалить временные каталоги инструментов, созданные в `tmp/ai/**`.
  EN: After work, remove tool temp dirs created under `tmp/ai/**`.

## Инструменты и файлы вне репозитория / Tools writing outside the repo
- RU: Любое выполнение инструментов, создающих файлы вне рабочей директории (например, `~/.<tool>` или глобальные кеши), должно быть явно согласовано с пользователем (эскалация).
  EN: Any tool invocation that writes outside the workspace (for example, `~/.<tool>` or global caches) must be explicitly aligned with the user (escalation).
- RU: Если инструмент поддерживает `--data-dir` / `--config-dir` (или аналоги) — направлять их в `tmp/ai/**`, описывать процедуру очистки и фиксировать договорённость в `local/ai/chat_context.md`.
  EN: If the tool supports `--data-dir` / `--config-dir` (or equivalents), route them into `tmp/ai/**`, describe cleanup, and record the agreement in `local/ai/chat_context.md`.
- RU: Если для запуска нужны токены/ключи, не пытаться “угадывать” их расположение; спросить пользователя и действовать по `local/ai/project_addenda.md` (если есть).
  EN: If tokens/keys are required, do not guess their location; ask the user and follow `local/ai/project_addenda.md` if present.

## Шаблонные temp dirs / Template temp dirs
- RU: Если инструмент требует “домашний каталог”/кеш, направлять его в `tmp/ai/**` (пример: `tmp/ai/gemini_home`, `tmp/ai/qwen_home`, `tmp/ai/copilot_home`, `tmp/ai/claude_home`, `tmp/ai/cli_tokens`) и затем очищать.
  EN: If a tool needs a “home dir”/cache, route it under `tmp/ai/**` (example: `tmp/ai/gemini_home`, `tmp/ai/qwen_home`, `tmp/ai/copilot_home`, `tmp/ai/claude_home`, `tmp/ai/cli_tokens`) and clean up afterwards.

## Матрица поведения / Behavior matrix
- RU: `read-only` — только чтение, без записей/сети/установок/тестов с файловым выводом.
  EN: `read-only` — no writes, no network calls, no installs, no tests that write files.
- RU: `workspace-write` — писать только в репозиторий; долгие проверки/сеть/установки — по согласованию; без переписывания истории.
  EN: `workspace-write` — writes only in the repo; long checks/network/installs need alignment; no history rewrites.
- RU: `danger-full-access` — любые действия только после явного согласования; фиксировать шаги/риск/результат.
  EN: `danger-full-access` — any action requires explicit alignment; record steps/risk/outcome.

## Пример эскалации / Sample escalation
- Justification: Need to inspect tool configuration outside the workspace.
- Commands:
  - `<command 1>`
  - `<command 2>`
- Expected outcome: <what we learn / what changes>.
