# Documentation workflow (all repos)

Keeps agents and humans aligned. **Problem → solution → PRD → issues → code.**

## Standard layout

Created by **`/init-docs`**:

```
docs/
├── README.md              ← start here
├── problem_summary.md     ← /problematize
├── solution_overview.md   ← /solutionize
├── prd.md                 ← /get-prd (committed scope)
├── adr/
├── agents/                ← repo-specific agent notes
└── manual_qa_*.md         ← HITL checklists when needed
```

## Rules during development

1. **Read `docs/prd.md`** before non-trivial changes. If the work isn't traceable to PRD or an issue, stop — update docs or file an issue first.
2. **Open questions stay out of the PRD** — they belong in problem or solution docs (`/get-prd` enforces this).
3. **Do not re-interview** problem space during implementation — read the frozen docs.
4. **Module deep dives** go in `docs/modules/`; link from PRD, don't duplicate scope.
5. **ADRs** only for hard-to-reverse, surprising, trade-off decisions (see `docs/adr/README.md`).

## Skill chain

```
/init-docs  →  /problematize  →  /solutionize  →  /get-prd  →  /prd-to-issues  →  /tdd
                                                                              ↘
                                                                    /diagnose (bugs)
```

## New repo checklist

- [ ] Run `/init-docs`
- [ ] Fill problem → solution → PRD before large builds
- [ ] Add `docs/agents/README.md` with issue tracker and launch notes
- [ ] Wire Cursor: symlink from `5_projects/ai/` — [README Setup](https://github.com/mskhmelik/agent-skills#setup-once-per-machine) (one-liner loop)
