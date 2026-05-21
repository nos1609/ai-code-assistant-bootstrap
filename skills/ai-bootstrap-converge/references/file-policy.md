# File Policy

Classify target repository files before changing them.

| Class | Paths | Convergence rule |
| --- | --- | --- |
| `managed-exact` | `AGENTS.md`, `README_snippet.md`, `local/ai/agents/**`, `local/ai/scripts/**`, `local/ai/bootstrap.ready`, `skills/ai-bootstrap-converge/**` | Required framework. Create when missing. If existing content differs, report conflict unless the user explicitly authorizes forced replacement. |
| `discovery-link` | `.agents/skills/ai-bootstrap-converge`, `.claude/skills/ai-bootstrap-converge` | Agent-specific discovery paths. They must be symlinks to `../../skills/ai-bootstrap-converge` when present. Never duplicate skill files here. If symlink creation is unavailable, report it and keep the canonical `skills/**` package only. |
| `patch-only` | `README.md`, `README.en.md` | Project-owned. Only insert/move the exact hidden snippet from `README_snippet.md` to the top. Never rewrite the body. |
| `exclude-patch` | `.git/info/exclude` | Local git hygiene. Add required lines from the template `.gitignore` `BEGIN/END EXCLUDE LIST` block plus local runtime paths. Never remove unrelated existing lines. |
| `link-target` | `.github/copilot-instructions.md`, `.gemini/GEMINI.md`, `.qwen/QWEN.md`, `GEMINI.md`, `QWEN.md`; Claude links only when present in the template or requested | Must point to `AGENTS.md` through symlink or hardlink. Existing different content is a conflict, not something to silently overwrite. |
| `ensure-if-missing` | `local/ai/chat_context.md`, `local/ai/project_addenda.md`, `local/ai/session_history.md`, `local/ai/<assistant>/README.md`, `local/ai/<assistant>/requests.log`, `local/ai/<assistant>/sessions.log` | Create from template only when absent. If present, preserve it. |
| `local-only` | `AGENTS.override.md`, `.codex/**`, `tmp/ai/**`, `local/ai/session_summaries/**`, `local/ai/context_packs/**`, `local/ai/<assistant>/*.log`, `local/ai/<assistant>/*.session` | Must be ignored/local. Never copy from template over target state. Report if tracked by git. |
| `never` | secrets, tokens, tool homes, user IDE settings, unrelated project files | Never create, overwrite, or delete. |

When a local file contains useful project-specific instructions that conflict with a mandatory framework file, preserve the user content. Report it as a merge conflict and recommend moving project-specific content into `AGENTS.override.md`, `local/ai/project_addenda.md`, or the appropriate local context file.
