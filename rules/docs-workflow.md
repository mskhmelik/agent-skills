# Documentation workflow (all repos)

Keeps agents and humans aligned. **Two lanes, one gateway** — the lane is chosen by one
question: *was this capability ever built?*

- **Never built → Feature lane:** interview → spec → tickets.
- **Built and now broken/lacking → Maintenance lane:** straight to a ticket (history
  already made the decisions).

## Standard layout

Created by **`/init-docs`**. Repo docs are **human-readable only** — specs and tickets
live on GitHub, never as repo files:

```
docs/
├── README.md                     ← the flow + closed-layout contract; start here
├── foundation/
│   ├── OVERVIEW.md               ← THE human doc: problem → system idea & components → workflows → decisions
│   └── DICTIONARY.md             ← canonical domain terms
├── reviews/
│   └── adr/                      ← one-paragraph decision records (agent-facing)
├── engineering/{loops,modules,security,ops}   ← extended into lazily
└── agents/README.md              ← repo-specific agent notes (tracker, launch config)
```

## Rules during development

1. **Read `docs/foundation/OVERVIEW.md`** (and the issue's parent `spec` issue) before
   non-trivial changes. If the work isn't traceable to OVERVIEW.md or a spec/ticket,
   stop — route through the correct lane first.
2. **Specs are agent-facing GitHub issues** (label `spec`), produced by `/to-spec`. The
   user reads OVERVIEW.md, not the spec.
3. **Open questions** live in OVERVIEW.md, never in a spec.
4. **Do not re-interview** the problem/solution during implementation — read the docs.
5. **Module deep dives** go in `docs/engineering/modules/`; link, don't duplicate scope.
6. **ADRs** only for hard-to-reverse, surprising, real-trade-off decisions
   (`docs/reviews/adr/`); the human-readable line lives in OVERVIEW.md Decisions.

## Skill chains

```
Feature lane:
  /init-docs → /ask-about-problems → /ask-about-solutions → /to-spec → /to-tickets
             → /create-ticket → /tdd | /afk-dev → /review-code → manual QA → merge

Maintenance lane:
  /diagnose (bug)  ┐
  manual QA finding ├→ /create-ticket → /tdd → /review-code → merge
  /unslop-repo      ┘
```

`/create-ticket` is the **only** skill that runs `gh issue create` — both lanes converge
on it.

## New repo checklist

- [ ] Run `/init-docs`
- [ ] Fill OVERVIEW.md (problem → solution) via the interviews before large builds
- [ ] Add `docs/agents/README.md` with issue tracker and launch notes
- [ ] Wire Cursor: symlink from `5_projects/ai/` — [README Setup](https://github.com/mskhmelik/agent-skills#setup-once-per-machine) (one-liner loop)
