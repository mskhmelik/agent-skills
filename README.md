# agent-skills

Personal skills for AI coding agents. A single `skills/` folder works across Claude Code and Cursor — both use the identical `SKILL.md` format.

## Skill Index

| Skill | Description | Claude | Cursor | Tags |
|-------|-------------|:------:|:------:|------|
| [caveman](skills/caveman/SKILL.md) | Ultra-compressed communication mode — drops filler/articles/pleasantries, keeps full technical accuracy (~75% token reduction) | ✓ | ✓ | meta, productivity |
| [code-smart](skills/code-smart/SKILL.md) | Behavioral guidelines to reduce common LLM coding mistakes (Karpathy-style) | ✓ | ✓ | coding, meta |
| [get-yt-transcript](skills/get-yt-transcript/SKILL.md) | Download a YouTube video transcript as plain text | ✓ | — | personal, productivity |
| [linkedin-connect](skills/linkedin-connect/SKILL.md) | Find external attendees from recent calendar meetings and send LinkedIn connection requests | ✓ | — | personal, productivity |
| [make-secure](skills/make-secure/SKILL.md) | Audit active skills for security vulnerabilities; risk-classified report with interactive remediation | ✓ | ✓ | security, meta |
| [get-prd](skills/get-prd/SKILL.md) | Synthesize problem-summary.md + solution-summary.md into a committed PRD; saves prd.md | ✓ | ✓ | thinking, planning |
| [problematize](skills/problematize/SKILL.md) | Structured problem investigation interview using Rob Fitzpatrick's Mom Test methodology; saves problem-summary.md | ✓ | ✓ | thinking, research |
| [solutionize](skills/solutionize/SKILL.md) | Solution design interview — surfaces, stress-tests, and structures options; saves solution-summary.md | ✓ | ✓ | thinking, research |

## How it works

- **File sync** keeps the `skills/` folder up to date across devices (Windows + macOS)
- **GitHub** provides version history and public sharing
- **Private skills** stay in the same folder but are listed in `.gitignore` — they sync to your devices but never reach GitHub

## Setup on a new machine

Clone or sync this repo somewhere on your machine, then run the setup script for your OS:

**macOS:**
```bash
bash ~/path/to/agent-skills/setup/setup.sh
```

**Windows:**
```powershell
& "$env:USERPROFILE\path\to\agent-skills\setup\setup.ps1"
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
