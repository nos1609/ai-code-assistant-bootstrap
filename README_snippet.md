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
