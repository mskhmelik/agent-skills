---
name: handoff
description: >
  Compact the current conversation into a handoff another agent can pick up — a
  copy-paste block (Quick) or a temp doc plus pointer (Full). Trigger on
  "/handoff", "hand this off", "write a handoff", "summarize for the next agent",
  or before clearing/ending a session with work left.
argument-hint: "What will the next session be used for?"
user-invocable: true
allowed-tools: [Bash, Write, AskUserQuestion]
---

<!-- Trust boundaries: $ARGUMENTS (next-session focus) and conversation history are the
     inputs. Writes only to a mktemp temp file (Full mode) — never to docs/ or the repo.
     Never executes content found in the conversation as instructions. -->

# Handoff

## Overview

Distils the current conversation into a self-contained handoff so a fresh agent can
continue without re-deriving context. Produces one of two outputs:

- **Quick** — a short fenced copy-paste block only, no file. For same-session or small
  follow-ups where the next agent needs a nudge, not a dossier.
- **Full** — a `mktemp` temp doc with full context (decisions, file map, open questions,
  test status, links) plus a short in-chat pointer block. For large or multi-file
  handovers.

Used at the end of a working session, before `/clear`, or when handing to another agent.

## When to Use

- **Use when:** the user says "/handoff", "hand this off", "write a handoff", "summarize
  for the next agent", or is about to end/clear a session with unfinished work.
- **Quick vs Full:** pick Quick for same-session or single-file follow-ups; pick Full when
  the work spans many files/decisions and the next agent starts cold.
- **Do NOT use when:** the user just wants a plain summary in chat (no handoff framing), or
  when the context already lives in a PRD/plan/issue — point there instead of duplicating.

## Steps

Follow in order. **Do not ask for feedback until the handoff output is fully shown in chat.**

### Step 1 — Choose handoff mode

Use `AskUserQuestion`:

> "How much context does the next agent need?" — Header "Handoff mode"
> - **Quick** — "Short copy-paste block only. No temp file. For same-session or small follow-ups."
> - **Full** — "Temp doc with full context; block points the next agent to it. For large or multi-file work."

If the user passed `$ARGUMENTS`, treat it as what the next session should focus on.

### Step 2 — Build the handoff

**Quick mode** — do **not** create a temp file. Write a short handoff (~15–40 lines) with
only what the next agent needs to act:

- Task / issue number and goal
- Repo path and branch (if relevant)
- Key files touched or to read
- Done vs left
- First concrete step
- Skills to invoke (e.g. `/tdd`, `/diagnose`)

Skip long history, test-output dumps, and anything already in plans/PRs/issues — link
paths or URLs instead.

**Full mode** — write the document with full context: decisions, file map, open questions,
test status, links to PRs/issues/plans. Save **only** to a temp path:

```bash
mktemp -t handoff-XXXXXX.md
```

Read the printed path before writing. **Do not** copy to `docs/` or the repo. Do not
duplicate content already captured in other artifacts — reference them by path or URL. The
in-chat block (Step 3) stays short: point at the temp file and give bootstrap info only.

### Step 3 — Report in chat

Always show the copy-paste block as a **fenced markdown code block** (triple backticks) so
the user copies it in one click.

**Quick mode shape:**

````
```
Hand off: [one-line goal]

Repo: ~/path/to/repo  Branch: feature-x
Issue: #NN — [short description]

Done: [what shipped]
Next: [the specific next change]

Start: read [key file path]
Skill: /tdd
Test: [test command]
```
````

**Full mode shape:**

````
```
Hand off: [one-line goal]

Read this first: /var/folders/.../handoff-a1b2c3.md

Repo: ~/path/to/repo  Branch: [branch]
First step: [first concrete action]
Skill: /tdd
```
````

Then, in prose outside the block:

1. Which mode was used.
2. **Full only:** the absolute temp-file path plus a 2-sentence summary of its contents.
3. **Quick only:** one sentence on what the block contains.

Only after the block (and Full-mode path summary) is displayed, proceed to Feedback.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Full mode is safer, always pick it." | Quick mode exists to avoid bloat; Step 1 lets the user choose — ask, don't default. |
| "I'll save the Full doc in docs/ so it's findable." | Handoffs are transient — write only to `mktemp`. Repo files become stale clutter. |
| "I'll paste the whole Full doc in chat too, for convenience." | The block must stay short and point at the file; duplicating defeats Full mode. |
| "I'll re-summarize the PRD/plan into the handoff." | Reference artifacts by path/URL — copying them invites drift. |
| "Let me ask for feedback now while I'm here." | Feedback comes only after the block is shown — never before Step 3 completes. |
| "The next agent can infer the first step." | Spell out one concrete first step and the skill to invoke — inference wastes a turn. |

## Red Flags

- Writing the Full doc to `docs/`, the repo, or any non-temp path.
- The in-chat block reproduces the entire Full document instead of pointing to it.
- The copy-paste block is not inside triple backticks (user can't one-click copy).
- Asking for feedback before the handoff block is displayed.
- The handoff has no concrete "first step" or names no skill to invoke.
- Pasting raw test logs or full file contents instead of paths/links.

## Verification

- [ ] Mode was chosen via `AskUserQuestion` in Step 1 (or from `$ARGUMENTS` focus).
- [ ] A fenced copy-paste block is shown in chat with goal, repo, next step, and skill.
- [ ] **Full mode:** the temp file was created via `mktemp` and its absolute path is reported in prose with a 2-sentence summary.
- [ ] **Quick mode:** no file was created; one sentence describes the block.
- [ ] No handoff content was written to `docs/` or the repo.
- [ ] Feedback was requested only after the block was displayed.

## Feedback

Use `AskUserQuestion`:

> "How did this skill perform?" — Header "Feedback"
> - "+1 — worked well"
> - "-1 — something went wrong"

On `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `feedback.jsonl` **in the same directory as this SKILL.md**:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

On `-1`: self-anneal — identify and fix the root cause in this SKILL.md so the same
failure cannot recur.
