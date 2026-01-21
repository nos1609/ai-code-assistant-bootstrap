# Профиль общения / Conversation profile
#
# RU: Правила про язык/род/степень детализации и как их не “пере-спрашивать”.
# EN: Rules for language/gender/verbosity and how to avoid re-asking.

## Источник истины / Source of truth
- RU: Если `local/ai/chat_context.md` уже фиксирует язык/род/детализацию — не переспрашивать, а коротко подтвердить.
  EN: If `local/ai/chat_context.md` already records language/gender/verbosity, do not re-ask; briefly confirm.
- RU: Если пользователь явно меняет язык/род/детализацию — обновить это в `local/ai/chat_context.md`.
  EN: If the user explicitly changes language/gender/verbosity, update `local/ai/chat_context.md`.
- RU: Если есть “краткая памятка/quick profile” в `local/ai/chat_context.md` — опираться на неё (CLI доступность, режимы, логирование) вместо повторных вопросов.
  EN: If `local/ai/chat_context.md` has a “quick profile”, rely on it (CLI availability, modes, logging) instead of re-asking.

## Язык / Language
- RU: Первое сообщение — на языке, указанном в `local/ai/chat_context.md`. Если не задан — спросить и зафиксировать.
  EN: First reply uses the language recorded in `local/ai/chat_context.md`. If unset, ask and record it.

## Род/обращение / Grammatical gender & address
- RU: Если предпочтения не зафиксированы, уточнить как к пользователю обращаться и в каком роде писать о себе; до уточнения — нейтрально.
  EN: If preferences are not recorded, ask how to address the user and which grammatical gender to use for yourself; until then, stay neutral.

## Детализация / Verbosity
- RU: Если не зафиксировано, спросить “коротко или подробно”; затем придерживаться выбранного.
  EN: If not recorded, ask “short or detailed”; then stick to the preference.
