---
name: diagnose
allowed-tools: [Bash, Read, Edit, Write, AskUserQuestion]
description: >
  Disciplined diagnosis loop for bugs and regressions. Feedback loop first, then
  hypothesise, instrument, fix, regression-test. Use when the user says /diagnose,
  "debug this", "diagnose this", reports a bug, or something is broken/failing.
  For Flutter repos, prefer widget tests at the same UI presentation as the report.
argument-hint: "[symptom or area, optional]"
user-invocable: true
---

# /diagnose

Hard bugs need a **pass/fail feedback loop** before fixes or instrumentation. Skip phases only when explicitly justified.

Before exploring code, read **`docs/README.md`** (if present), **`docs/prd.md`** scope for the area, and any **`docs/adr/`** touching the module. Do not expand scope beyond the PRD without asking.

See also central rule: `5_projects/ai/rules/debugging.md`.

---

## Phase 1 — Build a feedback loop (spend most effort here)

If you have a fast, deterministic, agent-runnable signal, the bug is mostly solved. Without one, do not guess.

### Loop options — try in order

**Flutter / Dart projects:**

1. **Failing widget test** at the seam the user hit (same presentation: mobile sheet vs desktop panel, same route).
2. **Failing unit test** on pure logic (parsers, mappers, keyboard handlers) — only if the bug is not focus/gesture/layout.
3. **`flutter test path/to/test.dart`** with minimal repro.
4. **Structured manual QA script** — `docs/manual_qa*.md` checklist; user runs steps, reports pass/fail per line.
5. **Replay** — captured log, HAR, or DB row through an isolated harness.

**Other stacks:** failing test → HTTP script → CLI fixture → headless browser → HITL checklist (last resort).

### Flutter-specific

- Read the **event/focus graph** before instrumenting: `FocusNode` listeners, `onPointerDown`, `onKeyEvent`, parent `HardwareKeyboard`, `setState` gates.
- Match **presentation mode** in tests (`TransactionFormPresentation.panel` vs `.sheet`, etc.).
- Use **`/tdd` Step 0 (bug-fix mode)** to turn the loop into a regression test after the fix.

### When you cannot build a loop

Stop. List what you tried. Ask for: (a) environment access, (b) a captured artifact, or (c) permission for temporary tagged logs. **Do not hypothesise blind.**

---

## Phase 2 — Reproduce

Run the loop. Confirm:

- [ ] Same failure mode the **user** described
- [ ] Reproducible (or high enough rate for flaky bugs)
- [ ] Exact symptom captured for verification later

---

## Phase 3 — Hypothesise

Generate **3–5 ranked, falsifiable** hypotheses before testing:

> If **H** is the cause, then **action** will make the bug disappear / worsen.

**Show the list to the user** before testing (unless AFK).

---

## Phase 4 — Instrument

One variable at a time. Each probe maps to one hypothesis.

1. Debugger / test inspection if available
2. **Targeted logs** at boundaries — tag every line: `[DEBUG-a4f2]` (grep to cleanup)
3. Never log everything

**Flutter:** use project `AppLog.debug('a4f2', ...)` if present; otherwise `debugPrint('[DEBUG-a4f2] ...')`. **No session-scoped log files** (no `.cursor/debug-*.log`, no ad-hoc `agent_debug_log.dart`).

---

## Phase 5 — Fix + regression test

**Regression test before fix** when a **correct seam** exists (test exercises the real bug pattern at the call site).

If no correct seam: document that as the finding; consider `docs/adr/`.

1. Failing test at seam → RED
2. Minimal fix → GREEN
3. Re-run Phase 1 loop on full scenario

Hand off to **`/tdd`** for the RED→GREEN loop when appropriate.

---

## Phase 6 — Cleanup + post-mortem

- [ ] Original repro gone
- [ ] Regression test passes (or seam gap documented)
- [ ] All `[DEBUG-...]` removed
- [ ] Correct hypothesis noted in commit/PR message

Ask: **What would have prevented this?** (missing test, missing doc, wrong seam, scope drift from PRD)

Append feedback to `feedback.jsonl` in this skill directory (same pattern as `/tdd`).

---

## What NOT to do

- Do not instrument before Phase 1 loop exists
- Do not fix without a regression test when `flutter test` can reach the bug
- Do not declare done on unit tests alone when the report is widget/focus/keyboard
- Do not expand scope beyond `docs/prd.md` without asking
