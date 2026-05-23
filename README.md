# agent-skills

Personal **skills** and **rules** for Cursor and Claude Code. One `skills/` folder, identical `SKILL.md` format, symlinked on each machine. Syncs via OneDrive; version history on GitHub.

## Layout

```
agent-skills/
├── README.md
├── setup/
│   ├── setup.sh              ← macOS: ~/.claude/skills + ~/.cursor/skills
│   └── setup.ps1             ← Windows
├── setup-cursor-wiring.sh    ← macOS: also wires ~/.cursor/rules
├── skills/                   ← slash commands
│   └── init-docs/templates/  ← per-repo doc scaffolds
├── rules/                    ← generic Cursor rules (all projects)
└── templates/SKILL-template.md
```

## Setup (once per machine)

**macOS — skills for Claude + Cursor:**

```bash
bash /path/to/agent-skills/setup/setup.sh
```

**macOS — also wire Cursor rules:**

```bash
chmod +x /path/to/agent-skills/setup-cursor-wiring.sh
./setup-cursor-wiring.sh
```

**Windows:**

```powershell
& "$env:USERPROFILE\path\to\agent-skills\setup\setup.ps1"
```

Restart Cursor / Claude after wiring.

Private skills live under `skills/` but are listed in `.git/info/exclude` — they sync on your devices but never reach GitHub.

---

## Product workflow (any repo)

Run **`/init-docs`** once to scaffold `docs/`. Then:

| Step | Skill | Output |
|------|-------|--------|
| 1 | `/problematize` | `docs/problem_summary.md` (+ raw terms) |
| 2 | `/solutionize` | `docs/solution_overview.md` + **`docs/CONTEXT.md`** |
| 3 | `/get-prd` | `docs/prd.md` (Glossary from CONTEXT) |
| 4 | `/prd-to-issues` | GitHub issues (vertical slices) |
| 5 | `/tdd` | Code + tests |
| — | `/diagnose` | Bugs — feedback loop first, regression test |
| — | `/unslop-repo` | Architecture hygiene (periodic) |

### CONTEXT vs LANGUAGE (don't mix them)

| File | Layer | Where |
|------|-------|-------|
| **`docs/CONTEXT.md`** | Domain / product vocabulary | Repo — written by `/solutionize` |
| **`unslop-repo/LANGUAGE.md`** | Architecture lexicon (module, seam, depth…) | Skill bundle only — used by `/unslop-repo` |

After shipping, run **`/unslop-repo`** when entropy builds up. It reads CONTEXT + PRD, proposes deepenings, may write `docs/modules/` and ADRs, then hand off refactors via `/prd-to-issues` → `/tdd`.

---

## Skill index

| Skill | Role |
|-------|------|
| [init-docs](skills/init-docs/SKILL.md) | Scaffold `docs/` layout |
| [problematize](skills/problematize/SKILL.md) | (1/3) Mom Test problem investigation |
| [solutionize](skills/solutionize/SKILL.md) | (2/3) Solution stress-test + `CONTEXT.md` |
| [get-prd](skills/get-prd/SKILL.md) | (3/3) Synthesize `docs/prd.md` |
| [prd-to-issues](skills/prd-to-issues/SKILL.md) | (4/4) Vertical-slice GitHub issues |
| [tdd](skills/tdd/SKILL.md) | Red-green-refactor from issue or bug |
| [diagnose](skills/diagnose/SKILL.md) | Disciplined debug loop |
| [unslop-repo](skills/unslop-repo/SKILL.md) | Shallow → deep module reviews |
| [handoff](skills/handoff/SKILL.md) | Compact session for next agent |
| [caveman](skills/caveman/SKILL.md) | Ultra-compressed replies |
| [contemplate](skills/contemplate/SKILL.md) | Ingest Obsidian `sources/` → wiki |
| [remember](skills/remember/SKILL.md) | Save content to vault sources |
| [get-yt-transcript](skills/get-yt-transcript/SKILL.md) | YouTube transcript download |
| [make-secure](skills/make-secure/SKILL.md) | Audit skills for security risks |
| [[local-skill]](skills/[local-skill]/SKILL.md) | Upwork brief → proposal deck |

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills): `/diagnose`, `/unslop-repo` (improve-codebase-architecture).

---

## Adding a skill

1. Copy [`templates/SKILL-template.md`](templates/SKILL-template.md) → `skills/<name>/SKILL.md`
2. Fill frontmatter + instructions
3. Add a row to the index above
4. For private skills: add `skills/<name>/` to `.git/info/exclude`

## Archive

`4_learning/claude/skills-main/` is an old bundle — **do not copy from it**. Port skills explicitly.
