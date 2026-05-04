---
name: prd-to-issues
description: >
  Break a prd.md into independently-deliverable GitHub issues using vertical (tracer-bullet) slices.
  Use when the user types /prd-to-issues, says "turn this PRD into issues", "create GitHub issues from the PRD", or "break this into issues".
  Works best after /get-prd has produced prd.md. Each issue cuts through the full stack and is demo-able when done.
  Never creates issues without human approval of the full breakdown first.
---

# /prd-to-issues

A decomposition skill. Its job is to translate a committed PRD into independently-deliverable GitHub issues — one vertical slice per issue, each demo-able on its own, with clear acceptance criteria drawn directly from the PRD.

This skill does **not** re-discuss the PRD. It reads it, slices it, presents the breakdown for approval, then creates the issues. No surprises.

**Vertical slice = one complete path through the stack** (data + logic + UI/output) for a single user-facing capability. Never "add all DB tables" or "add all API routes" — those are horizontal and can't be validated until all layers are done.

---

## Step 1 — Load prd.md

Check for `prd.md` in the current working directory and read it.

If not found, ask: "I don't see a prd.md here. Should I work from our conversation context, or do you want to run /get-prd first to produce one?"

If working from conversation context, extract the equivalent of the PRD's key sections before proceeding: user stories, success criteria, implementation decisions, out of scope.

---

## Step 2 — Identify the GitHub repo

Run `gh repo view --json nameWithOwner` to find the current repo.

If the command fails (not a git repo, no remote, or gh not authenticated), tell the user: "I can't find a GitHub repo here — either run this from inside a git repo with a GitHub remote, or run `gh auth login` first." Then stop.

---

## Step 3 — Slice the PRD into candidate issues

Map PRD sections to issue components:

| PRD section | Maps to |
|---|---|
| User Stories (✓ Confirmed) | One issue per story (or grouped if tightly coupled) |
| User Stories (~ Proposed) | Separate "discussion" issues, clearly labelled |
| Success Criteria | Acceptance criteria copied verbatim into each relevant issue |
| Implementation Decisions | Context/rationale block in each affected issue |
| Out of Scope | Explicit "not in this issue" callout in affected issues |
| Testing Approach | QA notes appended to each issue |
| Constraints | Noted in issue body where they affect that slice |

**Grouping rule:** Only group stories into one issue if they share a data model boundary and cannot be built or tested independently. When in doubt, split.

**Classify each issue:**
- **HITL** (human-in-the-loop) — needs decisions or judgment during execution: auth flows, external integrations, UI with unclear states, anything touching prod data
- **AFK** (away from keyboard) — Claude can execute autonomously: well-bounded, isolated, no external dependencies, clear pass/fail

**Identify blockers:** Note which issues must complete before others can start.

---

## Step 4 — Present the breakdown for approval

Show the full issue plan in this format before creating anything:

```
## Proposed Issues

### 1. [Issue Title]
- **Type:** feature | chore | question | bug
- **Mode:** HITL | AFK
- **Blocks:** [issue numbers/titles that depend on this]
- **Blocked by:** [issue numbers/titles this depends on]
- **Acceptance criteria:**
  - [copied from PRD success criteria]
- **Out of scope for this issue:** [from PRD, filtered to what's relevant here]

### 2. [Issue Title]
...
```

Then ask: "Does this breakdown match what we're committing to? Any issues to split, merge, rename, or reorder before I create them?"

Incorporate any changes. Do not create issues until the user confirms.

---

## Step 5 — Create issues via gh CLI

Once approved, create issues in dependency order (blockers first) using:

```
gh issue create \
  --title "<title>" \
  --body "<body>" \
  --label "needs-triage"
```

Use this body template for each issue:

```markdown
## Context
> From PRD — [relevant user story or section]

## Acceptance Criteria
[Copied verbatim from PRD success criteria, filtered to this issue]

## Out of Scope for This Issue
[From PRD out-of-scope, filtered to what's relevant here]

## QA Notes
[From PRD testing approach, filtered to this issue]

## Notes
- **Mode:** HITL | AFK
- **Blocks:** [issue titles]
- **Blocked by:** [issue titles]
```

Report each issue URL as it's created. If any `gh` command fails, report the error and continue with the remaining issues — don't abort the whole run.

---

## Step 6 — Summary

After all issues are created, output:

```
## Issues Created

1. [Title] — [URL]
2. [Title] — [URL]
...

Execution order: [ordered list reflecting dependencies]
AFK issues (can be delegated): [list]
HITL issues (need supervision): [list]
```

---

## Skill Evaluation

At the very end, use `AskUserQuestion` to ask:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If they select `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `~/.claude/skills/prd-to-issues/feedback.jsonl`:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

For `-1` ratings: trigger self-annealing — identify and fix the root cause described in the comment.

---

## What NOT to do

- Do not create issues without explicit approval of the full breakdown.
- Do not use horizontal slices ("add all models", "add all routes") — every issue must be demo-able on its own.
- Do not invent acceptance criteria — pull them directly from the PRD.
- Do not include out-of-scope items from the PRD as issues.
- Do not skip the dependency order — create blockers before the issues that depend on them.
- Do not abort the entire run if one `gh issue create` fails — report and continue.
