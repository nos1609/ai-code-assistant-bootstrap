# Шаблон сводок сессий / Session summaries template

**RU:** Здесь хранятся конспекты завершённых сессий в формате Markdown. На каждую сессию создавайте файл `local/session_summaries/<ISO8601>.md` (пример: `2025-05-06T12:34:56Z.md`) со структурой ниже.  
**EN:** Store per-session hand-off notes here (Markdown). For every finished consultation create `local/session_summaries/<ISO8601>.md` (e.g., `2025-05-06T12:34:56Z.md`) following the structure below.

```
# Контекст / Context
# Системные указания / System directives
# Ключевые файлы / Key files (path:line — короткий комментарий / short note)
# Последние события / Recent events (нумерованный список / ordered list)
# Проблемы и решения / Issues & fixes
# Рекомендации / Next steps (checkbox list)
# Дополнительные материалы / Additional materials (логи, артефакты / logs, artifacts)
# Открытые вопросы / Pending items
```

**RU:** Сводки ускоряют hand-off: следующий ассистент видит последние действия и нерешённые вопросы. Скрипт `scripts/collect_open_items.py` автоматически собирает из них незакрытые пункты.  
**EN:** Summaries speed up hand-offs: the next assistant instantly sees recent steps and pending items. `scripts/collect_open_items.py` aggregates “Recommendations / Pending items” from these files automatically.
