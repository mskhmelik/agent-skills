# AFK Dev Conventions — single source of truth

This file is the **canonical** reference for labels, branch naming, priority order,
caps, and merge policy used by `/afk-dev`. Every other file (SKILL.md, templates,
scripts) refers back here rather than restating these rules — if a rule needs to
change, change it once, here.

## Label taxonomy

Aligns with the `Mode: HITL | AFK` notes that `/prd-to-issues` already writes into
issue bodies. `/afk-dev` reads **labels**, not body text, so issues must carry one of:

| Label | Meaning |
|---|---|
| `agent:afk` | Fully autonomous: agent may execute, open PR, and (if configured) merge without a human checkpoint mid-flight. |
| `agent:hitl` | Agent executes and opens a PR, but the PR **requires human review/approval** before merge. This is the default scope for `/afk-dev` — see Step 2. |
| `agent:blocked` | Previously attempted, could not proceed (waiting on a decision, external dependency, or repeated failure). Excluded from planning until unblocked. |
| `needs-triage` | No `agent:*` label present. `/afk-dev` adds this automatically and excludes the issue from the cycle — never picked up silently. |

**Default scope for a `/afk-dev` cycle: `agent:hitl` issues only.** `agent:afk` is
opt-in per project (note it in the plan if the user wants it included).

## Branch naming

`afk/<issue-number>-<slug>`, e.g. `afk/284-filter-bar`.

**Ticket ID:** issue title `{PREFIX}-{N}` where **N = GitHub issue number** (same as `#N`).
Branch uses that same `N`.

## PR conventions

Aligns with [create-ticket CONVENTIONS](../create-ticket/CONVENTIONS.md).

| Field | Rule |
|-------|------|
| **PR title** | Copy issue title exactly — e.g. `BUG-284: Filter bar mirrors visible column order` |
| **PR body** | Start with `Closes #284`, then Summary and Test plan |
| **PR system #** | GitHub auto (e.g. `#291`); use for merge/CI only — will not match issue # |
| **Branch** | `afk/{N}-{slug}` where N = issue number |

**Citation in summaries:** `PR #291 — BUG-284: Filter bar mirrors…` — never bare `PR #291`.

Workers open PRs with:

```bash
gh pr create --title "<issue title exactly>" --body "$(cat <<'EOF'
Closes #<N>

## Summary
- …

## Test plan
- [ ] …
EOF
)"
```

- Independent tasks branch from the cycle's base branch (default: `main`).
- Dependent tasks (declared via "Blocked by #N" / "Depends on #N" in the issue body)
  branch from `main` **after** the dependency's PR has merged — never from another
  task's in-flight branch. If the cycle can't wait, the dependent task is deferred
  to the next cycle rather than stacked.

## Priority order (within a cycle)

1. Critical bugfixes
2. Development infrastructure (tests, types, dev scripts, CI)
3. Tracer bullets — smallest end-to-end slice of a new feature
4. Polish / quick wins
5. Refactors

## Caps (hard stops — do not exceed without explicit user override)

| Cap | Default | Purpose |
|---|---|---|
| Max concurrent workers | 3 | Avoid resource contention / overlapping file edits |
| Max total workers spawned per cycle | 8 | Bound blast radius; avoids "task explosion" |
| Max iterations per worker | 12 | Prevent a single task from running forever |
| No-progress threshold | 3 | If the same test/error repeats 3x in a row, worker stops and marks `agent:blocked` — does not keep retrying |

## Model / mode assignment heuristic

| Task signals | Model tier | Mode sequence |
|---|---|---|
| Touches architecture, multiple modules, or "infrastructure" priority tier | Higher-reasoning model (e.g. `opus` / `sonnet-4.5-thinking`) | plan-mode pass → execute |
| Tracer bullet / new feature slice | Default model (`sonnet-4.5`) | plan-mode pass → execute |
| Polish, quick win, mechanical refactor | Faster/cheaper model | execute only (skip plan pass) |

The coordinator records the actual assignment per task in `docs/engineering/loops/loop_<date>-<slug>/plan.md` — this
table is guidance, not a rigid rule.

## Merge policy

**Hard rule — coordinator never merges without explicit human approval after QA:**

1. Workers open PRs and stop. Coordinator **does not** run `gh pr merge`, squash,
   or merge locally — not when PRs are green, not when babysit passes, not when
   a plan todo says "merge", and not when the user said "implement the plan"
   unless they also explicitly approved merge **after** manual QA in that cycle.
2. Coordinator presents `summary.md` with the **manual QA checklist** (Step 7).
3. Human runs QA (checkout branch/worktree or test build) and replies with an
   explicit merge OK, e.g. "OK to merge", "merge the PRs", or "merge #232–#235".
4. Only then may the coordinator (or human) merge. If QA fails, fix or close —
   do not merge.

Additional rules:

- **No auto-merge by default** for any `agent:afk` or `agent:hitl` issue — even
  if the user has run many cycles — until they explicitly opt into auto-merge for
  a specific cycle in chat.
- Sequential (dependent) tasks merge in **dependency order** once approved.
  Parallel/independent tasks may merge in any order once approved.
- Workers rebase onto the latest base branch before marking their PR ready.

## Blocked-task handling (see also: SKILL.md "refusal escalation" note)

If a worker cannot complete its task (blocked, repeated failure, missing
decision):

1. Push whatever work exists as a WIP commit on its branch (do not lose work).
2. Add a comment to the issue: what was tried, what's blocking it, what decision
   or input is needed.
3. Apply the `agent:blocked` label (remove `agent:hitl`/`agent:afk` while blocked).
4. Append a status line to `docs/engineering/loops/loop_<date>-<slug>/log.md` (see template) and stop.

A worker must **never** silently stop with no trace — that's the #1 failure mode
observed in real overnight multi-agent runs (see SKILL.md references).

## Loop directory contract

Every cycle owns exactly one directory: `docs/engineering/loops/loop_<YYYY-MM-DD>-<slug>/`.
That directory holds exactly these files — no others:

- `plan.md` — written once in Step 3, **overwritten in place** if the plan needs revision
- `log.md` — append-only worker status lines
- `summary.md` — written once in Step 7
- `worktrees.json` — optional, tracking active worktree paths

**Forbidden:** `-vN` suffixes (`plan-v2.md`) or `followup-*` files (`followup-plan-v2.md`,
`followup-plan-v3.md`). A revised plan overwrites `plan.md` — it does not spawn a sibling
file. This is not a style preference: the 2026-06-21 loop's `followup-plan-v2`/`v3` sprawl
left three competing plans in one directory with no way to tell which was authoritative.
If a plan needs revising mid-cycle, edit `plan.md` directly (git history preserves the old
version) and note the revision in the plan's own text.

## Docs write-scope

Create or write docs only at the canonical paths in the docs layout contract
(`docs/README.md`): `foundation/`, `reviews/` (+`adr/`), `engineering/{loops,modules,security,ops}`,
`agents/`. Never create a new top-level doc folder, a loose file at `docs/` root, or a
`-vN` filename variant. Findings and backlog go to GitHub issues via `/create-ticket`,
never to a new doc. If nothing fits, ask — do not invent a path.

For `/afk-dev` specifically, this means: all cycle output stays inside
`docs/engineering/loops/loop_<date>-<slug>/` using only the fixed file set above.
