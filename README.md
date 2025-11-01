<!--
Инструкция для AI-агента:
MUST немедленно изучить файлы [AGENTS.md](AGENTS.md) и [local/chat_context.md](local/chat_context.md).
ВАЖНО: Файлы скрыты в [.gitignore](.gitignore). Отключи фильтрацию по gitignore при поиске и чтении.
Примеры команд: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.
Дополнительно: Ознакомься с симлинками [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md) и [QWEN.md](QWEN.md). Для Codex используй подкоманду `codex exec` (alias `codex e`).

---

Instruction for the AI Agent:
MUST immediately read [AGENTS.md](AGENTS.md) and [local/chat_context.md](local/chat_context.md).
IMPORTANT: These files are hidden via [.gitignore](.gitignore); disable gitignore filtering when searching and reading.
Example commands: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.
Additionally, review symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md). For Codex run the `codex exec` subcommand (alias `codex e`).
-->


# ai-code-assistant-bootstrap
## Шаблон для локальных ассистентов

> 🇬🇧 English version: see [README.en.md](README.en.md)

Шаблон предназначен для репозиториев, где с кодом работают локальные AI-ассистенты: он задаёт единые правила общения, порядок запуска инструментов и требования к оформлению ответов, чтобы минимизировать недопонимания между людьми и агентами.

Набор ai-code-assistant-bootstrap включает:

- [README.md](README.md) / [README.en.md](README.en.md) — краткий обзор набора файлов на русском и английском, готовый скрытый HTML-комментарий внутри.
- [AGENTS.md](AGENTS.md) — универсальный набор правил с локальными предпочтениями, содержащий инструкции для `gemini`, `qwen` и `codex`; содержит требование в первом ответе уточнять предпочтительный грамматический род пользователя.
- [local/chat_context.md](local/chat_context.md) — заготовка контекста чата для фиксации договорённостей.
- [local/project_addenda.md](local/project_addenda.md) — пустой шаблон для проектных дополнений; заполняется только при наличии специфических правил.
- [README_snippet.md](README_snippet.md) — исходник HTML-комментария, если нужно переиспользовать его вручную.
- [scripts/init.sh](scripts/init.sh) — скрипт для развёртывания симлинков и заполнения `.gitignore`.
- [.gitignore](.gitignore) — заготовка для скрытия [AGENTS.md](AGENTS.md), [local/](local/) и симлинков (строки закомментированы по умолчанию; при внедрении шаблона их следует раскомментировать или запускать `./scripts/init.sh`).
- [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), [QWEN.md](QWEN.md) — симлинки на [AGENTS.md](AGENTS.md), чтобы все ассистенты читали единый набор правил без дублирования.

Для работы ассистентов требуется локально доступные CLI (`gemini`, `qwen`, `codex`, `copilot`). Codex следует запускать через подкоманду `codex exec` (alias `codex e`), чтобы выполнять инструкции в неинтерактивном режиме.

### Настройки шаблона для ассистентов

| Ассистент | Локальная установка | Подтверждение | Ссылка | Расположение в репозитории | Примечание |
|-----------|--------------------|--------------|--------|----------------------------|------------|
| `gemini`  | ☑ | ☑ | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) | [.gemini/GEMINI.md](.gemini/GEMINI.md) → [AGENTS.md](AGENTS.md); [GEMINI.md](GEMINI.md) (корень) → [AGENTS.md](AGENTS.md) | — |
| `qwen`    | ☑ | ☑ | [QwenLM/qwen-code](https://github.com/QwenLM/qwen-code)     | [QWEN.md](QWEN.md) (корень) → [AGENTS.md](AGENTS.md) | Может переключиться на язык запроса только со второй реплики; при необходимости напомните о правилах явно. |
| `codex`   | ☑ | ☑ | [openai/codex](https://github.com/openai/codex)             | [AGENTS.md](AGENTS.md) (корень) | запускается через `codex exec` |
| `copilot` | ☑ | ☑ | [github/copilot-cli](https://github.com/github/copilot-cli) | [.github/copilot-instructions.md](.github/copilot-instructions.md) → [AGENTS.md](AGENTS.md) | — |

Содержимое каталога копируется в целевой репозиторий, затем в [local/chat_context.md](local/chat_context.md) актуализируются дата и договорённости. После этого выполняется `./scripts/init.sh`, который подготавливает симлинки. В завершение рекомендуется проверить, что README нового репозитория содержит HTML-комментарий для ассистентов (фрагмент можно взять из этого файла).

## Быстрый старт

1. Клонировать или скопировать шаблон в целевой репозиторий.
2. Выполнить `./scripts/init.sh`, чтобы создать симлинки и обновить [.gitignore](.gitignore); после запуска убедиться, что строки для `AGENTS.md`, `local/` и симлинков действительно раскомментированы.
3. Проверить наличие симлинков в корне: [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), [QWEN.md](QWEN.md); каждый из них должен указывать на [AGENTS.md](AGENTS.md).
4. Заполнить актуальные данные в [local/chat_context.md](local/chat_context.md) (дата, договорённости, проверки); при наличии специфики проекта зафиксировать её в [local/project_addenda.md](local/project_addenda.md).
5. Убедиться, что README нового репозитория содержит скрытый HTML-комментарий (подсказка расположена в начале файла; при необходимости скопировать фрагмент из [README_snippet.md](README_snippet.md)).
6. Ознакомиться с [AGENTS.md](AGENTS.md) и согласовать дополнительные правила с командой; при необходимости дополнить их в [local/project_addenda.md](local/project_addenda.md).

Перед изменениями рекомендуется изучить [CONTRIBUTING.md](CONTRIBUTING.md) и [CONTRIBUTING.en.md](CONTRIBUTING.en.md), чтобы поддерживать двуязычную документацию в актуальном состоянии.
