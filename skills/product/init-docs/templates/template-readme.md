# {{PROJECT_NAME}} — Documentation

This folder keeps product intent and dev agents aligned. **Read before expanding scope.**
The layout below is **closed** — see the rule at the bottom.

## The flow — two lanes, one gateway

Every piece of work enters through one of two lanes, decided by a single question:
**was this capability ever built?**

- **Never built → Feature lane.** Decisions still need making: interview → spec → tickets.
- **Built and now broken/lacking → Maintenance lane.** History already made the decisions
  ("it used to do X, now does Y" *is* the spec) → straight to a ticket.

Both lanes converge on `/create-ticket` — the **only** skill that runs `gh issue create` —
and on the same dev loop.

```mermaid
flowchart TD
    subgraph FL ["FEATURE LANE — never-built capability"]
        AAP["/ask-about-problems"] --> AAS["/ask-about-solutions"]
        AAS -- writes --> OV["OVERVIEW.md + DICTIONARY.md<br/>(the docs you read)"]
        AAS --> TS["/to-spec<br/>(≤3 gap Qs + seams checkpoint)"]
        TS -- publishes --> SPEC["Spec issue (label: spec)<br/>agent-facing — never reviewed"]
        SPEC --> TT["/to-tickets<br/>(one quiz: granularity + edges)"]
    end

    subgraph ML ["MAINTENANCE LANE — shipped behavior"]
        QA["Manual QA finding"]
        DG["/diagnose — bug root-caused"]
        UR["/unslop-repo — approved deepening"]
    end

    QA -- "regressed / defect" --> CT
    QA -- "never built? → feature lane" --> AAS
    DG --> CT
    UR --> CT
    TT --> CT["/create-ticket<br/>sole gh gateway"]

    CT --> ISS["GitHub issues<br/>SLICE / BUG / DEBT / TEST / SPIKE<br/>blocked-by wired · agent:hitl|afk"]
    ISS --> TDD["/tdd — one issue"]
    ISS --> AFK["/afk-dev — cycle"]
    TDD --> RC["/review-code<br/>standards + spec fidelity"]
    AFK --> RC
    RC --> HM["your manual QA → merge"]
```

## Workflow (in order)

| Step | Skill | Output |
|------|-------|--------|
| 0 | `/init-docs` | This layout (once per repo) |
| 1 | `/ask-about-problems` | [`foundation/OVERVIEW.md`](foundation/OVERVIEW.md) → Problem section |
| 2 | `/ask-about-solutions` | OVERVIEW.md solution sections + [`foundation/DICTIONARY.md`](foundation/DICTIONARY.md) (+ sparing ADRs) |
| 3 | `/to-spec` | **Spec issue on GitHub** (label `spec`) — agent-facing, not reviewed |
| 4 | `/to-tickets` | SLICE tickets, blocked-by wired, children of the spec |
| 5 | `/tdd` or `/afk-dev` | Implementation with tests → PR(s) |
| 6 | `/review-code` | Two-axis review per PR (standards + spec fidelity) |
| 7 | you | Manual QA → merge |
| — | `/diagnose` → `/create-ticket` | Maintenance lane: bugs, regressions |
| — | `/unslop-repo` → `/create-ticket` | Architecture hygiene (periodic) |

## Which lane? (routing rule)

| Situation | Route |
|---|---|
| Manual QA finds shipped behavior broken/regressed | `/create-ticket` (BUG) — directly |
| Manual QA reveals a capability that was never built | Feature lane — usually `/ask-about-solutions` first |
| `/diagnose` root-caused a bug worth tracking | `/create-ticket` (BUG) |
| `/unslop-repo` deepening approved | `/create-ticket` (DEBT/ARCH/TEST/SPIKE) |
| New feature / scope | Full feature lane |

## Where things go

| Content | Path |
|---------|------|
| Problem, system idea, components, workflows, decisions (human-readable) | `foundation/OVERVIEW.md` |
| Canonical domain vocabulary | `foundation/DICTIONARY.md` |
| Committed scope + user stories + seams (agent-facing) | **Spec issue on GitHub**, label `spec` — never a repo doc |
| Hard-to-reverse technical decisions (agent memory) | `reviews/adr/NNN-short-title.md` |
| Shipped-architecture record | `reviews/README.md` |
| One-off analysis / review write-ups | `reviews/<date>-<topic>.md` |
| `/afk-dev` cycle plans, logs, summaries | `engineering/loops/` |
| Module deep dives | `engineering/modules/<name>.md` |
| Security-relevant docs | `engineering/security/` |
| Build, dev, tooling docs | `engineering/ops/` |
| Repo-specific notes for AI agents (issue tracker, launch configs) | `agents/README.md` |
| Findings / backlog items | a GitHub issue via `/create-ticket` — never a new doc |

## File roles

- **`foundation/OVERVIEW.md`** — THE human-readable doc: problem → system idea & key
  components → key user workflows → decisions → out of scope. 5-minute read, always current.
- **`foundation/DICTIONARY.md`** — canonical terms; OVERVIEW component names and all
  tickets use these exactly.
- **`reviews/adr/`** — one-paragraph decision records, written by agents when a decision
  is hard-to-reverse + surprising + a real trade-off. Agents read them to avoid
  re-litigating; humans get the one-line version in OVERVIEW.md Decisions.
- **`agents/README.md`** — repo-specific notes for AI agents.
- **`engineering/loops/`** — `/afk-dev` cycle artifacts. Worker sandboxes: `.worktrees/` (gitignored).

## During development

- **Scope drift:** if the change isn't traceable to a spec issue or OVERVIEW.md, stop —
  route through the correct lane first.
- **Bugs:** `/diagnose` — failing test at the correct UI seam, not session log files.
- **Manual QA:** checklists live at `docs/engineering/ops/manual-qa-*.md`; findings route
  per the table above.

## Closed-layout rule

This layout is **closed**: every doc lives at one of the paths above. Never create a new
top-level doc folder, a loose file at `docs/` root, or a `-vN` filename variant. Specs
are GitHub issues, findings and backlog items are GitHub issues via `/create-ticket` —
never new docs. If nothing fits, ask — do not invent a path.

## Naming rule

All filenames are **kebab-case**, except `README.md`, `OVERVIEW.md`, and `DICTIONARY.md`
which keep their conventional all-caps names.
