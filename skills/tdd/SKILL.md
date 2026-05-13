---
name: tdd
description: >
  Test-driven development with red-green-refactor loop, driven by a GitHub issue.
  Use when implementing a GitHub issue using TDD, mentions "red-green-refactor",
  wants integration tests, or asks for test-first development.
  Accepts an optional issue number: /tdd or /tdd <N>.
argument-hint: "[issue-number]"
allowed-tools: Bash, Read, Edit, Write, TodoWrite
user-invocable: true
---

# /tdd

Implements one GitHub issue using red-green-refactor TDD. The issue's acceptance criteria are the test specification — no planning from scratch.

See [tests.md](tests.md), [mocking.md](mocking.md), [deep-modules.md](deep-modules.md), [interface-design.md](interface-design.md), [refactoring.md](refactoring.md).

---

## Step 1 — Load the issue

If an issue number was given as argument, run:

```
gh issue view <N> --json number,title,body,labels
```

If no argument was given, run:

```
gh issue list --state open --json number,title,labels
```

Show the list and ask: "Which issue should we work on?"

Once an issue is selected, read it in full. Extract the **Acceptance Criteria** block — this becomes the test specification. If no structured acceptance criteria exist, ask the user to describe the behaviors to test before continuing.

---

## Step 2 — Planning

Before writing any code, confirm with the user:

1. **Interface shape** — what does the public API of the new code look like? (function signatures, module exports, class methods)
2. **Behaviors to test** — map each acceptance criterion to one test. List them explicitly:
   - `[ ] behavior 1 → test name`
   - `[ ] behavior 2 → test name`
   - ...
3. **Mocking boundaries** — identify system boundaries (external APIs, DB, time, file system). See [mocking.md](mocking.md). Everything else: no mocks.
4. **Interface design** — check for testability traps. See [interface-design.md](interface-design.md).

Ask: "Does this interface and test list match what you expect? Any behaviors to add, remove, or reorder?"

Do not write any code until the user approves the plan.

---

## Step 3 — Tracer bullet

Write ONE failing test for the first (simplest) behavior. Run it — confirm it's RED.

Write the minimal code to make it pass. Run it — confirm GREEN.

This proves the path works end-to-end before committing to the full loop.

---

## Step 4 — Incremental RED→GREEN loop

For each remaining behavior in the list:

```
RED:   write test → run → confirm fail
GREEN: minimal code to pass → run → confirm pass
```

Rules:
- One test at a time, in order
- Only enough code to pass the current test
- Do not anticipate future tests
- Test must use the public interface only — no peeking at internals
- Check off each behavior as it goes GREEN

After each GREEN, ask: "Continue to next behavior, or stop here?"

---

## Step 5 — Refactor

Once all behaviors are GREEN:

Look for candidates from [refactoring.md](refactoring.md):
- [ ] Duplication → extract function/module
- [ ] Long methods → break into private helpers (tests stay on public interface)
- [ ] Shallow modules → deepen or combine
- [ ] Feature envy, primitive obsession
- [ ] Existing code the new code reveals as problematic

Run tests after **every** refactor step. If any test goes RED during refactor, undo and fix before continuing.

**Never refactor while RED.**

---

## Step 6 — PR creation

Once all tests pass and refactor is complete, create a pull request:

```
gh pr create \
  --title "<issue title>" \
  --body "$(cat <<'EOF'
Closes #<N>

## Behaviors implemented
<bullet list matching the acceptance criteria>

## Notes
<any implementation decisions worth capturing>
EOF
)"
```

Report the PR URL to the user.

---

## Step 7 — Feedback

Use `AskUserQuestion` to ask:

> "How did this skill perform?"
> - Header: "Feedback"
> - Option 1: "+1 — worked well"
> - Option 2: "-1 — something went wrong"

If -1, ask a follow-up text question: "What went wrong?" (optional — Enter to skip).

Append one line to `~/.claude/skills/tdd/feedback.jsonl`:
`{"ts":"<ISO8601>","issue":<N>,"rating":<-1|1>,"comment":<string|null>}`

For -1 ratings: trigger self-annealing — identify and fix the root cause described in the comment.

---

## What NOT to do

- Do not write multiple tests before implementing — vertical slices only (one test → one impl → repeat)
- Do not mock your own code — only system boundaries
- Do not test implementation details — only observable behavior through the public interface
- Do not anticipate future tests by writing extra code "just in case"
- Do not refactor while RED — get to GREEN first
- Do not create the PR until all acceptance criteria are GREEN
