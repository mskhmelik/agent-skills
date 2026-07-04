# {{PROJECT_NAME}}

## Documentation

Product workflow and file roles: [`docs/README.md`](docs/README.md).

## Agent skills

Slash commands are installed per-machine in `~/.claude/skills/` (Claude Code) and `~/.cursor/skills/` (Cursor).

| Situation | Skill |
|-----------|-------|
| Bug / regression | `/diagnose` |
| Feature (GitHub issue) | `/tdd` |
| Missing docs layout | `/init-docs` |

Generic rules: `~/.cursor/rules/` (Cursor) — see the agent-skills README for wiring.
