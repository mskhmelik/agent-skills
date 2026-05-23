---
name: get-prd
description: >
  Synthesize problem and solution docs into a strict Product Requirements Document (docs/prd.md).
  Use when the user types /get-prd, says "generate the PRD", "create the PRD", or "let's write the PRD".
  Works after /problematize and /solutionize (or repo equivalents). Does not re-interview — reads files,
  asks at most 3 targeted gap questions, produces a PRD with no Open questions section (unresolved items
  live in problem/solution docs only).
---

# /get-prd

Synthesis skill: turn exploration outputs into a commitment document — **what we are building and what we are not**.

This skill **does not** re-run investigation. It reads existing outputs, asks **minimal targeted questions** only to close genuine gaps, then saves **`docs/prd.md`**.

**Strict PRD rule:** the saved PRD must **not** contain an `## Open questions` section. Anything still unresolved belongs in **`docs/problem_summary.md`** and/or **`docs/solution_overview.md`** (see Step 3–4).

**Feedback log:** `feedback.jsonl` lives in the same directory as this `SKILL.md`.

---

## Step 0 — Resolve repository root

Before reading inputs:

1. Start from the **current working directory** (or the workspace root the user indicated).
2. Walk **upward** until you find a directory that contains **`.git`** or **`docs/prd.md`**. Treat that directory as **`REPO_ROOT`**.
3. All relative paths below are under `REPO_ROOT`.

If no root is found, ask the user which folder is the project root and use that as `REPO_ROOT`.

---

## Step 1 — Load inputs

Under `REPO_ROOT`, locate files in this **priority order** (first match wins):

**Problem summary**

1. `docs/problem_summary.md`
2. `problem_summary.md`
3. `problem-summary.md`

**Solution summary**

1. `docs/solution_overview.md`
2. `solution_overview.md`
3. `solution-summary.md`

**Domain context (CONTEXT)**

1. `docs/CONTEXT.md`
2. `CONTEXT.md` (repo root — legacy)

If **neither** problem nor solution file exists, ask once: whether to work from **conversation context only**, or to run the upstream skills first.

If **CONTEXT.md** is missing but solution exists, note in the PRD preamble that glossary terms may be inconsistent — prefer running `/solutionize` again to produce `docs/CONTEXT.md`.

If **only one** exists, use it and note clearly in the PRD preamble (one sentence) which input is missing.

---

## Step 2 — Cross-check alignment

Before synthesising:

- The **problem anchor** in the solution document must align with the **distilled problem** in the problem document.
- If they **diverge**, state the divergence explicitly and ask which framing the PRD should anchor to. **Do not** finalise until confirmed.

---

## Step 3 — Gap check and strict open-items routing

Scan inputs for unresolved load-bearing items:

- Open items, `?`, or undecided options in the solution document
- **What's still open** (or equivalent) in the problem document

For each **genuine** gap: ask **one** targeted question at a time. **Maximum 3 questions** total. Prioritise gaps that change scope or direction.

**Routing rule:** answers and still-unresolved items must be written to **`docs/problem_summary.md`** and/or **`docs/solution_overview.md`** — for example under **What's still open** or **Open questions** there — **not** into the PRD body.

Do not ask about topics explicitly **out of scope** in the solution document.

---

## Step 4 — Produce the PRD

Synthesise into **`docs/prd.md`** using the template below. Every substantive line must be traceable to the problem doc, the solution doc, gap-fill answers, or prior agreed session notes — **do not invent** requirements.

**Output path:** always `docs/prd.md` (create `docs/` if missing).

**Include** a section **`## Build order — vertical slices`** after **User stories** (or after **Success criteria** if stories are long): an **ordered numbered list** of thin vertical slices (each slice is a shippable increment or spike; reference story IDs from the user-stories tables). This list is the default **implementation queue**; user stories remain the **requirements matrix**, not sprint order.

**Omit** `## Open questions` entirely from the PRD.

**Glossary rule:** User stories and Implementation decisions must use canonical terms from **`docs/CONTEXT.md`**. Do not introduce new synonyms. Include a **`## Glossary`** section that links to `CONTEXT.md` and lists the terms used in this PRD (copy only those terms — not the full file).

```markdown
# PRD — [short name]

## Problem statement
One sharp sentence (most specific version from aligned inputs).

## Glossary

Canonical terms — see [CONTEXT.md](CONTEXT.md). Terms used in this PRD:

- **Term** — one-line definition (from CONTEXT)

## Why this matters
2–3 sentences grounded in concrete examples from the problem doc.

## Success criteria
1–4 behavioural "done looks like" statements from the solution doc.
Format: "A user can [do X] without [needing Y]" or "The system [does X] when [condition Y]."

## User stories
Use tables or subsections by area (Foundation, Money, Time, …). Each story: As a …, I can …, so that …
Mark ✓ Confirmed or ~ Proposed. Include IDs for traceability (e.g. F-01, M-M02).

## Build order — vertical slices
1. **[Slice title]** — Outcome in one sentence. Relates to: ID1, ID2, …
2. …

## Implementation decisions
Table or list: We chose [X] over [Y] because [reason]. Only closed decisions.

## Out of scope
Bullet list with one-line reasons.

## Constraints
Technical, platform, product, or organisational limits.

## Testing approach
Key scenarios derived from success criteria and concrete problem examples — behaviours, not implementation detail.
```

---

## Step 5 — Review and confirm

Present the draft PRD (or summary if too long) and ask whether anything is wrong, missing, or must be tightened **before save**.

Incorporate adjustments.

---

## Step 6 — Save

Write the final PRD to **`docs/prd.md`**, overwriting if present.

Tell the user: **Saved to `docs/prd.md`.**

---

## Step 7 — Skill feedback (mandatory)

**Always** run this step after Step 6.

1. Ask how this skill performed, with exactly two options:
   - **+1 — worked well**
   - **-1 — something went wrong**
2. If the user chooses **-1**, also ask: **"What went wrong?"** (they may decline to type detail; still append the line with `comment: null` if no text).
3. Append **one JSON line** to **`feedback.jsonl` in the same directory as this `SKILL.md`** (create the file if it does not exist). Use ISO 8601 UTC for `ts`. Set `runtime` to **`"cursor"`** or **`"claude"`** depending on which product is running the agent.

```json
{"ts":"2026-05-10T12:00:00.000Z","rating":1,"comment":null,"runtime":"cursor"}
```

`rating` must be **1** or **-1**.

4. If **-1**: state that the maintainer should use `comment` to improve this `SKILL.md` (self-annealing).

---

## What NOT to do

- Do not re-interview beyond the 3-question gap cap.
- Do not invent user stories or decisions not grounded in inputs or gap-fill.
- Do not ship a PRD with an `## Open questions` section — that belongs in problem/solution docs only.
- Do not include ruled-out directions as committed scope.
- Do not invent glossary terms — use `CONTEXT.md` or flag missing context file.
