# {{PROJECT_NAME}} — Documentation

This folder keeps product intent and dev agents aligned. **Read before expanding scope.**

## Workflow (in order)

| Step | Skill | Output |
|------|-------|--------|
| 1 | `/init-docs` | This layout (once per repo) |
| 2 | `/problematize` | [`problem_summary.md`](problem_summary.md) — why we're building |
| 3 | `/solutionize` | [`solution_overview.md`](solution_overview.md) + [`CONTEXT.md`](CONTEXT.md) |
| 4 | `/get-prd` | [`prd.md`](prd.md) — committed scope (no open questions section) |
| 5 | `/prd-to-issues` | GitHub issues (vertical slices) |
| 6 | `/tdd` | Implementation with tests |
| — | `/afk-dev` | Autonomous issue cycles — metadata in [`loops/`](loops/) |
| — | `/diagnose` | Bug fixes — feedback loop first, regression test required |
| — | `/unslop-repo` | Architecture hygiene (periodic) → `/create-ticket` for approved deepenings |

## File roles

- **`problem_summary.md`** — Frozen problem space. Open questions live here, not in the PRD. Raw terms → **Terms surfaced**.
- **`CONTEXT.md`** — Canonical domain vocabulary (`/solutionize`). Module names and PRD stories use these terms.
- **`solution_overview.md`** — Direction, module tree, decisions, out-of-scope. Open questions live here too.
- **`prd.md`** — What we ship now. If it's not here, ask before building.
- **`adr/`** — Hard-to-reverse technical decisions ([README](adr/README.md)).
- **`agents/`** — Repo-specific notes for AI agents (issue tracker, launch configs).
- **`loops/`** — `/afk-dev` cycle plans, logs, summaries ([README](loops/README.md)). Worker sandboxes: `.worktrees/` (gitignored).

## During development

- **Scope drift:** If the change isn't traceable to `prd.md` or an issue, stop and update docs or create an issue first.
- **Bugs:** Use `/diagnose` — failing test at the correct UI seam, not session log files.
- **Module docs:** Add `docs/modules/module_*.md` for deep dives; link from PRD or via `/unslop-repo`.

## Manual QA

Add checklists as `docs/manual_qa_*.md` when automation isn't ready (Flutter widget tests preferred).
