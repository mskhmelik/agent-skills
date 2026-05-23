# agent-skills

Personal **skills** and **rules** for Cursor and Claude Code. One `skills/` folder, identical `SKILL.md` format, symlinked on each machine. Syncs via OneDrive; version history on GitHub.

## Layout

```
agent-skills/
├── README.md
├── setup/
│   ├── setup.sh              ← macOS: per-skill symlinks in ~/.claude/skills + ~/.cursor/skills
│   └── setup.ps1             ← Windows
├── setup-cursor-wiring.sh    ← macOS: also wires ~/.cursor/rules
├── skills/
│   ├── product/              ← product workflow chain (public)
│   ├── vault/                ← knowledge/Obsidian tools (public)
│   ├── utilities/            ← session + dev utilities (public)
│   └── private/              ← private skills (.git/info/exclude, never pushed)
├── rules/                    ← Cursor rules (loaded via ~/.cursor/rules symlink; Cursor only)
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

### product/

| Skill | Role |
|-------|------|
| [init-docs](skills/product/init-docs/SKILL.md) | Scaffold `docs/` layout |
| [problematize](skills/product/problematize/SKILL.md) | (1/4) Mom Test problem investigation |
| [solutionize](skills/product/solutionize/SKILL.md) | (2/4) Solution stress-test + `CONTEXT.md` |
| [get-prd](skills/product/get-prd/SKILL.md) | (3/4) Synthesize `docs/prd.md` |
| [prd-to-issues](skills/product/prd-to-issues/SKILL.md) | (4/4) Vertical-slice GitHub issues |
| [tdd](skills/product/tdd/SKILL.md) | Red-green-refactor from issue or bug |
| [diagnose](skills/product/diagnose/SKILL.md) | Disciplined debug loop |
| [unslop-repo](skills/product/unslop-repo/SKILL.md) | Shallow → deep module reviews |

### vault/

| Skill | Role |
|-------|------|
| [contemplate](skills/vault/contemplate/SKILL.md) | Ingest Obsidian `sources/` → wiki |
| [remember](skills/vault/remember/SKILL.md) | Save content to vault sources |
| [get-yt-transcript](skills/vault/get-yt-transcript/SKILL.md) | YouTube transcript download |

### utilities/

| Skill | Role |
|-------|------|
| [handoff](skills/utilities/handoff/SKILL.md) | Compact session for next agent |
| [caveman](skills/utilities/caveman/SKILL.md) | Ultra-compressed replies |
| [make-secure](skills/utilities/make-secure/SKILL.md) | Audit skills for security risks |

### private/ (excluded from git, never pushed)

| Skill | Role |
|-------|------|
| [local-skill] | Calendar → LinkedIn connection requests |
| [local-skill] | Extract + save client brand guidelines |
| [local-skill] | Upwork brief → proposal deck |

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills): `/diagnose`, `/unslop-repo` (improve-codebase-architecture).

---

## Adding a skill

1. Copy [`templates/SKILL-template.md`](templates/SKILL-template.md) → `skills/<group>/<name>/SKILL.md`
   - `<group>` = `product`, `vault`, `utilities`, or `private`
2. Fill frontmatter + instructions
3. Re-run `bash setup/setup.sh` to add the new symlink
4. Add a row to the index above (omit private skills)
5. For private skills: add `skills/private/<name>/` to `.git/info/exclude`

## Archive

`4_learning/claude/skills-main/` is an old bundle — **do not copy from it**. Port skills explicitly.
