# {{PROJECT_NAME}} — agent notes

The product workflow, file roles, and the two-lane flow live in
[`docs/README.md`](docs/README.md). The docs you read: [`docs/foundation/OVERVIEW.md`](docs/foundation/OVERVIEW.md)
(problem → system → workflows → decisions) and [`docs/foundation/DICTIONARY.md`](docs/foundation/DICTIONARY.md)
(canonical terms).

## This repo

- **Issue tracker:** _GitHub Issues / other — fill in when known_
- **Launch / env:** _e.g. `env/dev.json`, `.vscode/launch.json`_
- **Manual QA:** _link `docs/engineering/ops/manual-qa-*.md` if present_
- **Project board:** _how filed issues move (columns / statuses), if used_

## Skills

Installed per-machine: `~/.claude/skills/` (Claude Code), `~/.cursor/skills/` (Cursor).
Two lanes (full flow in [`docs/README.md`](docs/README.md)) — **feature** for never-built
capability, **maintenance** for shipped behavior.

| Situation | Start with |
|-----------|-----------|
| New feature / capability | `/ask-about-problems` → `/ask-about-solutions` → `/to-spec` → `/to-tickets` |
| Bug / regression on shipped behavior | `/diagnose` → `/create-ticket` |
| Implement a filed issue | `/tdd` (or `/afk-dev` for a batch) → `/review-code` |
| Missing docs layout | `/init-docs` |

Generic rules: `~/.cursor/rules/` (Cursor) — see the agent-skills README for wiring.
