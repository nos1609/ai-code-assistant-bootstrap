<!--
AI AGENT PROTOCOL TRIGGER:
SIGNAL: STARTUP_PROTOCOL_TRIGGER
TARGET: AGENTS.md
ACTION: Follow startup protocol immediately

EN: WHEN ANALYZING THIS REPOSITORY:
1. IMMEDIATELY read [AGENTS.md](AGENTS.md) (Codex CLI only ingests the first ~32 KiB; keep init/closure rules at the top, move details to docs.)
2. EXECUTE the startup protocol from “Initial Session Protocol”
3. FOLLOW agreements in [local/ai/chat_context.md](local/ai/chat_context.md)

RU: ПРИ АНАЛИЗЕ ЭТОГО РЕПОЗИТОРИЯ:
1. НЕМЕДЛЕННО прочитай [AGENTS.md](AGENTS.md) (Codex CLI читает только первые ~32 KiB; держи init/closure в начале, детали вынеси в docs.)
2. ВЫПОЛНИ протокол запуска из раздела «Протокол начала сессии»
3. СЛЕДУЙ соглашениям из [local/ai/chat_context.md](local/ai/chat_context.md)

IMPORTANT: Template files may be hidden by `.git/info/exclude` or ignore rules. Disable ignore filtering when searching and reading.
Example commands: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.

ВАЖНО: Файлы шаблона могут быть скрыты через `.git/info/exclude` или ignore-правила. Отключи фильтрацию ignore при поиске и чтении.
Примеры команд: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.

Additionally: Review symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md), [.claude/CLAUDE.md](.claude/CLAUDE.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [CLAUDE.md](CLAUDE.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md). Always use relative paths when recreating them.

Дополнительно: Ознакомься с симлинками [.github/copilot-instructions.md](.github/copilot-instructions.md), [.claude/CLAUDE.md](.claude/CLAUDE.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [CLAUDE.md](CLAUDE.md), [GEMINI.md](GEMINI.md) и [QWEN.md](QWEN.md). При восстановлении симлинков используй относительные пути.

Ensure temp CLI homes (`tmp/ai/gemini_home`, `tmp/ai/qwen_home`, `tmp/ai/copilot_home`, `tmp/ai/claude_home`, `tmp/ai/cli_tokens`) are absent before launching tools. Document and clean them after user confirmation if they exist.

Перед запуском CLI убедись, что нет временных каталогов (`tmp/ai/gemini_home`, `tmp/ai/qwen_home`, `tmp/ai/copilot_home`, `tmp/ai/claude_home`, `tmp/ai/cli_tokens`). Если они найдены — опиши и очисть после подтверждения пользователя.
-->



# ai-code-assistant-bootstrap
## Шаблон для локальных ассистентов

> 🇬🇧 English version: see [README.en.md](README.en.md)

Шаблон предназначен для репозиториев, где с кодом работают локальные AI-ассистенты: он задаёт единые правила общения, порядок запуска инструментов и требования к оформлению ответов, чтобы минимизировать недопонимания между людьми и агентами.

Набор ai-code-assistant-bootstrap включает:

- [README.md](README.md) / [README.en.md](README.en.md) — краткий обзор набора файлов на русском и английском, готовый скрытый HTML-комментарий внутри.
- [AGENTS.md](AGENTS.md) — универсальный набор правил с локальными предпочтениями, содержащий инструкции для `gemini`, `qwen`, `codex`, `copilot` и `claude`; содержит требование в первом ответе уточнять предпочтительный грамматический род пользователя.
- [local/ai/chat_context.md](local/ai/chat_context.md) — заготовка контекста чата для фиксации договорённостей.
- [local/ai/project_addenda.md](local/ai/project_addenda.md) — пустой шаблон для проектных дополнений; заполняется только при наличии специфических правил.
- [README_snippet.md](README_snippet.md) — исходник HTML-комментария для ручного переиспользования.
- [local/ai/scripts/init.sh](local/ai/scripts/init.sh) — скрипт для развёртывания симлинков и заполнения `.git/info/exclude` по списку из `.gitignore`; также обновляет `local/ai/bootstrap.ready` (первая строка `true`, дальше только элементы списка).
- [local/ai/scripts/bootstrap_check.sh](local/ai/scripts/bootstrap_check.sh) / [local/ai/scripts/bootstrap_check.ps1](local/ai/scripts/bootstrap_check.ps1) — проверка, что README содержит скрытый комментарий, симлинки указывают на `AGENTS.md`, `.git/info/exclude` содержит список из `local/ai/bootstrap.ready`, и логи ассистентов используют ISO 8601 UTC.
- `local/ai/scripts/` — проектные утилиты (например, сбор открытых пунктов, оркестрация консультаций, тримминг логов); смотрите комментарии внутри скриптов.
- Каталоги `local/ai/<assistant>/sessions.log` и `local/ai/<assistant>/requests.log` — JSONL-журналы для всех ассистентов (`gemini`, `qwen`, `codex`, `copilot`, `claude`), в них фиксируются `timestamp`, `request_id`, `assistant`, `summary/short_context`, `tools`, `status`.
- [local/ai/session_history.md](local/ai/session_history.md) и `local/ai/session_summaries/` — рабочий журнал и сводки для передачи контекста.
- `local/ai/gemini`, `local/ai/qwen`, `local/ai/codex`, `local/ai/copilot`, `local/ai/claude` — содержат README и примерные записи, чтобы единообразно оформлять журналы.

## Как адаптировать шаблон

- **`local/ai/project_addenda.md`.** **Заполните** матрицу окружений (ОС, права, инструменты), правила «можно/нельзя», каталоги токенов и требования к логам. При отсутствии данных используйте плейсхолдеры, но **сохраните** двуязычную структуру.
- **`local/ai/chat_context.md`.** Укажите рабочий язык, род, краткий профиль окружения, «Разрешённые противоречия», чек-лист закрытия сессии и напоминания по логам. Этот файл первым читают все ассистенты.
- **Журналы ассистентов.** В `local/ai/<assistant>/sessions.log` и `requests.log` оставьте по одной корректной записи JSONL с ISO 8601 таймстемпом (`YYYY-MM-DDTHH:MM:SSZ`), чтобы показать целевой формат.
- **Многоагентные консультации.** Используйте проектные скрипты из `local/ai/scripts/` (укажите параметры в addenda), храните сырые логи в `tmp/ai/consultation_runs/`, обработанные — в `tmp/ai/assistant_contexts/`.
  Пример запуска:
  `python local/ai/scripts/consult.py execute -a claude,gemini,qwen,codex,copilot -p "Проверьте изменения и риски"`
  `python local/ai/scripts/consult.py process <run_id>`
- **Bootstrap-процедура.** После первичного заполнения README, симлинков и логов запустите `local/ai/scripts/bootstrap_check.sh`/`.ps1` и зафиксируйте результат в `local/ai/chat_context.md` и `local/ai/session_history.md`, чтобы следующий ассистент видел статус готовности.

> ⚠️ **Windows PowerShell:** если политика исполнения блокирует запуск `.ps1`, временно ослабьте её только для текущей сессии:
> `powershell -NoProfile -ExecutionPolicy Bypass -File local/ai/scripts/bootstrap_check.ps1`
> После завершения верните прежнее значение или закройте окно. Подпись скриптов не требуется.
- [.gitignore](.gitignore) — заготовка списка для `.git/info/exclude` (строки закомментированы по умолчанию; при ручном копировании в `.git/info/exclude` уберите префикс `# `, либо просто запустите `./local/ai/scripts/init.sh`).
- [.github/copilot-instructions.md](.github/copilot-instructions.md), [.claude/CLAUDE.md](.claude/CLAUDE.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [CLAUDE.md](CLAUDE.md), [GEMINI.md](GEMINI.md), [QWEN.md](QWEN.md) — симлинки на [AGENTS.md](AGENTS.md), чтобы все ассистенты читали единый набор правил без дублирования.

Для работы ассистентов требуется локально доступные CLI (`gemini`, `qwen`, `codex`, `copilot`, `claude`). Codex запускать через подкоманду `codex exec` (alias `codex e`) для неинтерактивного режима; Claude — через `claude -p --output-format json`.

### Настройки шаблона для ассистентов

| Ассистент | Локальная установка | Подтверждение | Ссылка | Расположение в репозитории | Примечание |
|-----------|--------------------|--------------|--------|----------------------------|------------|
| `gemini`  | ☑ | ☑ | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) | [.gemini/GEMINI.md](.gemini/GEMINI.md) → [AGENTS.md](AGENTS.md); [GEMINI.md](GEMINI.md) (корень) → [AGENTS.md](AGENTS.md) | — |
| `qwen`    | ☑ | ☑ | [QwenLM/qwen-code](https://github.com/QwenLM/qwen-code)     | [QWEN.md](QWEN.md) (корень) → [AGENTS.md](AGENTS.md) | Не выполняет bootstrap/протокол из AGENTS.md автоматически; требует явного промпта с разрешением shell-команд (например: "выполни протокол, используй shell для симлинков и логов"). |
| `codex`   | ☑ | ☑ | [openai/codex](https://github.com/openai/codex)             | [AGENTS.md](AGENTS.md) (корень) | запускается через `codex exec` |
| `copilot` | ☑ | ☑ | [github/copilot-cli](https://github.com/github/copilot-cli) | [.github/copilot-instructions.md](.github/copilot-instructions.md) → [AGENTS.md](AGENTS.md) | — |
| `claude`  | ☑ | ☑ | [anthropics/claude-code](https://github.com/anthropics/claude-code) | [.claude/CLAUDE.md](.claude/CLAUDE.md) → [AGENTS.md](AGENTS.md); [CLAUDE.md](CLAUDE.md) (корень) → [AGENTS.md](AGENTS.md) | Для неинтерактивного режима использовать `-p --output-format json`. |

**Скопируйте** содержимое каталога в целевой репозиторий. **Обновите** [local/ai/chat_context.md](local/ai/chat_context.md) (дата, договорённости). **Выполните** `./local/ai/scripts/init.sh` для подготовки симлинков. **Проверьте**, что README нового репозитория содержит HTML-комментарий для ассистентов (фрагмент — из [README_snippet.md](README_snippet.md)).

## Быстрый старт

1. Клонировать или скопировать шаблон в целевой репозиторий.
2. Выполнить `./local/ai/scripts/init.sh`, чтобы создать симлинки и обновить `.git/info/exclude`; после запуска убедиться, что строки для `AGENTS.md`, `local/ai/` и симлинков присутствуют в `.git/info/exclude`.
3. Проверить наличие симлинков в корне: [.github/copilot-instructions.md](.github/copilot-instructions.md), [.claude/CLAUDE.md](.claude/CLAUDE.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [CLAUDE.md](CLAUDE.md), [GEMINI.md](GEMINI.md), [QWEN.md](QWEN.md); каждый из них должен указывать на [AGENTS.md](AGENTS.md).
4. Заполнить актуальные данные в [local/ai/chat_context.md](local/ai/chat_context.md) (дата, договорённости, проверки); при наличии специфики проекта зафиксировать её в [local/ai/project_addenda.md](local/ai/project_addenda.md).
5. Убедиться, что README нового репозитория содержит скрытый HTML-комментарий (подсказка расположена в начале файла; если фрагмент отсутствует — скопировать его из [README_snippet.md](README_snippet.md)).
6. Ознакомиться с [AGENTS.md](AGENTS.md) и согласовать дополнительные правила с командой; если правила есть — зафиксировать их в [local/ai/project_addenda.md](local/ai/project_addenda.md).
7. После консультаций удалить временные каталоги инструментов (`{{TEMP_TOOL_DIRS}}`), чтобы не оставлять лишние конфигурации.
8. Если токены/ключи хранились в `~/.<tool>`, согласуйте временное копирование или симлинк в `{{TOKEN_STORAGE_PATH}}`, добавьте путь в `.git/info/exclude` и опишите процедуру очистки.
9. Если диалог с ассистентом приближается к ~75% от контекстного окна, завершаем работу командой «завершить сессию», чтобы сформировать сводку и продолжить с чистым контекстом; переполнение окна вытесняет ранние сообщения и ломает согласованные договорённости.

> Если CLI поддерживает `--data-dir` или `--config-dir`, укажите путь внутри `{{TEMP_TOOL_DIRS}}`, чтобы избежать эскалации при работе с конфигурацией.

После первичной настройки обязательно изучите разделы «Быстрый старт», «Ограничения окружения», «Проверки и инструменты», «Логирование обращений», «Передача контекста» и «Синхронизация с апстримом» в [AGENTS.md](AGENTS.md) — они содержат плейсхолдеры, которые нужно адаптировать под ваш проект.

## Интеграция в существующий репозиторий

1. Сохраните копии текущих файлов инструкций (`AGENTS.md`, `local/ai/chat_context.md`, `local/ai/project_addenda.md`, `docs/assistant-*.md` и т.п.) и сравните их с шаблоном.
2. Не копируйте и не заменяйте `README.md`/`README.en.md`. См. правило в `AGENTS.md` (P0) и Step 2 в `local/ai/agents/01-bootstrap.md`.
3. Перенесите действующие договорённости и ограничения в соответствующие плейсхолдеры (`{{LEGACY_INSTRUCTIONS}}`, `{{CHAT_CONTEXT_FILE}}`, `{{PROJECT_ADDENDA_FILE}}`).
4. Просмотрите существующие логи и заметки, чтобы пополнить контекст первой сессии (рабочий язык, режимы песочницы, правила эскалации, список CLI).
5. Убедитесь, что создание временных каталогов (`{{TEMP_TOOL_DIRS}}`, `~/.<tool>`) разрешено или предусмотрены альтернативы; при отсутствии доступа подготовьте план эскалации и перечень параметров `--data-dir`/`--config-dir` для переноса конфигурации внутрь репозитория.
6. Если токены/ключи находятся в домашней папке, временно скопируйте их или создайте симлинк в `{{TOKEN_STORAGE_PATH}}`, добавьте пути в `.git/info/exclude` и обновите инструкции по очистке.
7. После адаптации повторно проверьте README/CONTRIBUTING и удалите упоминания, которые устарели в новом процессе.
8. Зафиксируйте перемещения и решения в `local/ai/session_history.md`, чтобы другие ассистенты понимали, какие данные перенесены из старых инструкций.

Перед изменениями обязательно изучить [CONTRIBUTING.md](CONTRIBUTING.md) и [CONTRIBUTING.en.md](CONTRIBUTING.en.md), чтобы поддерживать двуязычную документацию в актуальном состоянии.
