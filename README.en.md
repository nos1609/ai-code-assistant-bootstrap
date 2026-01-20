<!--
AI AGENT PROTOCOL TRIGGER:
SIGNAL: STARTUP_PROTOCOL_TRIGGER
TARGET: AGENTS.md
ACTION: Follow startup protocol immediately

EN: WHEN ANALYZING THIS REPOSITORY:
1. IMMEDIATELY read [AGENTS.md](AGENTS.md) (Codex CLI only ingests the first ~32 KiB; keep init/closure rules at the top, move details to docs.)
2. EXECUTE the startup protocol from “Initial Session Protocol”
3. FOLLOW agreements in [local/chat_context.md](local/chat_context.md)

RU: ПРИ АНАЛИЗЕ ЭТОГО РЕПОЗИТОРИЯ:
1. НЕМЕДЛЕННО прочитай [AGENTS.md](AGENTS.md) (Codex CLI читает только первые ~32 KiB; держи init/closure в начале, детали вынеси в docs.)
2. ВЫПОЛНИ протокол запуска из раздела «Протокол начала сессии»
3. СЛЕДУЙ соглашениям из [local/chat_context.md](local/chat_context.md)

IMPORTANT: Files are hidden in [.gitignore](.gitignore). Disable gitignore filtering when searching and reading.
Example commands: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.

ВАЖНО: Файлы скрыты в [.gitignore](.gitignore). Отключи фильтрацию по gitignore при поиске и чтении.
Примеры команд: `rg --hidden --no-ignore pattern`, `fd --hidden --no-ignore`.

Additionally: Review symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md). Always use relative paths when recreating them.

Дополнительно: Ознакомься с симлинками [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md) и [QWEN.md](QWEN.md). При восстановлении симлинков используй относительные пути.

Ensure temp CLI homes (`tmp/gemini_home`, `tmp/qwen_home`, `tmp/copilot_home`, `tmp/cli_tokens`) are absent before launching tools. Document and clean them after user confirmation if they exist.

Перед запуском CLI убедись, что нет временных каталогов (`tmp/gemini_home`, `tmp/qwen_home`, `tmp/copilot_home`, `tmp/cli_tokens`). Если они найдены — опиши и очисть после подтверждения пользователя.
-->



# ai-code-assistant-bootstrap
## Template for local assistants

> 🇷🇺 Русская версия: см. [README.md](README.md)

This template targets repositories that rely on local AI assistants: it codifies communication rules, tool usage, and response formatting so human developers and agents share the same expectations.

The ai-code-assistant-bootstrap pack includes:

- [README.md](README.md) / [README.en.md](README.en.md) — quick overview in Russian and English with the ready-to-use hidden HTML snippet.
- [AGENTS.md](AGENTS.md) — shared instruction set reflecting local workflow preferences, containing instructions for `gemini`, `qwen`, and `codex`; it requires asking for the user’s preferred grammatical gender in the first reply.
- [local/chat_context.md](local/chat_context.md) — template that captures agreements for each assistant session.
- [local/project_addenda.md](local/project_addenda.md) — empty project addenda template; fill it only when the team defines additional rules.
- [README_snippet.md](README_snippet.md) — source of the HTML comment in case you need to re-use it.
- [local/ai/scripts/init.sh](local/ai/scripts/init.sh) — helper script that prepares symlinks and populates `.git/info/exclude` based on the list in `.gitignore`; it also refreshes `local/ai/bootstrap.ready` (first line `true`, followed only by list entries).
- [local/ai/scripts/bootstrap_check.sh](local/ai/scripts/bootstrap_check.sh) / [local/ai/scripts/bootstrap_check.ps1](local/ai/scripts/bootstrap_check.ps1) — ensure the hidden README snippet is present, all assistant symlinks target `AGENTS.md`, `.git/info/exclude` matches the list in `local/ai/bootstrap.ready`, and assistant logs use ISO 8601 UTC.
- `local/ai/scripts/` — project utilities (e.g., open-item collector, consultation orchestrator, log trimming); see script headers for usage.
- `local/<assistant>/sessions.log` and `local/<assistant>/requests.log` — JSONL logs for every assistant (`gemini`, `qwen`, `codex`, `copilot`) capturing `timestamp`, `request_id`, `assistant`, `summary/short_context`, `tools`, `status`.
- [local/session_history.md](local/session_history.md) and `local/session_summaries/` — living log and structured hand-off notes shared by all assistants.
- `local/gemini`, `local/qwen`, `local/codex`, `local/copilot` — each ships with a README and sample entries to keep the schema consistent.

## How to adapt the template

- **`local/project_addenda.md`.** Fill in the environment matrix (OS, privileges, tooling), allow/deny rules, token directories, and logging policy. Use placeholders when details are unknown, but keep the bilingual sections intact.
- **`local/chat_context.md`.** Record the working language and gender, quick environment profile, “Resolved contradictions,” the session-summary checklist, and logging reminders. This is the first file every assistant reads.
- **Assistant logs.** Leave at least one JSONL entry in `local/<assistant>/sessions.log` and `requests.log` demonstrating ISO 8601 timestamps (`YYYY-MM-DDTHH:MM:SSZ`) plus the fields `timestamp`, `request_id`, `assistant`, `summary`, `tools`, `status`.
- **Multi-assistant workflow.** Use project scripts under `local/ai/scripts/` (document parameters in addenda); keep raw logs in `tmp/ai/consultation_runs/` and processed artifacts in `tmp/ai/assistant_contexts/`.
- **Bootstrap procedure.** Once README, symlinks, and logs are in place, run `local/ai/scripts/bootstrap_check.sh`/`.ps1` and record the outcome inside `local/ai/chat_context.md` and `local/ai/session_history.md` so the next assistant knows the readiness state.

> ⚠️ **Windows PowerShell:** if execution policy blocks `.ps1`, relax it for the current session only:  
> `powershell -NoProfile -ExecutionPolicy Bypass -File local/ai/scripts/bootstrap_check.ps1`
> Restore the previous policy afterwards or close the shell; script signing is not required.
- [.gitignore](.gitignore) — a starter list for `.git/info/exclude` (the entries are commented out by default; if you copy them manually into `.git/info/exclude`, remove the leading `# `, or just run `./local/ai/scripts/init.sh`).
- [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md) — symlinks pointing to [AGENTS.md](AGENTS.md), keeping every assistant on a single source of truth.

Local installation of the command-line interfaces (`gemini`, `qwen`, `codex`, `copilot`) is required. Codex should be invoked via the `codex exec` subcommand (alias `codex e`) to follow the non-interactive workflow described here.

### Template alignment for assistants

| Assistant | Local install | Approval | Link | Repository placement | Notes |
|-----------|--------------|----------|------|-----------------------|-------|
| `gemini`  | ☑ | ☑ | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) | [.gemini/GEMINI.md](.gemini/GEMINI.md) → [AGENTS.md](AGENTS.md); [GEMINI.md](GEMINI.md) (repo root) → [AGENTS.md](AGENTS.md) | — |
| `qwen`    | ☑ | ☑ | [QwenLM/qwen-code](https://github.com/QwenLM/qwen-code)     | [QWEN.md](QWEN.md) (repo root) → [AGENTS.md](AGENTS.md) | Does not auto-run the bootstrap/protocol from AGENTS.md; needs an explicit prompt allowing shell commands (e.g., "run the protocol and use shell for symlinks and logs"). |
| `codex`   | ☑ | ☑ | [openai/codex](https://github.com/openai/codex)             | [AGENTS.md](AGENTS.md) (repo root) | run via `codex exec` |
| `copilot` | ☑ | ☑ | [github/copilot-cli](https://github.com/github/copilot-cli) | [.github/copilot-instructions.md](.github/copilot-instructions.md) → [AGENTS.md](AGENTS.md) | — |

The directory is copied into the target repository, after which [local/ai/chat_context.md](local/ai/chat_context.md) is updated with the current date and agreements. Running `./local/ai/scripts/init.sh` then prepares the symlinks. Finally, confirm that the target README retains the hidden HTML comment for assistants (the snippet is available in this file and in [README_snippet.md](README_snippet.md)).

## Quick Start

1. Clone or copy this template into the target repository.
2. Run `./local/ai/scripts/init.sh` to create the symlinks and update `.git/info/exclude`; afterwards confirm the entries for `AGENTS.md`, `local/ai/`, and the symlinks exist in `.git/info/exclude`.
3. Verify that the symlinks [.github/copilot-instructions.md](.github/copilot-instructions.md), [.gemini/GEMINI.md](.gemini/GEMINI.md), [GEMINI.md](GEMINI.md), and [QWEN.md](QWEN.md) exist in the workspace, each pointing back to [AGENTS.md](AGENTS.md).
4. Populate [local/chat_context.md](local/chat_context.md) with current data (date, agreements, checks); capture any project-specific rules in [local/project_addenda.md](local/project_addenda.md).
5. Confirm that the new repository’s README retains the hidden HTML comment (the snippet appears at the top of this file; it can also be copied from [README_snippet.md](README_snippet.md)).
6. Review [AGENTS.md](AGENTS.md) and, if needed, coordinate additional rules with the team, recording them in [local/project_addenda.md](local/project_addenda.md) when appropriate.
7. After each consultation, remove tool-specific temp directories (`{{TEMP_TOOL_DIRS}}`) so no stray configurations remain.
8. When tokens/keys live in `~/.<tool>`, agree on temporarily copying or symlinking them into `{{TOKEN_STORAGE_PATH}}`, add the path to `.gitignore`, and document the cleanup.
9. Watch the conversation length: if a chat approaches ~75% of the context window, close it with the project’s “finish session” cue so the assistant can produce a summary in `{{SESSION_SUMMARY_DIR}}`; overruns purge older messages and risk losing agreements.

> When a CLI provides `--data-dir`/`--config-dir`, point it to `{{TEMP_TOOL_DIRS}}` to avoid requesting extra permissions.

After the bootstrap, review the “Quick Start,” “Environment Limits,” “Checks and Tooling,” “Logging Requests,” “Context handoff,” and “Upstream Sync” sections in [AGENTS.md](AGENTS.md); they expose placeholders that must be tailored to your project.

## Integrating into an Existing Repository

1. Back up the current instruction files (`AGENTS.md`, `local/chat_context.md`, `local/project_addenda.md`, `docs/assistant-*.md`, etc.) and diff them against the template.
2. Carry over active agreements and constraints into the relevant placeholders (`{{LEGACY_INSTRUCTIONS}}`, `{{CHAT_CONTEXT_FILE}}`, `{{PROJECT_ADDENDA_FILE}}`).
3. Review existing logs or runbooks to enrich the first-session context (working language, sandbox modes, escalation policy, available CLIs).
4. Ensure creating temp directories (`{{TEMP_TOOL_DIRS}}`, `~/.<tool>`) is allowed or plan an escalation alternative if not; capture the `--data-dir`/`--config-dir` overrides that keep files inside the repo.
5. If tokens/keys live in the home directory, temporarily copy or symlink them into `{{TOKEN_STORAGE_PATH}}`, update `.gitignore`, and document the cleanup routine.
6. After adapting the template, re-check README/CONTRIBUTING and retire any references that no longer apply to the updated workflow.
7. Record migrations and decisions in `local/session_history.md` so other assistants know which details were imported from previous instructions.

Before introducing changes, consult [CONTRIBUTING.md](CONTRIBUTING.md) and [CONTRIBUTING.en.md](CONTRIBUTING.en.md) to keep the bilingual documentation aligned.


