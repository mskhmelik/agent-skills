# Agent notes (this repo)

Optional repo-specific pointers. Generic skills and rules are installed per-machine:

- **Skills:** `~/.claude/skills/` (Claude Code) · `~/.cursor/skills/` (Cursor)
- **Rules:** `~/.cursor/rules/` (Cursor) — wire via [agent-skills README](https://github.com/mskhmelik/agent-skills#setup-once-per-machine)

## This repo

- **Issue tracker:** _GitHub Issues / other — fill in when known_
- **Launch / env:** _e.g. `env/dev.json`, `.vscode/launch.json`_
- **Manual QA:** _link `docs/engineering/ops/manual-qa-*.md` if present_
- **Domain docs:** [`docs/README.md`](../README.md), [`docs/foundation/OVERVIEW.md`](../foundation/OVERVIEW.md), [`docs/foundation/DICTIONARY.md`](../foundation/DICTIONARY.md)

## When to invoke skills

Two lanes (see [`docs/README.md`](../README.md) for the full flow): **feature lane** for
never-built capability, **maintenance lane** for shipped behavior.

| Situation | Skill |
|-----------|-------|
| New repo or missing docs layout | `/init-docs` |
| Understand the problem | `/ask-about-problems` |
| Design the solution | `/ask-about-solutions` |
| Commit scope → spec issue on GitHub | `/to-spec` |
| Slice the spec into tickets | `/to-tickets` |
| File a bug/QA finding on shipped behavior | `/create-ticket` |
| Implement issue / feature | `/tdd` |
| Review a PR before merge | `/review-code` |
| Bug or regression | `/diagnose` |
