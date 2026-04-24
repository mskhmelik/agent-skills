---
name: get-prd
description: >
  Synthesize problem-summary.md and solution-summary.md into a Product Requirements Document and save it as prd.md.
  Use this skill when the user types /get-prd, says "generate the PRD", "create the PRD", or "let's write the PRD".
  Works best after /problematize and /solutionize have run. Can also work from conversation context alone.
  The skill does not re-interview — it synthesizes what is already known, asks targeted questions only to close genuine gaps, then saves prd.md.
---

# /get-prd

A synthesis skill. Its job is to close the loop from exploration to commitment — turning the problem and solution work into a document that answers: "what exactly are we building, and what aren't we?"

This skill does **not** re-run the investigation. It reads existing outputs, fills any remaining gaps with minimal targeted questions, and produces a PRD that has no open questions.

If open questions remain when this skill runs, they must be resolved before the PRD is finalised. A PRD with open questions is not a PRD — it's a draft.

---

## Step 1 — Load inputs

Check for the following files in the current working directory and read them if present:
- `problem-summary.md` — output of /problematize
- `solution-summary.md` — output of /solutionize

If neither file exists, ask: "I don't see problem-summary.md or solution-summary.md here. Should I work from our conversation context, or do you want to run /problematize and /solutionize first?"

If only one file exists, use it and note what's missing.

---

## Step 2 — Cross-check alignment

Before synthesising, verify the two documents are pointing at the same problem:

- The **problem anchor** in solution-summary.md should match the **distilled problem** in problem-summary.md
- If they diverge, flag it explicitly: "The problem framing shifted between /problematize and /solutionize — [state the divergence]. Which version should the PRD be anchored to?"

Do not proceed until alignment is confirmed.

---

## Step 3 — Gap check

Scan both files for unresolved items:
- Open questions in solution-summary.md
- "What's still open" items in problem-summary.md that were not addressed in solutionize
- Any feature or step marked `?` in the solution-summary that is load-bearing for the PRD

For each genuine gap, ask one targeted question at a time. Maximum 3 questions total. If there are more than 3 gaps, prioritise the ones that would change the scope or direction of the PRD.

Do not ask about gaps that are explicitly out of scope — those are already resolved.

---

## Step 4 — Produce the PRD

Synthesise both files into the following structure. Every section draws from both inputs — problem-summary.md provides the problem context and evidence; solution-summary.md provides the direction and commitments. Do not invent content — every item must be traceable to one of the two files or the gap-fill conversation.

```markdown
# PRD — [short name]

## Problem statement
Source: problem-summary.md (distilled problem) + solution-summary.md (problem anchor)
One sharp sentence. Use the excavated version, not the original framing.
If the two files state it differently, use the more specific version.

## Why this matters
Source: problem-summary.md (stakes, cost of inaction, specific examples)
2–3 sentences on what breaks or stays broken if this isn't solved.
Ground it in the concrete examples surfaced during /problematize — not generalisations.

## Success criteria
Source: solution-summary.md (success criteria section)
1–3 behavioral statements of what done looks like.
Format: "A user can [do X] without [needing Y]" or "The system [does X] when [condition Y]."
These are the acceptance tests for the whole feature.

## User stories
Source: solution-summary.md (desired user flow + feature breakdown) informed by problem-summary.md (who has the problem, their workarounds, their context)

As a [who — from problem-summary persona], I can [action — from solution user flow], so that [outcome — tied to success criteria].

Mark each as:
- ✓ Confirmed — validated in the session
- ~ Proposed — inferred, not explicitly discussed

The "who" must come from problem-summary.md (the real person with the real problem).
The "action" must come from solution-summary.md (the confirmed user flow steps).
Do not include stories for ruled-out solution directions.

## Implementation decisions
Source: solution-summary.md (decisions section) + problem-summary.md (failed solutions, workarounds)
Format: "We chose [X] over [Y] because [specific reason]."
Include failed solutions from /problematize if they overlap with ruled-out options — this explains why those paths were already tried.
Each decision here is closed — not up for re-discussion during implementation.

## Out of scope
Source: solution-summary.md (out-of-scope section) + problem-summary.md (what's still open that we're not solving now)
Format: "[Topic] — [one-line reason]."
This is a commitment. If it's listed here, it will not be built in this iteration.

## Constraints
Source: solution-summary.md (constraints section) + problem-summary.md (context on who, environment, existing workarounds)
Technical, time, or organisational limits that bound the implementation.

## Testing approach
Source: derived from success criteria (solution-summary.md) + specific examples (problem-summary.md)
Use the concrete examples from /problematize as the basis for test scenarios — they represent real situations the solution must handle.
Focus on behaviour through public interfaces, not implementation details.
List the key scenarios that must pass, not an exhaustive test plan.

## Open questions
Only include if something genuinely could not be resolved from either file or the gap-fill.
Flag each one clearly — it must be answered before implementation begins.
An empty section here is the goal.
```

---

## Step 5 — Review and confirm

After presenting the PRD draft, ask:

> "Does this capture what we're committing to? Anything wrong, missing, or that needs tightening before I save it?"

Incorporate any adjustments. Then save.

---

## Step 6 — Save

Save the finalised PRD to `prd.md` in the current working directory, overwriting any previous version.

Tell the user: "Saved to `prd.md`."

---

## Skill Evaluation

At the very end, use `AskUserQuestion` to ask:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If they select `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `~/.claude/skills/get-prd/feedback.jsonl`:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

For `-1` ratings: trigger self-annealing — identify and fix the root cause described in the comment.

---

## What NOT to do

- Do not re-interview. If the inputs exist, use them. Ask only to close gaps.
- Do not invent user stories or decisions not grounded in the inputs.
- Do not produce the PRD if the problem anchor is unresolved.
- Do not leave open questions in the PRD and call it done. Resolve them or flag them explicitly.
- Do not include ruled-out solution directions in the user stories or implementation decisions.
