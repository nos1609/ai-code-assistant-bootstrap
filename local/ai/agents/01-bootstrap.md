# Быстрый старт / Bootstrap (template integration)
#
# RU: Короткий чек-лист для интеграции шаблона. Длинные инструкции вынесены из
#     корневого `AGENTS.md` из-за лимита Codex (~32 KiB).
# EN: Short checklist for integrating the template. Long instructions were moved
#     out of the root `AGENTS.md` due to Codex (~32 KiB) limits.

## Сигнал и ускоренный старт / Trigger & accelerated start
- RU: Если есть `AGENTS.md` и `local/ai/chat_context.md` — выполнить порядок чтения из `AGENTS.md` (раздел “Reading order”).
  EN: If `AGENTS.md` and `local/ai/chat_context.md` exist, follow the reading order in `AGENTS.md` (“Reading order” section).
- RU: Если `local/ai/bootstrap.ready` начинается с `true` и в `local/ai/chat_context.md` статус `completed` — bootstrap не запускать повторно; коротко подтвердить пропуск.
  EN: If `local/ai/bootstrap.ready` starts with `true` and `local/ai/chat_context.md` says `completed`, do not re-run bootstrap; briefly confirm you are skipping it.
- RU: При пропуске bootstrap убедиться, что `last_verified_at` и `agents_md_hash` в chat context актуальны; иначе — перепроверить bootstrap.
  EN: When skipping bootstrap, ensure `last_verified_at` and `agents_md_hash` in chat context are up to date; otherwise re-run bootstrap checks.

## Предполетный чек-лист / Pre-flight checklist
- [ ] RU: Прочитать `local/ai/chat_context.md` (источник истины по договорённостям).
      EN: Read `local/ai/chat_context.md` (source of truth for agreements).
- [ ] RU: Подтвердить ключевые договорённости из `local/ai/chat_context.md`.
      EN: Acknowledge key agreements from `local/ai/chat_context.md`.
- [ ] RU: Прочитать `local/ai/project_addenda.md` (если есть) и учесть указания.
      EN: Read `local/ai/project_addenda.md` if present and follow guidance.
- [ ] RU: Если в репозитории уже есть дополнительные инструкции (например, `README.md`, `README.en.md`) — прочитать и учесть.
      EN: If the repo already has extra instructions (for example, `README.md`, `README.en.md`), read and follow them.
- [ ] RU: Проверить, git-репозиторий ли это (наличие `.git/info/exclude`).
      EN: Confirm whether this is a git repo (so `.git/info/exclude` exists).
- [ ] RU: Уточнить, куда разрешено писать. Без явного разрешения писать только в `tmp/ai/**` (и только для артефактов/экспериментов).
      EN: Confirm where writes are allowed. Without explicit permission, write only under `tmp/ai/**` (artifacts/experiments only).
- [ ] RU: Поприветствовать пользователя и уточнить задачу, не переспрашивая уже зафиксированное.
      EN: Greet the user and clarify the task without re-asking what is already fixed.

## Быстрый старт / Quick start steps
- RU: Отмечать пункты только после явного согласия пользователя; озвучивать, какой шаг подтверждён.
  EN: Tick items only after the user explicitly agrees; state which step you are confirming.

- [ ] Step 1:
  - RU: Перечитать `local/ai/chat_context.md`; проверить `status`, `last_verified_at`, `agents_md_hash`.
  - EN: Re-read `local/ai/chat_context.md`; verify `status`, `last_verified_at`, `agents_md_hash`.
  - RU: В ответе указать дату/время последнего чтения `local/ai/chat_context.md`.
    EN: In the reply, state when `local/ai/chat_context.md` was last reviewed.
  - RU: Проверить, что язык зафиксирован; после интеграции внутренние файлы вести только на выбранном пользователем языке (см. `local/ai/agents/12-general.md`).
  - EN: Confirm the language is set; after integration, write internal files only in the user-selected language (see `local/ai/agents/12-general.md`).
- [ ] Step 1a:
  - RU: Запустить `local/ai/scripts/bootstrap_check.ps1` (или `local/ai/scripts/bootstrap_check.sh`).
  - EN: Run `local/ai/scripts/bootstrap_check.ps1` (or `local/ai/scripts/bootstrap_check.sh`).
- [ ] Step 1b (pre‑reply logging):
  - RU: Перед КАЖДЫМ ответом: сначала записать запрос в `requests.log`, затем отвечать.
  - EN: Before EVERY reply: log the request in `requests.log` first, then respond.
  - RU: Если запись не создана — остановиться и залогировать сначала.
  - EN: If the entry does not exist, stop and log first.
- RU: Если bootstrap_check недоступен — перечислить ручные проверки: README сниппет, instruction files/symlinks, `.git/info/exclude`, логи.
  EN: If bootstrap_check is unavailable, list the equivalent manual checks: README snippet, instruction files/symlinks, `.git/info/exclude`, logs.
- RU: При интеграции/обновлении шаблона проверить, что `.git/info/exclude` соответствует блоку `.gitignore` `BEGIN/END EXCLUDE LIST`.
  EN: When integrating/updating the template, verify `.git/info/exclude` matches the `.gitignore` `BEGIN/END EXCLUDE LIST` block.
- [ ] Step 2 (README rule):
  - RU: Следовать P0 правилу из `AGENTS.md`: при переносе/обновлении шаблона запрещено изменять `README.md` / `README.en.md` любым образом, кроме добавления точного скрытого сниппета из `README_snippet.md` в самое начало (если политика разрешает).
  - EN: Follow the P0 rule in `AGENTS.md`: when applying/updating the template, DO NOT modify `README.md` / `README.en.md` in any way except inserting the exact hidden snippet from `README_snippet.md` at the very top (if policy allows).
  - RU: Если README нет — создать минимальный README и вставить сниппет (не копировать шаблонный текст).
  - EN: If no README, create a minimal README and insert the snippet (do not copy template text).
- [ ] Step 3 (instruction links):
  - RU: Убедиться, что ссылки/файлы инструкций указывают на `AGENTS.md`.
  - EN: Ensure instruction links/files point to `AGENTS.md`.
  - `local/ai/agents/06-instructions.md` (список обязательных файлов).
  - RU: Windows: симлинки могут требовать Admin/Developer Mode; если симлинки недоступны — использовать hardlink (без копирования, чтобы не было дрейфа).
  - EN: Windows: symlinks require Admin/Developer Mode; if symlinks are unavailable, use hardlinks (no copies to avoid drift).
- [ ] Step 4 (exclude):
  - RU: Скопировать строки блока `.gitignore` `BEGIN/END EXCLUDE LIST` в `.git/info/exclude`.
  - EN: Copy `.gitignore` `BEGIN/END EXCLUDE LIST` entries into `.git/info/exclude`.
- [ ] Step 5 (logs):
  - RU: Проверить `local/ai/<assistant>/{sessions.log,requests.log}` (JSONL, ISO8601Z).
  - EN: Ensure `local/ai/<assistant>/{sessions.log,requests.log}` exist (JSONL, ISO8601Z).
  - RU: Для `gemini`, `qwen`, `codex`, `copilot`, `claude` — если каталогов/файлов логов нет, создать их до первой записи.
    EN: For `gemini`, `qwen`, `codex`, `copilot`, `claude`, create log directories/files before the first write if missing.
- [ ] Step 6 (record):
  - RU: Зафиксировать итоги в `local/ai/session_history.md`.
  - EN: Record key outcomes in `local/ai/session_history.md`.

- [ ] Step 7 (README check):
  - RU: Если есть `README.md` / `README.en.md` — прочитать их на предмет repo-specific ограничений/инструкций (это дополняет, но не переопределяет `local/ai/chat_context.md`).
  - EN: If `README.md` / `README.en.md` exist, read them for repo-specific constraints/instructions (this complements but does not override `local/ai/chat_context.md`).

- [ ] Step 8 (cleanup):
  - RU: Если создавались временные каталоги инструментов — удалить их (см. `local/ai/agents/03-sandbox.md`).
  - EN: If any tool temp dirs were created, remove them (see `local/ai/agents/03-sandbox.md`).

## Первичная настройка репозитория / Repository bootstrap (template artifacts)
- RU: Проверить правило README (см. Step 2 выше).
  EN: Confirm the README rule (see Step 2 above).
- RU: Создать/обновить файлы инструкций ассистентов так, чтобы они указывали на `AGENTS.md` (см. `local/ai/agents/06-instructions.md`).
  EN: Create/refresh assistant instruction files so they point to `AGENTS.md` (see `local/ai/agents/06-instructions.md`).
- RU: Убедиться, что `.git/info/exclude` скрывает артефакты шаблона, но не скрывает весь `.github/`.
  EN: Ensure `.git/info/exclude` hides template artifacts but does not ignore the entire `.github/` directory.
  - RU: Причина: `.github/workflows/*` должны оставаться в репозитории, иначе GitHub Actions перестанут работать.
    EN: Reason: `.github/workflows/*` must remain tracked, otherwise GitHub Actions will stop working.
- RU: Скопировать строки из `.gitignore` блока `BEGIN/END EXCLUDE LIST` в `.git/info/exclude` (убрав префикс `# `).
  EN: Copy `.gitignore` `BEGIN/END EXCLUDE LIST` entries into `.git/info/exclude` (remove the leading `# `).
- RU: После завершения — обновить `local/ai/chat_context.md`, зафиксировав выполненные шаги.
  EN: After bootstrap, update `local/ai/chat_context.md` to document what was done.
