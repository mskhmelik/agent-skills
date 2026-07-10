# create-ticket conventions — single source of truth

Naming, labels, body templates, PR conventions, and filing rules for GitHub issues.
Referenced by `/create-ticket`, `/to-tickets` (Step 4), `/unslop-repo` (Step 4), and repo docs.

**Terminology:** Call the artifact an **issue** in titles and bodies. The skill name `/create-ticket` is the command only.

---

## Ticket ID = GitHub issue `#N`

**Issue title:** `{PREFIX}-{N}: {short title}` where **N = GitHub issue number** (integer as assigned by GitHub, no zero-padding).

Examples: `BUG-284: Filter bar mirrors…`, `SLICE-290: CSV import`, `SPIKE-283: Planned transactions…`

**`PREFIX-N` and `#N` are the same ticket ID** — interchangeable in conversation and links.

GitHub assigns `#N` at creation; you cannot know `N` beforehand. Filing flow: **create → finalize (rename + project)** via `scripts/finalize-issue.sh`.

Do **not** scan titles for max `NN` per prefix — the number is always the GitHub issue number.

---

## Two tracks

| Track | When | Title format | Example |
|-------|------|--------------|---------|
| **Feature** | Spec vertical slices (`/to-tickets`) | `{SLICE}-{N}: {short title}` | `SLICE-290: CSV import` |
| **Review** | E2E review, QA, security, debt, tests, triage, **`/unslop-repo`** | `{PREFIX}-{N}: {short title}` | `DEBT-285: Scrollbar fade styling` |

Spec slice order (`Slice 11`, etc.) belongs in the issue body **Context** only — not in the title.

---

## Prefix taxonomy (Review track)

| Prefix | Use for | `type:*` label |
|--------|---------|----------------|
| `BUG-` | Defects in **shipped** behavior, data-loss, correctness regressions | `type:bug` |
| `SEC-` | Security findings | `type:security` |
| `DATA-` | Data audits / one-off repairs | `type:bug` (or `type:chore` if decision-only) |
| `DEBT-` | Quality refactors (non-feature) | `type:refactor` |
| `TEST-` | Test coverage gaps | `type:test` |
| `ARCH-` | Cross-cutting structure | `type:refactor` — skip if already shipped |
| `SPIKE-` | Research / decision-only | `type:spike` |

Feature track uses **`SLICE-`** prefix with `type:slice` label.

**Bug vs. feature:** `BUG-` is only for behavior that was built and now misbehaves. A capability that was never implemented — even one users expect or that a doc promises — is **missing scope**, so it belongs on the Feature track (`SLICE-`, `type:slice`), not `BUG-`. Tie-breaker: a *fix* repairs existing code; a *feature* adds a new code path, table, or endpoint.

---

## PR conventions

PR **system number** (GitHub auto, e.g. `#291`) is not controllable and will not equal the issue number. That is expected.

| Field | Rule | Example |
|-------|------|---------|
| **PR title** | Copy issue title exactly | `BUG-284: Filter bar mirrors visible column order` |
| **PR body** | `Closes #N` first line, then Summary + Test plan | `Closes #284` |
| **Branch** | `afk/{N}-{slug}` | `afk/284-filter-bar` |
| **PR system #** | Use for `gh pr merge`, CI only | PR `#291` |

### Citation rules (agents + humans)

**Issues:** cite as **`PREFIX-N — short title`** (equals `#N`). Never bare `#N` without title in summaries.

**PRs:** cite as **`PR #291 — BUG-284: short title`**. Never bare `PR #291` alone.

- Ticket ID (`BUG-284` / `#284`) = what the work is
- PR `#` = plumbing for merge/checkout only

```bash
gh pr create --title "BUG-284: Filter bar mirrors visible column order" \
  --body "$(cat <<'EOF'
Closes #284

## Summary
- …

## Test plan
- [ ] …
EOF
)"
```

---

## GitHub Projects (module boards)

Each filed issue is added to the module Project (Status = Backlog). See repo `docs/agents/README.md` and `docs/engineering/projects.json`.

| Project | `module:*` label(s) |
|---------|---------------------|
| Money | `module:money` |
| Health | `module:health` |
| Time | `module:time` |
| Wellbeing | `module:wellbeing` |
| Foundation | `module:foundation`, `module:cross-cutting`, `module:intelligence` |

Status workflow: Backlog → Ready → In progress → In review → Done

---

## Labels

Aligns with `/afk-dev` — it reads **labels**, not body text.

| Label | Meaning |
|-------|---------|
| `type:bug` | Defect fix |
| `type:security` | Security hardening |
| `type:refactor` | DEBT / structural quality |
| `type:test` | Test / coverage |
| `type:slice` | Spec vertical slice |
| `type:spike` | Spike / decision-only |
| `module:foundation` | Sync, auth, core, security |
| `module:money` | Money module |
| `module:time` / `module:health` / … | Other modules as used in repo |
| `priority:must` | P0 / P1 — fix before trusting production |
| `priority:should` | P2 / P3 — important but not blocking |
| `agent:hitl` | Agent opens PR; human reviews before merge (**default**) |
| `agent:afk` | Agent may run autonomously |
| `needs-triage` | **Avoid** on agent-ready issues |

**Every filed issue gets:** one `type:*`, one `module:*`, one `priority:*`, one `agent:*`.

Do **not** use parallel schemes (`area:*`, `priority:critical|high|med|low`).

### Label recipes (Review track)

| Situation | Labels |
|-----------|--------|
| P0 sync/db bug | `type:bug`, `module:foundation`, `priority:must`, `agent:hitl` |
| P1 sync bug | `type:bug`, `module:foundation`, `priority:must`, `agent:hitl` |
| P2 money bug | `type:bug`, `module:money`, `priority:should`, `agent:hitl` |
| Security (must) | `type:security`, `module:foundation`, `priority:must`, `agent:hitl` |
| Security (should) | `type:security`, `module:foundation`, `priority:should`, `agent:hitl` |
| DEBT | `type:refactor`, `module:money` or `module:foundation`, `priority:should`, `agent:hitl` |
| TEST | `type:test`, `module:*`, `priority:should`, `agent:hitl` |
| Spec slice | `type:slice`, `module:*`, `priority:must` or `priority:should`, `agent:hitl` or `agent:afk` |

---

## HITL vs AFK

| Mode | Label | When |
|------|-------|------|
| **HITL** | `agent:hitl` | Default for bugs, security, data-loss, auth, schema migrations, UX ambiguity |
| **AFK** | `agent:afk` | Isolated, clear pass/fail, no prod-touching decisions, no external deps |

Body must include `- **Mode:** HITL` or `- **Mode:** AFK`. Label must match.

Prefer AFK where safe; default HITL when uncertain.

---

## Durability rules (Matt Pocock)

Issues should still make sense after major refactors.

- Describe **end-to-end behaviors**, not layer-by-layer tasks
- **No file paths or line numbers** (exception: prototype snippets encoding a decision — state machine, schema shape)
- Use project domain language (`docs/foundation/DICTIONARY.md` if present)
- **Reproduction steps** mandatory for bugs; ask if unknown
- **30-second readability** — concise acceptance criteria
- **Honest Blocked by** — `None — can start immediately` when true
- **Prefer thin issues** over thick ones; maximize parallelism
- Create blockers first so real `#N` refs exist in dependents
- For investigated bugs: optional **TDD Fix Plan** (RED/GREEN cycles)

---

## Body templates

### Feature track (spec slices)

```markdown
## Context
> From spec — [relevant user story ID; link the parent spec issue if applicable]

## Acceptance Criteria
- [ ] …

## Out of Scope for This Issue
- …

## QA Notes
- …

## Notes
- **Mode:** HITL | AFK
- **Blocks:** [issue titles or #N]
- **Blocked by:** [issue titles or #N, or "None — can start immediately"]
```

### Review track (backlog / QA / review / unslop)

```markdown
## Context
> From e2e review — **FINDING-ID** (YYYY-MM-DD)
[Or: From QA — brief description]
[Or: From architecture review — **candidate name**; seam/deepening target in domain terms]

## Acceptance Criteria
- [ ] …

## Out of Scope
- …

## Ref
- [source doc path]
- [backlog row if applicable]
- [docs/engineering/modules/*.md or ADR if from /unslop-repo]

## Notes
- **Mode:** HITL | AFK
- **Finding:** FINDING-ID or unslop candidate name
- **Blocks / Blocked by:** …
```

### Bug triage (after investigation)

```markdown
## Problem
- **Actual:** …
- **Expected:** …
- **Reproduce:** …

## Root Cause Analysis
[Behavior-level — modules and contracts, not file:line]

## TDD Fix Plan
1. **RED:** … **GREEN:** …
2. **RED:** … **GREEN:** …

**REFACTOR:** …

## Acceptance Criteria
- [ ] …
- [ ] All new tests pass
- [ ] Existing tests still pass

## Notes
- **Mode:** HITL | AFK
- **Blocked by:** …
```

---

## Filing mechanics

### Ensure labels

```bash
bash "$(dirname "$0")/scripts/ensure-labels.sh"   # from skill dir
# or pass repo:
GITHUB_REPO=owner/repo bash …/ensure-labels.sh
```

### Ensure projects (once per repo, or after new module)

```bash
GITHUB_REPO=owner/repo REPO_ROOT=/path/to/repo bash …/scripts/ensure-projects.sh
```

Writes `docs/engineering/projects.json` in the repo.

### Idempotency

Before create, fetch existing titles:

```bash
gh issue list --repo "$REPO" --state all --limit 500 --json title --jq '.[].title'
```

Skip if exact **final** title already exists (open or closed). Log `skip (exists): <title>`.

### Create + finalize

```bash
# 1. Create with short title (no PREFIX-N yet)
gh issue create --repo "$REPO" --title "DRAFT: Filter bar mirrors visible column order" \
  --label "type:bug,module:money,priority:should,agent:hitl" --body-file /tmp/body.md

# 2. Parse issue number N from output URL

# 3. Finalize: rename + add to module Project
bash scripts/finalize-issue.sh "$N" BUG "Filter bar mirrors visible column order" module:money
```

- Publish in **dependency order** (blockers first)
- Report each URL as **`PREFIX-N — title`**
- On failure, log error and **continue** — do not abort batch
- Do not close or modify parent issues

---

## Repo overrides (read if present)

| Path | Use |
|------|-----|
| `docs/reviews/README.md` | Shipped-architecture skip list (do not re-file) |
| `docs/foundation/DICTIONARY.md` | Domain glossary for titles and bodies |
| `docs/engineering/projects.json` | Module Project numbers for finalize script |
| `docs/agents/README.md` | Project board workflow |

If repo override conflicts with this file, **repo wins** for numbering and skip rules; labels and agent modes still follow this file unless repo doc explicitly differs.
