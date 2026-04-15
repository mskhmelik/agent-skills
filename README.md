# agent-skills

Personal skills for AI coding agents. A single `skills/` folder works across Claude Code and Cursor — both use the identical `SKILL.md` format.

## Skill Index

| Skill | Description | Claude | Cursor | Tags |
|-------|-------------|:------:|:------:|------|
| [get-yt-transcript](skills/get-yt-transcript/SKILL.md) | Download a YouTube video transcript as plain text | ✓ | — | personal, productivity |
| [make-secure](skills/make-secure/SKILL.md) | Audit active skills for security vulnerabilities; risk-classified report with interactive remediation | ✓ | ✓ | security, meta |

## How it works

- **OneDrive** auto-syncs skills across devices (Windows + macOS)
- **GitHub** provides version history and public sharing
- **Private skills** stay in the same folder but are listed in `.gitignore` — they sync via OneDrive but never reach GitHub

## Setup on a new machine

**macOS:**
```bash
bash ~/OneDrive/5_projects/agent-skills/setup/setup.sh
```

**Windows:**
```powershell
& "$env:USERPROFILE\OneDrive\5_projects\agent-skills\setup\setup.ps1"
```

This creates junctions/symlinks from `~/.claude/skills` and `~/.cursor/skills` to this repo's `skills/` folder.

## Adding a skill

1. Copy `templates/SKILL-template.md` → `skills/<name>/SKILL.md`
2. Fill in frontmatter and instructions
3. Add a row to the index table above
4. For private skills: add `skills/<name>/` to `.gitignore` before committing

## Skill file format

```yaml
---
name: skill-name
description: One-line trigger description shown in the agent UI
argument-hint: <optional argument hint>
---

Markdown instructions the agent follows when this skill is invoked.
```
