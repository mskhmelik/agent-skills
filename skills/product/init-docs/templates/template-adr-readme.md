# Architecture Decision Records

One-paragraph records of decisions worth remembering. Written by agents during
`/ask-about-solutions` (or `/unslop-repo`) and offered to you as a single yes/no — **you
never write these yourself**. The human-readable one-liner also lands in
[`../../foundation/OVERVIEW.md`](../../foundation/OVERVIEW.md) → Decisions; this folder is
the deeper "why" that agents read to avoid re-litigating settled choices.

## Write an ADR only when all three are true

1. **Hard to reverse** — changing later is costly
2. **Surprising without context** — a future reader will ask "why did they do it this way?"
3. **Real trade-off** — genuine alternatives existed and one was chosen for specific reasons

Non-obvious rejections count too ("considered GraphQL, picked REST because…").

## Format

`NNN-slug.md` — e.g. `001-offline-first-sync.md` (scan for the highest number, increment).
A title plus 1–3 sentences — context, decision, why. An ADR can be a single paragraph.

```markdown
# NNN — Short title of the decision

Context, what we decided, and why — in 1–3 sentences.
```

**Optional, only when they add value:** a `Status` line (proposed | accepted | superseded
by NNN) when a decision gets revisited; a Considered-options or Consequences note when the
rejected alternatives or downstream effects are worth spelling out.

Do not ADR every implementation detail — small choices live in module docs or PR notes.
