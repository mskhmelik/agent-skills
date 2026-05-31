---
name: handoff
description: Compact the current conversation into a handoff for another agent to pick up.
argument-hint: "What will the next session be used for?"
user-invocable: true
allowed-tools: [Bash, Write, AskUserQuestion]
---

Follow these steps in order. **Do not ask for session feedback until the handoff output is fully shown in chat.**

## Step 1 — Handoff mode

Use `AskUserQuestion` to ask:
> "How much context does the next agent need?"
> - Header: "Handoff mode"
> - Option 1: **Quick** — "Short summary in a copy-paste code block only. No temp file. Use for same-session or small follow-ups."
> - Option 2: **Full** — "Write a temp doc with full context; copy-paste block tells the next agent to read it. Use when handing over large or multi-file work."

If the user passed `$ARGUMENTS`, treat that as what the next session should focus on.

## Step 2 — Build the handoff

### Quick mode

Do **not** create a temp file.

Write a **short** handoff (roughly 15–40 lines) covering only what the next agent needs to act:
- Task / issue number and goal
- Repo path and branch (if relevant)
- Key files touched or to read
- What's done vs what's left
- First concrete step
- Skills to invoke (e.g. `/tdd`, `/diagnose`)

Skip long history, test output dumps, and content already in plans/PRs/issues — link paths or URLs instead.

### Full mode

Write a handoff document with full context: decisions, file map, open questions, test status, links to PRs/issues/plans.

**Save location:** use **only** a temp path from:

```bash
mktemp -t handoff-XXXXXX.md
```

(read the path before writing). **Do not** copy to `docs/` or the repo.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits). Reference them by path or URL.

The in-chat copy-paste block (Step 3) should be **short**: point the next agent at the temp file and give bootstrap info only (cwd, branch, first step, skill). Do not repeat the full doc in chat.

## Step 3 — Report in chat

Always show the handoff copy-paste block as a **fenced markdown code block** (triple backticks) so the user can copy it in one click.

**Quick mode example shape:**

````
```
Hand off: [one-line goal]

Repo: /path/to/repo  Branch: feature-x
Issue: #67 — mixed-type bulk Apply confirmation

Done: bulk edit panel shipped in PR #62
Next: add confirm dialog in bulk_edit_panel.dart when selection spans types but only one tab has edits

Start: read lib/features/money/views/desktop/bulk_edit_panel.dart and AddExpenseSheet bulk tab dirty state
Skill: /tdd
Test: flutter test test/features/money/
```
````

**Full mode example shape:**

````
```
Hand off: [one-line goal]

Read this first: /var/folders/.../handoff-a1b2c3.md

Repo: /path/to/repo  Branch: slice-35-bulk-actions
First step: implement #68 panel overlay in money_desktop_view.dart
Skill: /tdd
```
````

Also tell the user in normal prose (outside the code block):
1. Which mode was used
2. **Full mode only:** the full absolute path to the temp file, plus a 2-sentence summary of what's in it
3. **Quick mode only:** one sentence on what the block contains

**Only after the code block (and full-mode path summary) is displayed**, proceed to Step 4.

## Step 4 — Feedback

Use `AskUserQuestion` to ask:
> "How did this session go?"
> - Header: "Feedback"
> - Option 1: "+1 — productive"
> - Option 2: "-1 — something was off"

If -1, follow up with a free-text question: "What went wrong?" (optional — Enter to skip).
