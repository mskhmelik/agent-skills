---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
user-invocable: true
allowed-tools: [Bash, Write, AskUserQuestion]
---

Follow these steps in order. **Do not ask for session feedback until Step 3 is fully complete** (summary, file path, and prompt block if any are all shown in chat).

## Step 1 — Next-agent prompt

Use `AskUserQuestion` to ask:
> "Should I include a ready-to-paste prompt for the next agent?"
> - Header: "Next agent prompt"
> - Option 1: "Yes — include it" (description: "Adds a copy-paste block at the end of the handoff the next agent can start from.")
> - Option 2: "No — doc only" (description: "Just the summary, no prompt block.")

## Step 2 — Write the handoff doc

Write a handoff document summarising the current conversation so a fresh agent can continue the work.

**Save location:** use **only** a temp path from:

```bash
mktemp -t handoff-XXXXXX.md
```

(read the path before writing). **Do not** copy to `docs/` or the repo — temp files are the source of truth for the next session.

Suggest the skills to be used, if any, by the next session (e.g. `/diagnose` for bugs, `/tdd` for issues, `/init-docs` for new repos, `/get-prd` for scope).

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

If the user chose "Yes" in Step 1, append a **Prompt for next agent** section inside the handoff file. That prompt **must** include the **full absolute path** to this temp handoff file (e.g. `/var/folders/.../handoff-XXXXXX.md.xYz123`) so the next agent can read it directly. Also include working directory, repo URL, what to do first, and which skill to invoke.

## Step 3 — Report (complete before Step 4)

1. Tell the user the **full absolute path** to the temp handoff file.
2. Give a 2-sentence summary of what's in it.
3. If the user chose "Yes" in Step 1, print the **Prompt for next agent** block directly in chat (not just in the file). The in-chat prompt must include the same **full handoff file path** as in the file.

**Only after all of the above is displayed**, proceed to Step 4.

## Step 4 — Feedback

Use `AskUserQuestion` to ask:
> "How did this session go?"
> - Header: "Feedback"
> - Option 1: "+1 — productive"
> - Option 2: "-1 — something was off"

If -1, follow up with a free-text question: "What went wrong?" (optional — Enter to skip).
