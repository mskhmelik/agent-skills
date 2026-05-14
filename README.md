# agent-skills

Personal skills for AI coding agents. A single `skills/` folder works across Claude Code and Cursor — both use the identical `SKILL.md` format.

## Skill Index

| Skill | Description | Tags |
|-------|-------------|------|
| [caveman](skills/caveman/SKILL.md) | Ultra-compressed communication mode — drops filler/articles/pleasantries, keeps full technical accuracy (~75% token reduction) | meta, productivity |
| [contemplate](skills/contemplate/SKILL.md) | Process new sources in Obsidian vault `sources/` → update `ai_memory/` with summaries, concepts, and entity pages (Karpathy LLM Wiki pattern) | vault, knowledge |
| [get-prd](skills/get-prd/SKILL.md) | (3/3) Synthesize problem + solution docs into `docs/prd.md`; strict no-open-questions rule; outputs vertical build-order slices | thinking, planning |
| [get-yt-transcript](skills/get-yt-transcript/SKILL.md) | Download a YouTube transcript; optional auto-summary saved as `.md` with YAML frontmatter; keep/delete choice at end | personal, productivity |
| [handoff](skills/handoff/SKILL.md) | Compact the current conversation into a temp handoff doc so a fresh agent session can continue the work; references existing artifacts rather than duplicating them | meta, productivity |
| [learn-brand](skills/learn-brand/SKILL.md) | Extract a client's brand guidelines (colors, fonts, logo) from screenshots and their website; saves a self-contained `brand-guidelines.html` to Google Drive | design, client |
| [linkedin-connect](skills/linkedin-connect/SKILL.md) | Find external attendees from recent calendar meetings and send them LinkedIn connection requests | personal, productivity |
| [make-secure](skills/make-secure/SKILL.md) | Audit active skills for security vulnerabilities; risk-classified report with interactive remediation | security, meta |
| [problematize](skills/problematize/SKILL.md) | (1/3) Structured problem investigation interview using Rob Fitzpatrick's Mom Test methodology; saves problem-summary.md | thinking, research |
| [prd-to-issues](skills/prd-to-issues/SKILL.md) | (4/4) Break prd.md into vertical-slice GitHub issues with HITL/AFK classification and dependency ordering | thinking, planning |
| [remember](skills/remember/SKILL.md) | Save content (posts, articles, transcripts, excerpts) into Obsidian vault `sources/` as a formatted source note; upstream of `/contemplate` | vault, knowledge |
| [solutionize](skills/solutionize/SKILL.md) | (2/3) Solution design interview — surfaces, stress-tests, and structures options; saves solution-summary.md | thinking, research |
| [tdd](skills/tdd/SKILL.md) | Red-green-refactor TDD loop driven by a GitHub issue; acceptance criteria become the test spec | dev, testing |
| [upwork-plan](skills/upwork-plan/SKILL.md) | Turn an Upwork brief into a shareable 3-slide HTML proposal deck saved to the Desktop | client, productivity |

## How it works

- **File sync** keeps the `skills/` folder up to date across devices (Windows + macOS)
- **GitHub** provides version history and public sharing
- **Private skills** stay in the same folder but are excluded via `.git/info/exclude` (local only) — they sync to your devices but never reach GitHub

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
4. For private skills: add `skills/<name>/` to `.git/info/exclude` (never pushed)

## Skill file format

```yaml
---
name: skill-name
description: One-line trigger description shown in the agent UI
argument-hint: <optional argument hint>
---

Markdown instructions the agent follows when this skill is invoked.
```
