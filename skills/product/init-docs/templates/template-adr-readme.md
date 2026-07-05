# Architecture Decision Records

Write an ADR when **all three** are true:

1. **Hard to reverse** — changing later is costly
2. **Surprising without context** — future readers will ask "why?"
3. **Real trade-off** — genuine alternatives existed

## Format

`NNN-short-title.md` — e.g. `001-offline-first-sync.md`

```markdown
# NNN — Title

## Status
Accepted | Superseded by NNN

## Context
What forced a decision.

## Decision
What we chose.

## Consequences
Good and bad outcomes.
```

Do not ADR every implementation detail — use module docs or PR notes for small choices.
