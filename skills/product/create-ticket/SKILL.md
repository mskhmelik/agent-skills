---
name: create-ticket
user-invocable: true
allowed-tools: [Bash, Read, Write, AskUserQuestion]
description: >
  File one or more GitHub issues with unified prefix taxonomy, PRD-aligned labels,
  and HITL/AFK agent mode. Use for /create-ticket, review backlogs, QA findings,
  unslop-repo architecture candidates, or when prd-to-issues delegates issue creation.
  Never batch-create without approval.
argument-hint: "[source doc path, backlog row, or issue draft]"
---

# /create-ticket

Canonical GitHub **issue** filing layer: naming, labels, durable bodies, `gh` create, idempotency.

**Does not own:** PRD slicing (`/prd-to-issues`), architecture review (`/unslop-repo`), bug investigation (`/diagnose`). Those skills hand off here for filing.

**Conventions:** [CONVENTIONS.md](CONVENTIONS.md) — read before drafting any issue.

---

## Step 1 — Resolve repo and overrides

Run `gh repo view --json nameWithOwner`. On failure: tell user to run from a git repo with GitHub remote or `gh auth login`. Stop.

Read if present (do not invent):

- `docs/reviews/README.md` — review prefix table, shipped-arch skip list (GitHub is tracker; no backlog markdown)
- `docs/CONTEXT.md` — domain language
- Conversation context or `$ARGUMENTS` — source doc, backlog row, QA notes

---

## Step 2 — Classify track and prefix

| Source | Track | Title |
|--------|-------|-------|
| `/prd-to-issues` approved slice | **Feature** | `Slice N — …` or project convention |
| `/unslop-repo` approved deepening | **Review** | `{PREFIX}-{NN}: {short title}` — see prefix map below |
| E2E review / backlog markdown | **Review** | `{PREFIX}-{NN}: {short title}` |
| Manual QA / single triage | **Review** or **Bug triage** body | Prefix if part of numbered backlog; else descriptive title |
| Post-`/diagnose` filing | **Bug triage** template | `BUG-{NN}:` if backlog slot exists |

**Prefix map for `/unslop-repo` candidates:**

| Deepening type | Prefix | Labels (typical) |
|----------------|--------|------------------|
| Seam / module refactor | `DEBT-` or `ARCH-` | `type:refactor`, `module:*`, `priority:should`, `agent:hitl` |
| Testability gap | `TEST-` | `type:test`, `module:*`, `priority:should`, `agent:hitl` |
| Decision / spike before refactor | `SPIKE-` | `type:spike`, `module:*`, `priority:should`, `agent:hitl` |
| New user-facing capability (PRD scope) | — | Hand back to `/prd-to-issues` (Feature track), not Review |

For unslop-sourced issues without a backlog row: assign `{PREFIX}-{NN}` as next free number — scan `gh issue list --state all` for max `NN` per prefix.

**Prefix decision (Review track):**

| Finding | Prefix |
|---------|--------|
| Defect / data-loss / correctness | `BUG-` |
| Security | `SEC-` |
| Data audit / one-off repair | `DATA-` |
| Refactor / readability | `DEBT-` |
| Missing tests | `TEST-` |
| Cross-cutting structure | `ARCH-` (skip if shipped per repo doc) |
| Research only | `SPIKE-` |

Skip items marked shipped in repo backlog (log `skip (shipped): … → GitHub #N`).

---

## Step 3 — Draft title, labels, body, mode

For each issue:

1. **Title** — per track rules in [CONVENTIONS.md](CONVENTIONS.md)
2. **Labels** — one each: `type:*`, `module:*`, `priority:*`, `agent:hitl` or `agent:afk`
3. **Body** — Feature, Review, or Bug triage template from CONVENTIONS.md
4. **Mode** — HITL default for bugs/security/data-loss; AFK only when well-bounded

Apply **durability rules**: behaviors not file paths; reproduction steps for bugs; 30-second readability.

---

## Step 4 — Approval (batch only)

**Single issue:** confirm title + labels with user only if ambiguous; otherwise file and share URL.

**Batch (2+ issues):** present full plan before creating:

```
## Proposed Issues

### 1. PREFIX-01: Title
- **Track:** Feature | Review
- **Labels:** type:…, module:…, priority:…, agent:…
- **Mode:** HITL | AFK
- **Blocked by:** …
- **Acceptance criteria:** …
```

Ask: "Approve this breakdown? Split, merge, rename, or reorder anything?"

Do not create until user confirms.

---

## Step 5 — Ensure labels and idempotency

```bash
GITHUB_REPO=<owner/repo> bash <skill-dir>/scripts/ensure-labels.sh
```

Fetch existing titles:

```bash
gh issue list --repo "$REPO" --state all --limit 500 --json title --jq '.[].title'
```

Skip exact title matches (open or closed). Log `skip (exists): <title>`.

---

## Step 6 — Create issues

Publish in **dependency order** (blockers first).

```bash
gh issue create --repo "$REPO" --title "<title>" --label "<comma-separated>" --body-file <file>
```

Report each URL. On `gh` failure: log error, continue remaining issues.

End with summary:

```
## Issues Created
1. [Title] — [URL]
…

Execution order: …
AFK: …
HITL: …
Skipped (exists/shipped): …
```

---

## Step 7 — Feedback

Use `AskUserQuestion`:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If `-1`, ask optional follow-up. Append to `feedback.jsonl` beside this SKILL.md:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

For `-1`: self-anneal — fix root cause in SKILL.md or CONVENTIONS.md.

---

## What NOT to do

- Do not batch-create without explicit approval
- Do not use `needs-triage` on agent-ready issues
- Do not use `area:*` or `priority:critical|high|med|low`
- Do not put file paths or line numbers in bodies (except decision-encoding snippets)
- Do not invent acceptance criteria — pull from source doc or investigation
- Do not abort entire batch on one `gh` failure
- Do not re-file shipped arch items listed in repo `docs/reviews/README.md`
- Do not close or modify parent issues when filing children

---

## Called by other skills

**`/prd-to-issues` Step 5:** Use **Feature track** + label mapping from CONVENTIONS.md. Delegate all `gh issue create` mechanics here.

**`/unslop-repo` Step 4:** After user approves deepening candidates from the architecture review, invoke this skill. Use **Review track** with `DEBT-`/`ARCH-`/`TEST-`/`SPIKE-` per candidate type. Bodies describe behaviors and seams (domain language from `docs/CONTEXT.md`) — no file paths. Ref: `docs/modules/module_*.md` or ADR if written in design loop.

**`/diagnose`:** After fix plan is ready, hand off with **Bug triage** template if user wants a tracked issue.
