# Проектные дополнения / Project-Specific Addenda

> **Версия / Version:** <YYYY-MM-DD — заполните после первой настройки>

## 1. Контакты и ответственность / Contacts and Ownership
- **RU:** Владельцы файла: `<имя/роль>`, канал связи `<email|chat>`. Здесь же фиксируем дату последней ревизии, ответственного и причину изменений.  
- **EN:** Document owners: `<name/role>`, contact `<email|chat>`. Always record the last revision date, who edited it, and why.

## 2. Цели и область / Goals and Scope
- **RU:** Дополнения распространяются на всех локальных ассистентов (`gemini`, `qwen`, `codex`, `copilot`) и описывают долгосрочные договорённости: окружения, проверки, модели.  
- **EN:** These addenda apply to every local assistant (`gemini`, `qwen`, `codex`, `copilot`) and capture long-lived agreements: environments, checks, and model choices.

## 3. Окружение и ограничения / Environment and Constraints
- **RU:** Матрица окружений (добавьте строки по мере необходимости):  
  **EN:** Environment matrix (extend with additional rows as needed):

  | Environment / Окружение | Primary tasks / Основные задачи | Tooling / Инструменты | CLI policy / Политика CLI | Escalation notes / Примечания |
  | --- | --- | --- | --- | --- |
  | `<OS / shell>` | `<что делаем>` | `<bash/pwsh/git/...>` | `<когда можно запускать gemini/qwen/codex/copilot>` | `<что требует согласования, где писать>` |

- **RU:** Ассистент сам определяет активную среду (PowerShell, Bash, WSL и т.д.) и описывает переключения в ответах. Скрипты `local/ai/scripts/init.sh` / `.ps1` повторно не запускаем, если симлинки целы.  

  **EN:** The assistant detects the active environment automatically (PowerShell, Bash, WSL, etc.) and documents switches in the reply. Do not rerun `local/ai/scripts/init.*` if symlinks remain intact.
- **RU:** Симлинки `.github/copilot-instructions.md`, `.gemini/GEMINI.md`, `.qwen/QWEN.md`, `GEMINI.md`, `QWEN.md` всегда относительные; README RU/EN синхронизируем при изменениях.  
  **EN:** Keep `.github/copilot-instructions.md`, `.gemini/GEMINI.md`, `.qwen/QWEN.md`, `GEMINI.md`, `QWEN.md` as relative symlinks; keep RU/EN READMEs in sync.
- **RU:** Укажите разрешённые зоны записи (`<repo root>`, `tmp/ai/`, `build/`) и запретите системные каталоги (`~/.<tool>`, `/etc`, `%APPDATA%`) без разрешения. Скрипты инициализации создают `tmp/ai/`, если его нет.   
  **EN:** Define allowed write locations (`<repo root>`, `tmp/ai/`, `build/`) and forbid system paths (`~/.<tool>`, `/etc`, `%APPDATA%`) unless explicitly approved. Init scripts create `tmp/ai/` when missing.
- **RU:** При `sandbox_mode=read-only` любые записи (журналы, сводки) требуют согласованной эскалации (`with_escalated_permissions=true` + justification).  
  **EN:** When `sandbox_mode=read-only`, every write (logs, summaries) needs an approved escalation (`with_escalated_permissions=true` plus justification).
- **RU:** Разрешённые действия без подтверждения: чтение файлов, обновление `local/ai/chat_context.md`, `local/ai/session_history.md`, `local/ai/session_summaries/`, восстановление симлинков, запуск локальных скриптов без сети.  
  **EN:** Allowed without extra approval: reading files, updating the context/history/summary files, restoring symlinks, running offline scripts within the repo.
- **RU:** Требуют отдельного согласия: операции вне репозитория, сетевой доступ, запуск CLI ассистентов, изменение приватных конфигов, удаление файлов, правка `.git/info/exclude`, переписывание истории Git.  
  **EN:** Require approval: actions outside the repo, network access, invoking assistant CLIs, editing private configs, deleting files, changing `.git/info/exclude`, rewriting Git history.
- **RU:** Если токены лежат в `~/.<tool>`, согласуйте временный `tmp/ai/cli_tokens/`, добавьте в `.git/info/exclude`, опишите очистку.  
  **EN:** When tokens live in `~/.<tool>`, agree on a temporary `tmp/ai/cli_tokens/`, add it to `.git/info/exclude`, and document the cleanup plan.

## 4. Инструменты и проверки / Tooling and Checks
- **RU:** Перед первым запуском CLI выполняем `<tool> --help`, фиксируем наблюдения в `local/ai/session_history.md`.  

  **EN:** Run `<tool> --help` before the first CLI invocation and log observations in `local/ai/session_history.md`.
- **RU:** Логи (`local/ai/<assistant>/sessions.log`, `local/ai/<assistant>/requests.log`) ведём в формате JSONL, timestamp = ISO 8601 UTC (`YYYY-MM-DDTHH:MM:SSZ`), минимальные поля: `timestamp`, `request_id`, `assistant`, `summary`, `tools`, `status`.  

  **EN:** Maintain JSONL logs with ISO 8601 UTC timestamps and the fields `timestamp`, `request_id`, `assistant`, `summary`, `tools`, `status`.
- **RU:** После консультаций (`codex exec --json`, `gemini`, `qwen`, `copilot`) прогоняем логи через `<consult_trim_script>`, складываем результаты в `tmp/ai/assistant_contexts/logs/<cli>/` и вложения в `tmp/ai/assistant_contexts/attachments/<cli>/`. Ссылки добавляем в ответы и `local/ai/session_history.md`.  

  **EN:** Post-process consultations via `<consult_trim_script>`, storing outputs under `tmp/ai/assistant_contexts/logs/<cli>/` and attachments under `tmp/ai/assistant_contexts/attachments/<cli>/`; reference them in replies and `local/ai/session_history.md`.
- **RU:** При отсутствии Python или необходимых зависимостей используем fallback: текстовый отчёт в `tmp/ai/assistant_contexts/text/<cli>/<ISO8601>.txt` и пометка в истории.  

  **EN:** If Python or required dependencies are unavailable, fall back to plain-text reports in `tmp/ai/assistant_contexts/text/<cli>/<ISO8601>.txt` and note the limitation in the history.
- **RU:** Обязательные проверки перед релизами (`{{MANDATORY_CHECKS}}`) опишите здесь: например, `./local/ai/scripts/bootstrap_check.sh`, `bash -n <script>`, `shellcheck -x <script>`, `<project linters/tests>`.  

  **EN:** List mandatory pre-release checks (`{{MANDATORY_CHECKS}}`) such as `./local/ai/scripts/bootstrap_check.sh`, `bash -n <script>`, `shellcheck -x <script>`, `<project linters/tests>`.

## 5. Модели ассистентов / Assistant Models
- **RU:** `gemini`: `<основная модель>`; fallback `<альтернатива>`.  
  **EN:** `gemini`: `<primary model>`; fallback `<alternative>`.
- **RU:** `qwen`: `<модель для инструкций>`, `<модель для кода>`.  
  **EN:** `qwen`: `<instructions model>`, `<coding model>`.
- **RU:** `codex`: `<model for edits>`, `<model for consultations>`.  
  **EN:** `codex`: `<model for edits>`, `<model for consultations>`.
- **RU:** `copilot`: перечислите поддерживаемые модели и сценарии.  
  **EN:** `copilot`: list supported models and scenarios.

## 6. Дополнительные процессы / Additional Processes
- **RU:** Перед каждой сессией подтверждаем bootstrap (README-комментарий, симлинки, `.git/info/exclude`, логи). Отклонения записываем в `local/ai/session_history.md`.  

  **EN:** At every session start, confirm bootstrap (README snippet, symlinks, `.git/info/exclude`, logs) and document deviations in `local/ai/session_history.md`.
- **RU:** После чтения `local/ai/chat_context.md`/`local/ai/project_addenda.md` собираем открытые вопросы из `local/ai/session_summaries/` (при необходимости используем `<collect_open_items_script>`) и включаем их в первое сообщение.  

  **EN:** After reading `local/ai/chat_context.md`/`local/ai/project_addenda.md`, collect open items from `local/ai/session_summaries/` (via `<collect_open_items_script>` if desired) and include them in the first reply.
- **RU:** Новые договорённости сначала фиксируем в `local/ai/session_history.md`, затем обновляем `local/ai/chat_context.md`/`local/ai/project_addenda.md`.  
  **EN:** Log new agreements in `local/ai/session_history.md` before updating `local/ai/chat_context.md`/`local/ai/project_addenda.md`.
- **RU:** При завершении работы формируем `local/ai/session_summaries/<ISO8601>.md` со структурой: «Контекст», «Системные указания», «Ключевые файлы» (`path:line + note`), «Последние события» (команда → результат), «Проблемы и решения», «Рекомендации / Следующие шаги» (чек-лист), «Дополнительные материалы», «Открытые вопросы».  
  **EN:** When closing a session create `local/ai/session_summaries/<ISO8601>.md` with “Context,” “System directives,” “Key files” (`path:line + note`), “Recent events” (command → outcome), “Issues & fixes,” “Recommendations / Next steps” (checklist), “Additional materials,” and “Open questions.”
- **RU:** Временные каталоги CLI (`tmp/ai/gemini_home`, `tmp/ai/qwen_home`, `tmp/ai/copilot_home`, `tmp/ai/cli_tokens`) описываем в ответе и очищаем после подтверждения пользователя.  
  **EN:** Document temporary CLI directories (`tmp/ai/gemini_home`, `tmp/ai/qwen_home`, `tmp/ai/copilot_home`, `tmp/ai/cli_tokens`) in replies and remove them once the user confirms.

## 7. Источники и ссылки / References
- **RU:** Перечислите внутренние документы (например, `docs/`, runbooks) и внешние руководства.  
  **EN:** List internal documents (e.g., `docs/`, runbooks) and external references.
- **RU:** Обновляйте этот файл не реже `<период>` и фиксируйте изменения в `local/ai/session_history.md`.  
  **EN:** Review this file at least every `<cadence>` and log changes in `local/ai/session_history.md`.

## 8. Требования к README / README Requirements
- **RU:** `README.md` и `README.en.md` содержат скрытый HTML-комментарий из [README_snippet.md](README_snippet.md) в верхней части файла; при копировании шаблона проверяйте его присутствие.  
  **EN:** `README.md` and `README.en.md` must include the hidden HTML comment from [README_snippet.md](README_snippet.md) at the top; confirm it after copying the template.



