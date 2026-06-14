# create-ticket conventions — single source of truth

Naming, labels, body templates, and filing rules for GitHub issues. Referenced by `/create-ticket`, `/prd-to-issues` (Step 5), `/unslop-repo` (Step 4), and repo docs.

**Terminology:** Call the artifact an **issue** in titles and bodies. The skill name `/create-ticket` is the command only.

---

## Two tracks

| Track | When | Title format | Example |
|-------|------|--------------|---------|
| **Feature** | PRD vertical slices (`/prd-to-issues`) | Project convention — no `BUG-` prefix | `Slice 11 — CSV import` |
| **Review** | E2E review, QA, security, debt, tests, triage, **`/unslop-repo`** | `{PREFIX}-{NN}: {short title}` | `DEBT-34: Relocate GridRow to models/` |

`NN` = backlog pickup order, zero-padded (`01`–`99`). Not a per-prefix counter. For ad-hoc sources (`/unslop-repo`, QA): use next free `NN` per prefix from existing GitHub titles.

---

## Prefix taxonomy (Review track)

| Prefix | Use for | `type:*` label |
|--------|---------|----------------|
| `BUG-` | Defects, data-loss, correctness | `type:bug` |
| `SEC-` | Security findings | `type:security` |
| `DATA-` | Data audits / one-off repairs | `type:bug` (or `type:chore` if decision-only) |
| `DEBT-` | Quality refactors (non-feature) | `type:refactor` |
| `TEST-` | Test coverage gaps | `type:test` |
| `ARCH-` | Cross-cutting structure | `type:refactor` — skip if already shipped |
| `SPIKE-` | Research / decision-only | `type:spike` |

PRD feature slices keep existing titles (`Slice N — …`, `Epic N — …`). Do not rename to `FEAT-NN`.

---

## Labels

Aligns with `/afk-dev` — it reads **labels**, not body text.

| Label | Meaning |
|-------|---------|
| `type:bug` | Defect fix |
| `type:security` | Security hardening |
| `type:refactor` | DEBT / structural quality |
| `type:test` | Test / coverage |
| `type:slice` | PRD vertical slice |
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
| PRD slice | `type:slice`, `module:*`, `priority:must` or `priority:should`, `agent:hitl` or `agent:afk` |

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
- Use project domain language (`docs/CONTEXT.md` if present)
- **Reproduction steps** mandatory for bugs; ask if unknown
- **30-second readability** — concise acceptance criteria
- **Honest Blocked by** — `None — can start immediately` when true
- **Prefer thin issues** over thick ones; maximize parallelism
- Create blockers first so real `#N` refs exist in dependents
- For investigated bugs: optional **TDD Fix Plan** (RED/GREEN cycles)

---

## Body templates

### Feature track (PRD slices)

```markdown
## Context
> From PRD — [relevant user story or section]

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
- [docs/modules/module_*.md or ADR if from /unslop-repo]

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

### Idempotency

Before create, fetch existing titles:

```bash
gh issue list --repo "$REPO" --state all --limit 500 --json title --jq '.[].title'
```

Skip if exact title already exists (open or closed). Log `skip (exists): <title>`.

### Create

```bash
gh issue create --repo "$REPO" --title "<title>" --label "type:bug,module:foundation,priority:must,agent:hitl" --body-file /tmp/body.md
```

- Publish in **dependency order** (blockers first)
- Report each URL; on failure, log error and **continue** — do not abort batch
- Do not close or modify parent issues

---

## Repo overrides (read if present)

| Path | Use |
|------|-----|
| `docs/reviews/README.md` | Review prefix table, shipped-arch skip list |
| `docs/CONTEXT.md` | Domain glossary for titles and bodies |
| `scripts/create_review_issues.sh` | Batch automation reference (idempotent `issue()` helper) |

If repo override conflicts with this file, **repo wins** for numbering and skip rules; labels and agent modes still follow this file unless repo doc explicitly differs.
