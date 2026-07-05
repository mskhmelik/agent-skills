# {{PROJECT_NAME}} — Documentation

This folder keeps product intent and dev agents aligned. **Read before expanding scope.**
The layout below is **closed** — see the rule at the bottom.

## Layout

```
docs/
  README.md                         ← this file: map + closed-layout rule + naming rule
  foundation/
    problem-summary.md              ← /problematize output
    solution-overview.md            ← /solutionize output
    CONTEXT.md                      ← /solutionize domain glossary
    prd.md                          ← /get-prd output
    design-system.md                ← optional, design-system docs
  reviews/
    README.md                       ← shipped-arch record only
    adr/                            ← hard-to-reverse technical decisions
  engineering/
    loops/                          ← /afk-dev cycle plans, logs, summaries (append-only)
    modules/                        ← module deep dives
    security/                       ← security-relevant docs
    ops/                            ← build + dev + tooling docs
    projects.json
  agents/
    README.md                       ← single tracker/process doc for AI agents
```

## Workflow (in order)

| Step | Skill | Output |
|------|-------|--------|
| 1 | `/init-docs` | This layout (once per repo) |
| 2 | `/problematize` | [`foundation/problem-summary.md`](foundation/problem-summary.md) — why we're building |
| 3 | `/solutionize` | [`foundation/solution-overview.md`](foundation/solution-overview.md) + [`foundation/CONTEXT.md`](foundation/CONTEXT.md) |
| 4 | `/get-prd` | [`foundation/prd.md`](foundation/prd.md) — committed scope (no open questions section) |
| 5 | `/prd-to-issues` | GitHub issues (vertical slices) |
| 6 | `/tdd` | Implementation with tests |
| — | `/afk-dev` | Autonomous issue cycles — metadata in [`engineering/loops/`](engineering/loops/) |
| — | `/diagnose` | Bug fixes — feedback loop first, regression test required |
| — | `/unslop-repo` | Architecture hygiene (periodic) → `/create-ticket` for approved deepenings |

## Where things go

| Content | Path |
|---------|------|
| Problem investigation | `foundation/problem-summary.md` |
| Domain vocabulary | `foundation/CONTEXT.md` |
| Solution direction, module tree, decisions | `foundation/solution-overview.md` |
| Committed scope | `foundation/prd.md` |
| Design-system notes (optional) | `foundation/design-system.md` |
| Shipped-architecture record | `reviews/README.md` |
| Hard-to-reverse technical decisions | `reviews/adr/NNN-short-title.md` |
| One-off analysis / review write-ups | `reviews/<date>-<topic>.md` |
| `/afk-dev` cycle plans, logs, summaries | `engineering/loops/` |
| Module deep dives | `engineering/modules/<name>.md` |
| Security-relevant docs | `engineering/security/` |
| Build, dev, tooling docs | `engineering/ops/` |
| Repo-specific notes for AI agents (issue tracker, launch configs) | `agents/README.md` |
| Findings / backlog items | a GitHub issue via `/create-ticket` — never a new doc |

## File roles

- **`foundation/problem-summary.md`** — Frozen problem space. Open questions live here, not in the PRD. Raw terms → **Terms surfaced**.
- **`foundation/CONTEXT.md`** — Canonical domain vocabulary (`/solutionize`). Module names and PRD stories use these terms.
- **`foundation/solution-overview.md`** — Direction, module tree, decisions, out-of-scope. Open questions live here too.
- **`foundation/prd.md`** — What we ship now. If it's not here, ask before building.
- **`reviews/adr/`** — Hard-to-reverse technical decisions ([README](reviews/README.md)).
- **`agents/README.md`** — Repo-specific notes for AI agents (issue tracker, launch configs).
- **`engineering/loops/`** — `/afk-dev` cycle plans, logs, summaries. Worker sandboxes: `.worktrees/` (gitignored).

## During development

- **Scope drift:** If the change isn't traceable to `foundation/prd.md` or an issue, stop and update docs or create an issue first.
- **Bugs:** Use `/diagnose` — failing test at the correct UI seam, not session log files.
- **Module docs:** Add `docs/engineering/modules/*.md` for deep dives; link from PRD or via `/unslop-repo`.

## Manual QA

Add checklists as `docs/engineering/ops/manual-qa-*.md` when automation isn't ready (Flutter widget tests preferred).

## Closed-layout rule

This layout is **closed**: every doc lives at one of the paths above. Never create a new
top-level doc folder, a loose file at `docs/` root, or a `-vN` filename variant. Findings
and backlog items go to GitHub issues via `/create-ticket`, never to a new doc. If nothing
fits, ask — do not invent a path.

## Naming rule

All filenames are **kebab-case**, except `README.md` and `CONTEXT.md` which keep their
conventional all-caps names.
