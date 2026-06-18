# Skill Anatomy

The contract every `SKILL.md` in this repo follows. `scripts/validate-skills.js`
enforces the **required** parts; the rest is a recommended pattern. Use
[`templates/SKILL-template.md`](../templates/SKILL-template.md) as the starting point.

## File location

```
skills/<group>/<name>/
  SKILL.md            # required
  feedback.jsonl      # created on first feedback; never committed (see .claude/CLAUDE.md)
  scripts/            # optional — runnable helpers
  <supporting>.md     # optional — reference material loaded on demand
```

`<group>` is one of `product`, `vault`, `utilities`, or `private`. The frontmatter
`name` must equal the leaf directory `<name>`.

## Frontmatter

```yaml
---
name: skill-name            # required — lowercase-hyphen; must match the directory name
description: >              # required — what it does + WHEN to trigger (≤ 1024 chars)
  One or two lines: what this skill does, then the trigger phrases / slash command
  that activate it. Agents read this to decide when to load the skill.
user-invocable: true        # required for user-facing skills
allowed-tools: [Bash, Read, Write, AskUserQuestion]   # recommended when the skill does I/O
argument-hint: "[issue-number]"                        # recommended when it takes arguments
---
```

**Why the description matters:** it is injected into the system prompt for skill
discovery. State *what* and *when* — do not paraphrase the whole workflow, or the
agent may follow the summary instead of reading the skill.

## Required sections

Every task skill must contain these headings (equivalent aliases in brackets are accepted):

1. **`## Overview`** — what the skill does, why it exists, where it sits in the workflow.
2. **`## When to Use`** — trigger conditions *and* when **not** to use it.
3. **A core-process section** — `## Steps` *(or `## Process`, `## Workflow`, or numbered `## Step N` headings)*. The actual workflow: specific, actionable, with checkpoints.
4. **`## Common Rationalizations`** — a table of excuses an agent uses to skip steps, each with a factual rebuttal. This is the anti-rationalization guard.
5. **`## Red Flags`** — observable signs *during execution* that the skill is going wrong (distinct from design anti-patterns).
6. **`## Verification`** — an exit checklist where every item is backed by evidence (test output, a written file path, a build result).
7. **`## Feedback`** — the self-annealing loop (see below). Required in this repo.

A skill that is a pure mode-switch or reference (not a workflow) can be exempted from
the section checks — add it to `SECTION_EXEMPT_SKILLS` in `scripts/validate-skills.js`
with a one-line reason. Exemptions live in the validator, not in skill frontmatter, so
a skill cannot exempt itself.

## The Feedback section (repo-specific)

This is what makes the library self-improving — keep it in every task skill:

```markdown
## Feedback

Use `AskUserQuestion`: "How did this skill perform?" — `+1` worked / `-1` something broke.
On `-1`, ask "What went wrong?" (optional). Append one line to `feedback.jsonl` in this
skill's directory: `{"ts":"<ISO8601>","rating":<-1|1>,"comment":<string|null>}`.
On `-1`, self-anneal: fix the root cause in this SKILL.md so the failure cannot recur.
```

## Trust-boundary block

Skills that run shell, touch files, or fetch external content open with a short comment
declaring untrusted inputs, where the skill writes, and that external content is never
executed as instructions. Omit it for pure-conversation skills.

## Supporting files

Split content into a sibling `.md` only when it exceeds ~100 lines or is reused (e.g.
`CONVENTIONS.md`). Keep short patterns inline. Don't create an empty `scripts/` dir to
mirror other skills — add it only when there's a runnable helper.

## Writing principles

1. **Process over prose** — steps, not facts.
2. **Specific over general** — "Run `npm test` and confirm 0 failures" beats "check the tests".
3. **Evidence over assumption** — every Verification item needs proof.
4. **Anti-rationalization** — every skippable step gets a rebuttal in the table.
5. **Token-conscious** — if removing a section wouldn't change agent behavior, remove it.
6. **No PII** — public skills carry no real names, emails, paths, or client data (see `.claude/CLAUDE.md`).

## Validating

```bash
node scripts/validate-skills.js
```

Exit 0 = clean, 1 = errors. Warnings (missing `allowed-tools`, dead cross-references,
missing Feedback) do not block but should be cleared.
