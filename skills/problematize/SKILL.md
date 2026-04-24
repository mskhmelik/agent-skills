---
name: problematize
description: >
  Run a deep problem investigation interview using Rob Fitzpatrick's Mom Test methodology before jumping to solutions.
  Use this skill when the user types /problematize, says "understand the problem before building", "let's investigate the problem first", "problematize this", or wants to establish a shared problem foundation before ideating or designing.
  Also trigger when a user describes a problem they want to solve and jumps straight to asking for solutions — pause and suggest running /problematize first.
  The skill concludes with a structured handoff artifact saved to problem-summary.md that /solutionize and /get-prd can pick up.
---

# /problematize

A structured problem investigation skill grounded in Rob Fitzpatrick's *The Mom Test*. The goal is to build a solid, honest understanding of the real problem — stripping away assumptions, hypotheticals, and polite noise — before any solution work begins.

---

## Core Philosophy (Mom Test)

The Mom Test principle: don't ask questions your mom would answer nicely to make you feel good. Ask questions that would give you useful signal even from someone who wants to protect your feelings.

**Bad questions** (avoid generating or asking these):
- "Would you use something that solved X?" — hypothetical, meaningless
- "Do you think X is a problem?" — leading, invites agreement
- "How much would you pay for a solution?" — hypothetical spend ≠ real spend

**Good signal comes from**:
- Specific past behaviour ("Tell me about the last time this happened")
- Current workarounds ("What do you do today when this comes up?")
- Money or time already spent ("Have you tried to solve this? What did that cost you?")
- Emotional weight ("What's the worst part of it?")
- Frequency and recency ("How often does this come up?")

---

## Interview Process

### Phase 1 — Open the problem space

Start with a single open question. Do NOT list sub-questions. Let the user talk.

> "Tell me about the last time [stated problem] caused you real friction. What was happening?"

If the user states the problem in abstract terms ("I have a problem with X"), anchor to concrete reality first:
> "When did this last come up for you specifically?"

### Phase 2 — Excavate with the signal checklist

Work through these dimensions, one at a time, conversationally. Don't present this as a checklist to the user — weave them into the dialogue naturally.

1. **Concreteness** — Is this a specific, recurring situation or a vague feeling?
2. **Frequency** — How often does this happen?
3. **Severity** — What does it cost them (time, money, stress, relationships)?
4. **Current workaround** — What do they do today? (This reveals real pain level — no workaround = low pain)
5. **Failed solutions** — Have they tried to fix it? What didn't work?
6. **Stakes** — What happens if it stays unsolved? What's the cost of inaction?
7. **Root vs. symptom** — Is the stated problem the actual problem, or a symptom of something upstream?

### Phase 3 — Third-person mode

If the user is relaying a problem on behalf of others (e.g., "my users struggle with X"):

- Shift to asking about *observed* behaviour, not inferred feelings
- "What did you see them do when that happened?"
- "Did they complain about it, or did you notice it yourself?"
- "Have any of them paid for a solution, even a partial one?"

Treat secondhand accounts with more scepticism. Flag explicitly if the signal is thin because it's inferred.

### Phase 4 — Depth check

Before concluding, ask yourself: do I have clear answers to all of the following?

- [ ] Who exactly has this problem (role, context, situation)?
- [ ] When did it last concretely occur?
- [ ] What is their current workaround?
- [ ] What have they already tried to fix?
- [ ] What is the real cost (not just the stated one)?
- [ ] Is the stated problem the root problem?

If any are unclear, keep asking. Don't wrap up with gaps.

### Phase 5 — When to stop

Stop when:
1. The user says "finish problematizing", "that's enough", "ready to move on", or similar
2. OR you have confident signal on all six dimensions above and further questions would be redundant

Do not stop just because the conversation has been going a while. Thin signal is worse than a longer session.

---

## Challenge Mode

If the user explicitly asks to challenge the problem ("challenge this", "is this the right problem?", "help me stress-test this"):

Use these challenge lenses:
1. **Frequency trap** — "Is this actually frequent, or does it feel frequent because it's annoying?"
2. **Proxy problem** — "Is X the real problem, or is it a symptom of Y?"
3. **Whose problem** — "Is this your problem, or a problem you've assumed others have too?"
4. **Motivation test** — "If this magically went away tomorrow, what would actually change for you?"
5. **Market of one** — "Do you know others who have this exact problem, or is this specific to your situation?"

Present these as questions to investigate, not accusations. The goal is clarity, not deflation.

---

## Tone and Style

- Ask one question at a time. Never stack multiple questions.
- **Track open branches.** When the user points to a new questioning line mid-conversation, do not jump to it immediately — finish the current thread first, then return to it explicitly. Keep a mental list of open branches and work through them in order. Example: "Earlier you mentioned X — I want to come back to that now."
- Follow the user's thread before redirecting — don't railroad.
- Reflect back what you're hearing to confirm ("So the real friction is X, not Y — is that right?")
- Name patterns when you see them ("You've mentioned workarounds twice — that tells me the pain is real even if the fix is messy.")
- Do not validate the problem prematurely ("That's a great problem!"). Stay neutral until you have real signal.

---

## Handoff Artifact

### Step 1 — Propose the tree structure first

Before producing the full summary, propose the tree structure and wait for approval:

> "Before I write up the full summary — I think this problem fits a [formula / process / free-style] structure because [one sentence reason]. Here's how I'd break it down: [sketch the tree, 3–5 nodes, mark ← HERE]. Does this framing feel right, or would you frame it differently?"

Wait for the user to confirm, adjust, or suggest an alternative. Only proceed to the full summary once the structure is agreed.

If the user proposes a different structure or reframes a node, use their version. Their understanding of the problem space takes precedence.

### Step 2 — Produce the full summary

When the structure is approved, produce the full Problem Summary in this format:

```
## Problem Summary — [short name]

**The problem (distilled)**
One sharp sentence. Not the user's original framing — your synthesis after excavation.
Strip hypotheticals and abstractions. Make it specific enough that a stranger would know exactly what situation this refers to.

**Problem tree**
Decompose the problem space using the structure that best fits. Choose one:

- **Formula** — when the problem has components that combine mathematically or logically
  Example: Churn = acquisition rate - retention rate
  Use when: the problem has measurable drivers that add up to an outcome

- **Process** — when the problem lives at a specific step in a sequence
  Example: Sourcing → Production → Distribution → [problem is here] → Sale
  Use when: the problem is a breakdown at a specific handoff or stage

- **Free-style** — when the problem is best carved into named dimensions
  Example (CCCP): Customer / Competitor / Company / Product
  Use when: the problem spans multiple distinct domains that don't combine or sequence

State which structure you chose and why in one sentence. Then draw the tree.

Mark the specific node(s) where the problem lives with ← HERE.

If the fit is genuinely ambiguous between two structures, show both and explain the difference in what each reveals.

**Specific examples surfaced**
1. [Concrete instance with context — who, when, what happened]
2. [Next specific instance]
3. [Continue for all concrete examples raised]

Only include examples that were specific and real. Do not include hypotheticals or generalisations.

**What we know**
1. [Confirmed signal — frequency, cost, workaround, failed attempts, stakes]
2. [Continue for each confirmed dimension]

**What's still open**
1. [Unanswered question or thin signal area]
2. [Continue for each gap]

Be honest here. Thin signal is worse than acknowledged gaps. If something couldn't be established, say so plainly — /solutionize needs to know where assumptions are being made.
```

After presenting the summary:

1. Save the full Problem Summary to `problem-summary.md` in the current working directory, overwriting any previous version.
2. Tell the user: "Saved to `problem-summary.md`. Ready to run /solutionize when you are."

---

## Skill Evaluation

At the very end, use `AskUserQuestion` to ask:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If they select `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `~/.claude/skills/problematize/feedback.jsonl`:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

For `-1` ratings: trigger self-annealing — identify and fix the root cause described in the comment.

---

## What NOT to do

- Do not suggest solutions during /problematize. If a solution comes up naturally, note it briefly and park it: "That's a solution worth exploring — let's hold it for /solutionize."
- Do not agree with the problem framing just to keep the conversation moving.
- Do not produce the Problem Brief until the session is genuinely complete.
- Do not ask hypothetical questions ("Would you want a tool that...").
