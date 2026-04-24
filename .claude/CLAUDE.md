# agent-skills — Security Rules for Skill Development

These rules apply whenever you create or edit any file in this repo.

## Never hardcode personal information

The public skills in this repo are shared on GitHub. Before writing any skill:

- **Paths** — never write absolute paths containing a real username. Use `~` (macOS/Linux) or `%USERPROFILE%` (Windows). Placeholders like `/path/to/file` are fine.
- **Email addresses** — never include real email addresses in public skills. Use `<your-email>` as a placeholder.
- **Real names** — never include real people's names (yours or others') in skill instructions or examples.
- **Company names, account IDs, folder structures** — never expose these in public skills.

## Private vs public skills

A skill is private if it contains any personal information, client data, account IDs, or credentials. Before creating such a skill:

1. Decide: is this private?
2. If yes — add `skills/<name>/` to `.git/info/exclude` **before** creating the file.
3. Never commit a private skill to git, even accidentally.

**Never create or modify `.gitignore`.** This repo has no `.gitignore` by design. Private skill exclusions live in `.git/info/exclude` (local-only, never pushed). If you need to exclude a file or directory, add it to `.git/info/exclude` — not `.gitignore`.

`feedback.jsonl` files are also private — never commit them. Add `skills/*/feedback.jsonl` to `.git/info/exclude` if you haven't already.

## feedback.jsonl — no PII in comments

When writing feedback entries, never include real people's names in comment strings. If a name appears in a comment, anonymize it before writing (e.g. "a contact" instead of a person's name).

## Cross-platform paths in skill instructions

Skills run on macOS and Windows. When referencing Claude or system paths:

| Instead of | Use |
|------------|-----|
| `C:\Users\msk\.claude\` | `~/.claude/` (macOS) or `%USERPROFILE%\.claude\` (Windows) |
| `/Users/michael.khmelik/...` | `~/...` |
| Absolute OneDrive paths | `~/OneDrive/...` or describe generically |

## When asked to create a skill

Before writing any content, ask yourself:
1. Does this skill need personal info to work? → make it private first
2. Will any paths I write contain a real username? → use `~` instead
3. Will any examples contain real names or emails? → use placeholders

Run `/make-secure` after creating any skill that executes shell commands, makes external calls, or handles user input.
