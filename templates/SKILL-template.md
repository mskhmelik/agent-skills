---
name: <skill-name>
description: <one-line — shown in system-reminder; describes WHEN Claude/Cursor should trigger this skill>
argument-hint: <optional: e.g. <url> or <query>>
---

## Purpose
[What this skill does and why. Keep it short — 2-3 sentences.]

## Step 1 — [Action]

[Instructions for the agent.]

## Step 2 — [Action]

[Instructions for the agent.]

## Step N — Confirm success

Tell the user what was done and where to find any output.

---

## Skill Evaluation

At the very end, use `AskUserQuestion` to ask:

> "How did this skill perform?"
>
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If they select `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `~/.claude/skills/<skill-name>/feedback.jsonl`:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

For `-1` ratings: trigger self-annealing — identify and fix the root cause described in the comment.
