# Agent notes (this repo)

Optional repo-specific pointers. Generic skills and rules live in OneDrive:

- **Skills:** `5_projects/ai/skills/` (Cursor: `~/.cursor/skills`)
- **Rules:** `5_projects/ai/rules/` (wire via `setup-cursor-wiring.sh`)

## This repo

- **Issue tracker:** _GitHub Issues / other — fill in when known_
- **Launch / env:** _e.g. `env/dev.json`, `.vscode/launch.json`_
- **Manual QA:** _link `docs/manual_qa_*.md` if present_
- **Domain docs:** [`docs/README.md`](../README.md), [`docs/prd.md`](../prd.md)

## When to invoke skills

| Situation | Skill |
|-----------|-------|
| New repo or missing docs layout | `/init-docs` |
| Understand the problem | `/problematize` |
| Design the solution | `/solutionize` |
| Commit scope to PRD | `/get-prd` |
| Break PRD into issues | `/prd-to-issues` |
| Implement issue / feature | `/tdd` |
| Bug or regression | `/diagnose` |
