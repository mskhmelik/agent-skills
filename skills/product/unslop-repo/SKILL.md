---
name: unslop-repo
description: >
  Find deepening opportunities in a codebase — shallow modules, seam leakage, untestable areas.
  Informed by docs/CONTEXT.md (domain) and docs/adr/. Architectural prose uses this skill's LANGUAGE.md.
  Use when the user types /unslop-repo, "unslop repo", wants architecture review, refactoring
  opportunities, or to make a codebase more testable and AI-navigable.
user-invocable: true
allowed-tools: [Bash, Read, Write, Edit, Agent, AskUserQuestion]
---

# /unslop-repo

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

Adapted from [mattpocock/skills improve-codebase-architecture](https://github.com/mattpocock/skills/tree/main/skills/engineering/improve-codebase-architecture).

## Two vocabularies — do not conflate

| Source | Layer | Use for |
|--------|-------|---------|
| **`docs/CONTEXT.md`** | Domain / product | Module names in reports ("Order intake module", not `FooBarHandler`) |
| **[LANGUAGE.md](LANGUAGE.md)** (this skill) | Architecture | How you describe structure (depth, seam, leverage, locality) |

## Glossary (architecture)

Use these terms exactly in every suggestion. Full definitions in [LANGUAGE.md](LANGUAGE.md).

- **Module** — anything with an interface and an implementation
- **Interface** — everything a caller must know to use the module
- **Depth** — leverage at the interface; **deep** vs **shallow**
- **Seam** — where an interface lives (not "boundary")
- **Adapter** — concrete thing satisfying an interface at a seam
- **Leverage** — what callers get from depth
- **Locality** — what maintainers get from depth

Key principles: **deletion test** · **interface is the test surface** · **one adapter = hypothetical seam; two = real seam**

---

## Prerequisites

If `docs/` is missing, stop and suggest **`/init-docs`** first.

**Phase 1 read order:**

1. `docs/README.md`
2. **`docs/CONTEXT.md`** (fallback: repo-root `CONTEXT.md`)
3. `docs/solution_overview.md`
4. `docs/prd.md` — scope boundary; flag refactors outside PRD
5. `docs/adr/*.md` — do not re-litigate unless friction warrants reopening
6. `docs/modules/module_*.md` if present

---

## Process

### 1. Explore

Read domain glossary and ADRs first (see read order above).

Spawn an explore subagent:
- **Cursor:** Task tool with `subagent_type=explore`
- **Claude Code:** Agent tool with `subagent_type=Explore`

Walk the codebase organically. Note friction:

- Understanding one concept requires bouncing between many small modules
- Modules **shallow** — interface nearly as complex as the implementation
- Pure functions extracted for testability, but bugs hide in how they're called (no **locality**)
- Tight coupling **leaking across seams**
- Untested or hard-to-test areas

Apply the **deletion test** on suspects.

### 2. Present candidates as an HTML report

Write a self-contained HTML file to the OS temp directory — **nothing lands in the repo**.

Resolve temp dir from `$TMPDIR`, falling back to `/tmp` (or `%TEMP%` on Windows). Write to `$TMPDIR/architecture-review-<timestamp>.html`.

Open for the user — `open <path>` on macOS, `xdg-open` on Linux, `start` on Windows. Tell them the absolute path.

Tailwind + Mermaid via CDN. Each candidate is a card with files, problem, solution, benefits, before/after diagram, recommendation badge (`Strong` | `Worth exploring` | `Speculative`).

**Use `docs/CONTEXT.md` for domain names and [LANGUAGE.md](LANGUAGE.md) for architecture.**

ADR conflicts: mark clearly when friction warrants revisiting an ADR.

See [HTML-REPORT.md](HTML-REPORT.md) for scaffold and diagram patterns.

Do NOT propose interfaces yet. Ask: **"Which of these would you like to explore?"**

### 3. Design loop

Once the user picks a candidate, walk the design tree — constraints, seam placement, what hides behind the interface, surviving tests.

**Inline doc updates:**

| Decision | Write to |
|----------|----------|
| New or sharpened domain term | **`docs/CONTEXT.md`** (see [../solutionize/CONTEXT-FORMAT.md](../solutionize/CONTEXT-FORMAT.md)) |
| Load-bearing rejection | Offer ADR in `docs/adr/` ([init-docs ADR format](../init-docs/templates/adr-README.md)) |
| Deep module structure | `docs/modules/module_<name>.md` |
| Ready to implement — **architecture deepening** | Hand off to **`/create-ticket`** → **`/tdd`** or **`/afk-dev`** |
| Ready to implement — **new PRD-scope feature** | Flag `docs/prd.md` scope; hand off to **`/prd-to-issues`** → **`/create-ticket`** → **`/tdd`** |

**Guards:**

- Do not edit `docs/prd.md` scope silently — flag scope impact
- Do not run `/problematize` or `/solutionize` unless the user reveals a product-level mismatch
- Do not create GitHub issues directly — use **`/create-ticket`** (Review track: `DEBT-`/`ARCH-`/`TEST-`/`SPIKE-`)
- Do not use `/prd-to-issues` for pure refactors — that skill is for PRD vertical slices only
- For alternative interfaces: [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md)

Dependency categories and testing: [DEEPENING.md](DEEPENING.md).

### 4. File approved candidates (`/create-ticket`)

After the design loop, when the user confirms which candidates are ready to track on GitHub:

1. Invoke **`/create-ticket`** — do not call `gh issue create` from this skill
2. One thin issue per approved candidate (prefer parallelism over thick issues)
3. **Review track** titles: `DEBT-{NN}: …`, `ARCH-{NN}: …`, `TEST-{NN}: …`, or `SPIKE-{NN}: …` per [create-ticket/CONVENTIONS.md](../create-ticket/CONVENTIONS.md)
4. Bodies use domain terms from **`docs/CONTEXT.md`**; describe seams and behaviors — **no file paths** (Matt Pocock durability)
5. Default **`agent:hitl`**; use `agent:afk` only for well-bounded test-only slices
6. Link refs: `docs/modules/module_*.md`, relevant ADR, or note "from architecture review \<date\>"
7. Present batch for approval before create (create-ticket Step 4)

Then suggest execution: **`/tdd`** for a single issue, or **`/afk-dev`** for a batch of `agent:hitl` deepenings.

---

## Skill feedback

Append one JSON line to **`feedback.jsonl` in the same directory as this `SKILL.md`**:

`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>,"runtime":"cursor"|"claude"}`
