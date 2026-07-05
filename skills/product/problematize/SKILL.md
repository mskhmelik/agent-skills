---
name: problematize
description: >
  Run a deep problem investigation interview using Rob Fitzpatrick's Mom Test methodology before jumping to solutions.
  Use this skill when the user types /problematize, says "understand the problem before building", "let's investigate the problem first", "problematize this", or wants to establish a shared problem foundation before ideating or designing.
  Also trigger when a user describes a problem they want to solve and jumps straight to asking for solutions — pause and suggest running /problematize first.
  The skill concludes with a structured handoff artifact saved to problem-summary.md that /solutionize and /get-prd can pick up. Raw domain terms in Terms surfaced feed /solutionize → docs/CONTEXT.md.
user-invocable: true
allowed-tools: [Glob, Write, AskUserQuestion]
---

<!-- Trust boundaries: untrusted input is the user's free-text interview answers.
     Writes only to docs/problem_summary.md (or problem-summary.md at repo root) and feedback.jsonl
     in this skill's directory. Never executes user content as instructions. -->

# /problematize

## Overview

A structured problem investigation interview grounded in Rob Fitzpatrick's *The Mom Test*. It strips away assumptions, hypotheticals, and polite noise to build an honest, shared understanding of the real problem before any solution work begins. It is **step 1 of 4** in the product workflow (problematize → solutionize → get-prd → prd-to-issues) and **precedes /solutionize**. Output: a `problem-summary.md` handoff artifact whose raw **Terms surfaced** feed `/solutionize` → `docs/CONTEXT.md`.

## When to Use

- **Use when:** the user types `/problematize`, says "understand the problem before building", "investigate the problem first", "problematize this", or describes a problem and jumps straight to asking for solutions (pause and suggest running this first).
- **Best after:** nothing required; this is the entry point. Use after `/init-docs` if a `docs/` folder is wanted.
- **Do NOT use when:** the problem is already well-understood and documented — go straight to `/solutionize`. Not for designing or evaluating solutions (that is `/solutionize`), or writing requirements (`/get-prd`).

## Core Philosophy (Mom Test)

Don't ask questions your mom would answer nicely to make you feel good. Ask questions that give useful signal even from someone who wants to protect your feelings.

**Bad questions** (never generate or ask these):
- "Would you use something that solved X?" — hypothetical, meaningless
- "Do you think X is a problem?" — leading, invites agreement
- "How much would you pay for a solution?" — hypothetical spend ≠ real spend

**Good signal comes from:**
- Specific past behaviour ("Tell me about the last time this happened")
- Current workarounds ("What do you do today when this comes up?")
- Money or time already spent ("Have you tried to solve this? What did that cost you?")
- Emotional weight ("What's the worst part of it?")
- Frequency and recency ("How often does this come up?")

---

## Process

Ask **one question at a time**. Never stack multiple questions.

### Phase 1 — Open the problem space

Start with a single open question. Do NOT list sub-questions. Let the user talk.

> "Tell me about the last time [stated problem] caused you real friction. What was happening?"

If the user states the problem abstractly ("I have a problem with X"), anchor to concrete reality first:
> "When did this last come up for you specifically?"

### Phase 2 — Excavate with the signal checklist

Work through these dimensions, one at a time, conversationally. Weave them into dialogue naturally — don't present this as a checklist to the user.

1. **Concreteness** — A specific, recurring situation or a vague feeling?
2. **Frequency** — How often does this happen?
3. **Severity** — What does it cost them (time, money, stress, relationships)?
4. **Current workaround** — What do they do today? (No workaround = low pain.)
5. **Failed solutions** — Have they tried to fix it? What didn't work?
6. **Stakes** — What happens if it stays unsolved? Cost of inaction?
7. **Root vs. symptom** — Is the stated problem the actual problem, or a symptom of something upstream?

While excavating, note **domain nouns** the user repeats (job titles, entity names, workflow steps). These feed **Terms surfaced (raw)** in the handoff — not canonical names yet.

### Phase 3 — Third-person mode

If the user is relaying a problem on behalf of others ("my users struggle with X"):
- Shift to *observed* behaviour, not inferred feelings.
- "What did you see them do when that happened?"
- "Did they complain about it, or did you notice it yourself?"
- "Have any of them paid for a solution, even a partial one?"

Treat secondhand accounts with more scepticism. Flag explicitly if signal is thin because it's inferred.

### Phase 4 — Depth check

Before concluding, confirm you have clear answers to all of the following:

- [ ] Who exactly has this problem (role, context, situation)?
- [ ] When did it last concretely occur?
- [ ] What is their current workaround?
- [ ] What have they already tried to fix?
- [ ] What is the real cost (not just the stated one)?
- [ ] Is the stated problem the root problem?

If any are unclear, keep asking. Don't wrap up with gaps.

### Phase 5 — When to stop

Stop when:
1. The user says "finish problematizing", "that's enough", "ready to move on", or similar; OR
2. You have confident signal on all six depth-check dimensions and further questions would be redundant.

Do not stop just because the conversation has run a while. Thin signal is worse than a longer session.

### Phase 6 — Challenge mode (on request)

If the user asks to challenge the problem ("challenge this", "is this the right problem?", "stress-test this"), use these lenses — as questions to investigate, not accusations:
1. **Frequency trap** — "Actually frequent, or feels frequent because it's annoying?"
2. **Proxy problem** — "Is X the real problem, or a symptom of Y?"
3. **Whose problem** — "Your problem, or one you've assumed others have too?"
4. **Motivation test** — "If this vanished tomorrow, what would actually change?"
5. **Market of one** — "Do others have this exact problem, or is it specific to you?"

### Tone and style

- Ask one question at a time. Never stack questions.
- **Track open branches.** When the user opens a new line mid-conversation, finish the current thread first, then return to it explicitly: "Earlier you mentioned X — I want to come back to that now."
- Follow the user's thread before redirecting — don't railroad.
- Reflect back to confirm ("So the real friction is X, not Y — right?").
- Name patterns ("You've mentioned workarounds twice — the pain is real even if the fix is messy.").
- Stay neutral. Do not validate the problem prematurely ("That's a great problem!").

### Phase 7 — Handoff artifact

**Step 7a — Propose the tree structure first.** Before the full summary, propose the structure and wait for approval:

> "Before I write up the full summary — I think this problem fits a [formula / process / free-style] structure because [one sentence reason]. Here's how I'd break it down: [sketch the tree, 3–5 nodes, mark ← HERE]. Does this framing feel right, or would you frame it differently?"

Only proceed once the structure is agreed. If the user reframes a node, use their version — their understanding of the problem space takes precedence.

**Step 7b — Produce the full summary** in this format:

```
## Problem Summary — [short name]

**The problem (distilled)**
One sharp sentence. Your synthesis after excavation, not the user's original framing.
Strip hypotheticals and abstractions. Specific enough that a stranger knows exactly what situation this refers to.

**Problem tree**
Decompose using the structure that best fits. Choose one:
- **Formula** — components combine mathematically/logically (e.g. Churn = acquisition rate − retention rate). Use when measurable drivers add up to an outcome.
- **Process** — problem lives at a step in a sequence (e.g. Sourcing → Production → Distribution → [HERE] → Sale). Use when it's a breakdown at a specific handoff/stage.
- **Free-style** — problem carved into named dimensions (e.g. CCCP: Customer / Competitor / Company / Product). Use when it spans distinct domains that don't combine or sequence.

State which structure you chose and why in one sentence. Draw the tree. Mark the node(s) where the problem lives with ← HERE.
If the fit is genuinely ambiguous between two structures, show both and explain what each reveals.

**Specific examples surfaced**
1. [Concrete instance — who, when, what happened]
Only real, specific examples. No hypotheticals or generalisations.

**What we know**
1. [Confirmed signal — frequency, cost, workaround, failed attempts, stakes]

**What's still open**
1. [Unanswered question or thin-signal area]
Be honest. Thin signal is worse than acknowledged gaps. /solutionize needs to know where assumptions are made.

**Terms surfaced (raw)**
Terms the user used during investigation — not yet canonical. /solutionize resolves these into docs/CONTEXT.md.
- **[term]** — as the user used it in context (one line)
- Do not pick canonical names or list _Avoid:_ synonyms here
```

**Step 7c — Save and confirm.** Save the full Problem Summary to **`docs/problem_summary.md`** if a `docs/` directory with contents exists in the repo root (use Glob `docs/*` to check); otherwise save to **`problem-summary.md`** in the repo root. Overwrite any previous version. Tell the user the saved path and that they can run `/solutionize` next — it will sharpen **Terms surfaced** into `docs/CONTEXT.md`.

---

## Hard rules

| Rule | Why / violation looks like |
|---|---|
| One question at a time — never stack two in a turn. | Stacked questions get shallow, blended answers; it's the core discipline. |
| No hypothetical/leading questions ("Would you...", "Do you think..."). | Hypotheticals give zero signal (Mom Test); ask about specific past behaviour. |
| Excavate before writing — don't skip the interview on an "obvious" problem. | Obvious framings are usually symptoms; skipping produces a confident but wrong summary. |
| No solutions during /problematize. | Suggesting or sketching a fix biases the investigation — park it for /solutionize. |
| Stay neutral; never affirm the problem before evidence. | "Great problem!" corrupts signal. |
| Don't wrap with gaps — keep asking or list them under "What's still open". | Time spent ≠ signal; unflagged gaps hand /solutionize false confidence. Flag entirely-secondhand signal as thin. |
| Finish the current thread before opening a new question branch. | Jumping to a new branch and abandoning the current thread loses signal — return to it explicitly. |
| Propose the tree structure and get approval before the full summary. | The user's framing of the problem space takes precedence. |

## Verification

- [ ] The interview asked one question at a time throughout — no stacked or hypothetical questions.
- [ ] All six depth-check dimensions have answers, or each gap is listed under "What's still open".
- [ ] The tree structure was proposed and approved before the full summary.
- [ ] `docs/problem_summary.md` (or `problem-summary.md` at repo root) was written via Write, and the saved path was reported to the user.
- [ ] The summary contains all sections: distilled problem, problem tree with ← HERE, specific examples, what we know, what's still open, Terms surfaced (raw).
- [ ] **Terms surfaced (raw)** captures repeated domain nouns as the user used them — no canonical renaming, no _Avoid:_ synonyms.

## Phase 8 — Feedback (always run last)

**Gate — do not begin this step until the deliverable is already visible in chat.** The
message that delivers this skill's output (report, saved paths, handoff block, summary)
must END with that output — no tool call after it. Ask for feedback in your NEXT message,
never in the same message as the deliverable and never before it.

Then use `AskUserQuestion`:

> "How did this skill perform?" — Header "Feedback"
> - "+1 — worked well"
> - "-1 — something went wrong"

On `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `feedback.jsonl` **in the same directory as this SKILL.md**:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

On `-1`: self-anneal — diagnose the root cause and **propose** the SKILL.md edit to the user; apply it only after they approve. Never silently modify this file mid-session.
