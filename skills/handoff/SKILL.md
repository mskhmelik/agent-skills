---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
---

Follow these steps in order:

## Step 1 — Next-agent prompt

Use `AskUserQuestion` to ask:
> "Should I include a ready-to-paste prompt for the next agent?"
> - Header: "Next agent prompt"
> - Option 1: "Yes — include it" (description: "Adds a copy-paste block at the end of the handoff the next agent can start from.")
> - Option 2: "No — doc only" (description: "Just the summary, no prompt block.")

## Step 2 — Write the handoff doc

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save it to a path produced by `mktemp -t handoff-XXXXXX.md` (read the file before you write to it).

Suggest the skills to be used, if any, by the next session.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

If the user chose "Yes" in Step 1, append a **Prompt for next agent** section: a self-contained copy-paste block the next agent can use as its opening message, including working directory, repo URL, what to do first, and which skill to invoke.

## Step 3 — Report

Tell the user the path to the saved file and give a 2-sentence summary of what's in it.

If the user chose "Yes" in Step 1, also print the prompt block directly in chat (not just in the file) so the user can copy-paste it into a message box without opening the file.

## Step 4 — Feedback

Use `AskUserQuestion` to ask:
> "How did this session go?"
> - Header: "Feedback"
> - Option 1: "+1 — productive"
> - Option 2: "-1 — something was off"

If -1, follow up with a free-text question: "What went wrong?" (optional — Enter to skip).
