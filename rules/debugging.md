# Debugging (all repos)

Companion to the **`/diagnose`** skill. Repo-specific seams belong in `docs/agents/` or module docs.

## Mandatory order for bugs

1. **Build a feedback loop** — failing automated test preferred; structured manual QA checklist as fallback.
2. **Reproduce** — same symptom the user reported.
3. **Hypothesise** — 3–5 ranked, falsifiable; show user before testing.
4. **Instrument** — one variable at a time; tagged `[DEBUG-xxxx]` only.
5. **Fix + regression test** at the **correct seam** (where the bug actually manifests).
6. **Cleanup + post-mortem** — grep `[DEBUG-`; state what test/checklist would prevent recurrence.

## Bans

- No session-scoped log files (`.cursor/debug-*.log`, one-off debug modules).
- No fix without a loop when automation is feasible.
- No declaring done on unit tests alone when the bug is UI/focus/gesture/keyboard.
- No scope expansion beyond `docs/foundation/OVERVIEW.md` or a spec issue without updating docs or creating an issue.

## Flutter projects

- Match **presentation mode** in widget tests (sheet vs panel, route, breakpoint).
- Read focus/pointer/keyboard handlers before instrumenting.
- Prefer `AppLog.debug(tag, ...)` or `debugPrint('[DEBUG-tag] ...')`.
- See `skills/product/tdd/tests-flutter.md` for widget test patterns.

## During dev

If the bug reveals missing acceptance criteria, update **`docs/engineering/ops/manual-qa-*.md`** or the GitHub issue — not ad-hoc fixes only.
