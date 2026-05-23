---
name: init-docs
description: >
  Scaffold a repo docs/ folder (problem, solution, PRD, ADR, workflow README) so
  product skills and dev agents stay aligned. Use when the user types /init-docs,
  "init docs", "set up docs folder", or starts a new repo and needs the standard
  documentation layout before /problematize, /solutionize, or /get-prd.
user-invocable: true
---

# /init-docs

Creates the **standard `docs/` layout** for a repo so exploration → PRD → issues → TDD does not derail mid-dev.

Skills that consume this layout: **`/problematize`**, **`/solutionize`**, **`/get-prd`**, **`/prd-to-issues`**, **`/tdd`**, **`/diagnose`**, **`/unslop-repo`**.

Templates live beside this skill: [`templates/`](templates/).

---

## Step 0 — Resolve repository root

1. Start from the current working directory (or workspace root).
2. Walk upward until you find **`.git`**. That directory is **`REPO_ROOT`**.
3. If no git root, ask the user which folder is the project root.

All paths below are under `REPO_ROOT`.

---

## Step 1 — Explore existing docs

List what already exists under `docs/` and at repo root (`problem-summary.md`, `docs/prd.md`, etc.).

**If `docs/README.md` already exists and describes this workflow:** ask whether to **skip**, **merge**, or **overwrite** templates only.

---

## Step 2 — Confirm with user

Ask once (unless user said "just scaffold"):

> "I'll create the standard docs/ layout (problem → solution → PRD → ADRs). Overwrite empty templates only, or also refresh README?"

Default: create missing files; do not overwrite non-empty `problem_summary.md`, `solution_overview.md`, `CONTEXT.md`, or `prd.md`.

---

## Step 3 — Scaffold

Create directories if missing:

```
docs/
├── README.md              ← workflow hub (from templates/docs-README.md)
├── problem_summary.md     ← /problematize output (template if new)
├── solution_overview.md   ← /solutionize output (template if new)
├── CONTEXT.md             ← /solutionize domain glossary (template if new)
├── prd.md                 ← /get-prd output (stub if new)
├── adr/
│   └── README.md          ← when to write ADRs
└── agents/
    └── README.md          ← optional per-repo agent pointers
```

Copy from `templates/` in this skill directory:

| Output | Template file |
|--------|---------------|
| `docs/README.md` | `docs-README.md` |
| `docs/problem_summary.md` | `problem_summary.md` |
| `docs/solution_overview.md` | `solution_overview.md` |
| `docs/CONTEXT.md` | `CONTEXT.md` |
| `docs/prd.md` | `prd-stub.md` |
| `docs/adr/README.md` | `adr-README.md` |
| `docs/agents/README.md` | `agents-README.md` |
| `AGENTS.md` (optional) | `AGENTS.md` |

Replace `{{PROJECT_NAME}}` with repo folder name or user-provided title.

Domain glossary lives in **`docs/CONTEXT.md`** (filled by `/solutionize`).

---

## Step 4 — Repo pointer (optional)

If **`AGENTS.md`** is missing at repo root, offer to create a minimal stub from `templates/AGENTS.md` pointing to:

- `docs/README.md` for product workflow
- `~/.cursor/skills` (OneDrive `5_projects/ai/skills`) for slash commands
- `5_projects/ai/rules/` for generic debugging/docs rules

---

## Step 5 — Report

Tell the user:

1. What was created vs skipped (already existed)
2. **Next steps:** `/problematize` → `/solutionize` (writes `CONTEXT.md`) → `/get-prd` → `/prd-to-issues` → `/tdd`
3. For bugs during dev: `/diagnose` (not ad-hoc debug logs)

Append feedback to `feedback.jsonl` in this skill directory.

---

## What NOT to do

- Do not overwrite filled problem/solution/PRD files without explicit consent
- Do not invent product content — templates are placeholders only
