# {{PROJECT_NAME}}

## Documentation

Product workflow and file roles: [`docs/README.md`](docs/README.md).

## Agent skills

Slash commands are installed per-machine in `~/.claude/skills/` (Claude Code) and `~/.cursor/skills/` (Cursor).

Two lanes (full flow in [`docs/README.md`](docs/README.md)): **feature** for never-built
capability, **maintenance** for shipped behavior.

| Situation | Start with |
|-----------|-----------|
| New feature / capability | `/ask-about-problems` → `/ask-about-solutions` → `/to-spec` → `/to-tickets` |
| Bug / regression on shipped behavior | `/diagnose` → `/create-ticket` |
| Implement a filed issue | `/tdd` (or `/afk-dev` for a batch) → `/review-code` |
| Missing docs layout | `/init-docs` |

Generic rules: `~/.cursor/rules/` (Cursor) — see the agent-skills README for wiring.
