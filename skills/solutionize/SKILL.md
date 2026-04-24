---
name: solutionize
description: >
  Interview the user about solutions to a well-understood problem, generate solution options, stress-test them using Mom Test principles, and produce a solution tree with modules, features, and open questions.
  Use this skill when the user types /solutionize, says "let's find solutions", "now let's solve it", "ready to solutionize", or wants to move from problem understanding into solution design.
  Works best after /problematize has produced a Problem Summary (reads problem-summary.md from the current directory if present), but also works standalone.
  The skill concludes with a structured Solution Overview saved to solution-summary.md that /get-prd can pick up.
---

# /solutionize

A structured solution investigation skill. The goal is to surface, expand, and stress-test solution options — generating ideas where needed and probing all of them with the same rigour, regardless of where they came from.

The Mom Test principle carries over: don't ask for reactions, probe for signal. "Do you like this idea?" is useless. "What would have to be true for this to work in your situation?" is not.

---

## Starting the Session

### If a /problematize Problem Summary exists

First check for `problem-summary.md` in the current working directory and read it if present. Otherwise look in conversation context.

Acknowledge it explicitly and use it as the foundation:

> "Based on what we uncovered: [one-sentence restatement of distilled problem]. Let's find solutions that actually address that — not the surface version."

Also note any open questions from the Problem Summary — these are the gaps solutionize needs to resolve before producing its output.

Then move directly to Phase 1.

### If no Problem Summary exists (standalone mode)

Do a rapid context grab — maximum 3 questions, one at a time — before generating anything:

1. "What's the problem we're solving? Give me the specific version, not the general one."
2. "What have you already tried or considered?"
3. "What does a good outcome look like — concretely?"

Once you have this, synthesise it into a one-sentence problem anchor and state it back:
> "So we're solving: [anchor]. Is that right?"

Only proceed once confirmed.

---

## Phase 1 — Surface the Solution Space

Start by asking what the user already has in mind. Never generate options first — the user's existing ideas are data.

> "Before I throw anything at you — what solutions have you already considered, even rough ones?"

Listen without reacting. Note each option. Do not evaluate yet.

Then generate 3–5 additional options Claude sees that the user hasn't mentioned. These should:
- Span a range (low-tech to high-tech, quick to long-term, narrow to broad)
- Be rooted in the specific problem, not generic solutions to the category
- Include at least one option that challenges the assumed scope ("what if you didn't solve this at the product level at all?")

Present them neutrally:
> "A few directions I see that we haven't talked about yet: [list]. Which of these feel worth exploring?"

---

## Phase 2 — Stress-Test Each Option

For every option on the table — user-generated or Claude-generated — apply the same challenge process. No option gets a free pass.

Work through options one at a time. For each:

### Assumption probe
Ask: "What would have to be true for this to actually work in your situation?"

Listen for assumptions the user states confidently. Those are the ones to dig into.

### Evidence probe
Ask: "Have you seen this approach work anywhere — even partially, even in a different context?"

If yes: "What made it work there? Does that condition exist here?"
If no: that's a signal, not a blocker — note it.

### Failure mode probe
Ask: "What's the most likely way this falls apart?"

If the user can't answer this, push harder. A solution with no visible failure mode hasn't been thought through.

### Cost probe
Not "how much would this cost?" — that's hypothetical. Instead:
"What's the most expensive part of this to get wrong?"

### Comparison probe (only if multiple options are being considered)
"Compared to [other option], what does this do better — specifically?"

Do not let the user default to vague preferences. "I like this one more" is not signal.

---

## Phase 3 — Branch Tracking

Same rule as /problematize: when the user points to a new thread mid-conversation, finish the current one first, then return explicitly.

> "You mentioned X earlier — I want to come back to that once we finish this."

Keep an internal list of open branches. Work through them before concluding.

---

## Phase 4 — Depth Check

Before wrapping up, confirm you have clear signal on:

- [ ] Which options have been genuinely explored vs. mentioned and dropped
- [ ] What the riskiest assumption is in the leading option(s)
- [ ] What the user has already tried that overlaps with any proposed solution
- [ ] What constraints exist (time, money, technical, organisational)
- [ ] What "good enough" looks like — what does success actually require?

If any are thin, keep asking.

---

## Phase 5 — Integration Fit

Before concluding, investigate how the solution sits in context. A solution that works in isolation but breaks upstream or downstream processes is not a good solution.

### Step 1 — Confirm the layers

Default to three layers unless the problem context suggests otherwise:

- **Data layer** — how data is stored, accessed, structured, and moved
- **Logic layer** — rules, processing, business logic, APIs, integrations
- **Front-end layer** — how users interact with it, what they see, what they control

If the problem is not a software/product problem (e.g., it's a process, ops, or organisational problem), adjust:
> "The standard data/logic/front-end breakdown might not fit here. What are the actual layers in your system — how would you describe the stack this sits in?"

Use the user's answer. Don't force the default if it doesn't fit.

### Step 2 — Probe upstream

For the leading solution direction(s), ask:

> "What feeds into this? What has to happen — or exist — before this solution can do its job?"

Listen for dependencies the user hasn't flagged. Probe any that sound assumed:
- "You said X is already handled — how reliable is that? What breaks if it isn't?"
- "Who owns that upstream piece — is that in your control?"

### Step 3 — Probe downstream

> "What does this solution hand off to? What happens after it does its job?"

Look for:
- Output format mismatches ("the logic layer produces X, but the front-end expects Y")
- Ownership gaps ("we produce this data, but who consumes it and how?")
- Silent dependencies ("this only works if Z is already in place — is Z in place?")

### Step 4 — Layer-by-layer coverage check

Walk through each layer for the leading solution and confirm:

**Data layer**
- What data does this solution need? Where does it come from?
- What data does it produce or modify?
- What are the storage, access, and privacy implications?
- Any schema changes, migrations, or new data contracts needed?

**Logic layer**
- What processing, rules, or decisions does this solution require?
- What APIs, services, or integrations does it touch?
- What are the failure modes at this layer (bad data in, wrong output, latency)?

**Front-end layer**
- How does the user interact with this? What do they see and control?
- What new UI surface does this require, if any?
- What existing UI does this change or break?

For each layer, note: ✓ covered / ~ partially covered / ? not yet explored.

### Step 5 — Integration gaps

After the layer walk, explicitly name any gaps:
> "We've covered [X] but haven't talked about [Y] — that's a real integration risk if left open."

---

## Phase 6 — When to Stop

Stop when:
1. The user says "finish solutionizing", "that's enough", "ready to see the output", or similar
2. OR all options have been stress-tested, branches are resolved, the depth check passes, and integration fit has been explored

---

## Solution Overview (output)

### Step 1 — Propose the solution tree structure first

Before producing the full overview, propose the top-level shape and wait for approval:

> "Before I write the full overview — here's how I'd structure the solution tree for [leading direction]: [sketch the top-level modules, 3–5 nodes]. Does this structure feel right, or would you organise it differently?"

Wait for confirmation or adjustment. Use the user's version if they reframe it.

### Step 2 — Produce the full overview

When the structure is approved, produce the full Solution Overview:

```
## Solution Overview — [short name]

**Problem anchor**
The one-sentence problem this is solving. Carried forward from /problematize or established at session start.

**Solution directions**
The top-level options explored. For each:

### [Solution name]
- **What it is**: One sentence.
- **Why it fits**: Tied explicitly to something said or discovered in the conversation — not a generic claim.
- **Riskiest assumption**: The one thing that has to be true for this to work.
- **Failure mode**: How it most likely falls apart.
- **Status**: [Leading candidate / Worth exploring / Ruled out — reason]

**Recommended direction** (if signal supports one)
State it and explain why in terms of the evidence — not preference.
If signal does not clearly support one, say so explicitly rather than forcing a pick.

**Success criteria**
1–3 behavioral statements of what "done" looks like. Observable, not feature-based.
Format: "A user can [do X] without [needing Y]" or "The system [does X] when [condition]."
These must come from the conversation — not generic quality statements.

**Constraints**
Technical, time, or organisational limits that bound the solution space.
Only include constraints that actually came up and shaped decisions.

**Desired user flow**
The end-to-end experience from the user's perspective for the leading direction.
Describe it as a numbered sequence of steps — what the user does, sees, and gets at each stage.
Mark each step as:
- ✓ Confirmed — discussed and validated in the session
- ~ Proposed — Claude-inferred from context, not explicitly discussed
- ? Open — unclear or not yet decided

Example format:
1. User lands on [entry point] and sees [what] ✓
2. User inputs [X] and gets [immediate feedback] ~
3. System processes [Y] in the background ?
4. User receives [outcome] in [format] via [channel] ✓

Flag any steps where the user experience depends on an unresolved integration question — these are the spots where UX and architecture are coupled.

**Feature / module breakdown** (for the leading direction(s))

Use a tree structure:

[Solution name]
├── [Module 1]
│   ├── [Specific feature — rooted in conversation evidence]
│   └── [Specific feature]
├── [Module 2]
│   ├── [Specific feature]
│   └── [Specific feature — flagged as assumption, not confirmed]
└── [Module 3]
    └── [Specific feature]

Mark each feature as one of:
- ✓ Confirmed — user validated or evidence supports
- ~ Proposed — Claude-generated, not yet validated
- ? Assumption — needs validation before building

**Integration fit**

Layers used: [Data / Logic / Front-end] or [custom layers if adjusted]

| Layer | Coverage | Notes |
|---|---|---|
| Data | ✓ / ~ / ? | What data flows in/out, storage implications, contracts |
| Logic | ✓ / ~ / ? | Processing, APIs, integrations, failure modes |
| Front-end | ✓ / ~ / ? | User interaction surface, UI changes or additions |

**Upstream dependencies**
1. [What must exist or happen before this solution works — and whether it's confirmed]

**Downstream handoffs**
1. [What this solution produces and who/what consumes it — and whether that's confirmed]

**Integration gaps**
1. [Specific gap that is a real risk if left unresolved]
2. [Continue for each]

**What we haven't covered**
1. [Specific area not explored — why it matters]
2. [Continue for each gap]

**Decisions**
Key choices made during this session and the reasoning behind each.
Format: "[We chose X over Y] because [specific reason from the conversation]."
Only include decisions that were actually made — not things still open.

**Out of scope**
Things that came up and were explicitly parked.
Format: "[Topic] — [one-line reason it was set aside]."
This is a commitment, not just a list. If it's here, it means we're not building it now.

**Open questions**
1. [Question that would change the direction if answered]
2. [Continue for each open question]
```

After presenting the overview:

1. Save the full Solution Overview to `solution-summary.md` in the current working directory, overwriting any previous version.
2. Tell the user: "Saved to `solution-summary.md`. Ready to run /get-prd when you are."

---

## Skill Evaluation

At the very end, use `AskUserQuestion` to ask:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If they select `-1`, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `~/.claude/skills/solutionize/feedback.jsonl`:
`{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`

For `-1` ratings: trigger self-annealing — identify and fix the root cause described in the comment.

---

## What NOT to do

- Do not ask "do you like this solution?" or any variant — it's a reaction, not signal.
- Do not let the user's preferred solution skip the stress-test because they seem confident in it.
- Do not fill the feature tree with generic features. Every item should be traceable to something specific — either said by the user or explicitly proposed by Claude during the session.
- Do not mark assumptions as confirmed. If it wasn't validated in the conversation, mark it as `?`.
- Do not produce the Solution Overview until the session is genuinely complete.
- Do not suggest pivoting back to /problematize mid-session unless a fundamental problem mismatch emerges — if it does, name it clearly: "We may be solving the wrong problem. Do you want to pause and go back, or proceed with the current framing?"
