# AFK dev plan template

The coordinator writes one of these to `docs/engineering/loops/loop_<YYYY-MM-DD>-<slug>/plan.md` in Step 3,
presents it for approval, and only spawns workers after the user confirms.

---

## Template

```markdown
# AFK dev plan — <date>

Base branch: <main>
Scope: agent:hitl issues (agent:afk: <included | excluded — note if included>)

## Flagged — needs-triage (excluded from this cycle)
- #<n> "<title>" — no agent:* label, labelled needs-triage

## Flagged — agent:blocked (excluded from this cycle)
- #<n> "<title>" — blocked since <date>, reason: <one line>

## In scope this cycle

| # | Title | Priority tier | Depends on | Model | Mode | Batch |
|---|---|---|---|---|---|---|
| 12 | Fix auth redirect loop | 1 — bugfix | — | sonnet-4.5-thinking | plan→execute | A (parallel) |
| 15 | Add request logging middleware | 2 — infra | — | sonnet-4.5 | plan→execute | A (parallel) |
| 18 | Tracer: CSV export endpoint | 3 — tracer bullet | #15 | sonnet-4.5 | plan→execute | B (after A) |
| 21 | Rename helper functions for clarity | 5 — refactor | — | <fast model> | execute only | A (parallel) |

## Execution order

- **Batch A** (parallel, max concurrent = <3>): #12, #15, #21
- **Batch B** (sequential, starts after #15's PR merges): #18

## Worker spawn budget
- Workers this cycle: 4 / 8 (cap)
- Concurrent cap: 3

## Open questions for the human before spawning
- <e.g. "Confirm #18 should branch from main post-#15-merge rather than stack on #15's branch — will add ~1 cycle of latency.">

## Post-cycle (coordinator does NOT merge automatically)
- Babysit open PRs; present manual QA checklist from `summary.md`.
- **Merge only after human QA** and explicit "OK to merge" in chat (CONVENTIONS.md).

---
**Approval required before any worker is spawned.** Reply with changes
(split/merge/reorder/exclude) or "approved" to proceed.
```
