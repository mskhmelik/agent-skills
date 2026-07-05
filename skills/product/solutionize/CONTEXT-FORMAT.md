# CONTEXT.md Format

Repo output: **`docs/foundation/CONTEXT.md`**. Produced by `/solutionize`. Consumed by `/get-prd`, `/unslop-repo`, and dev agents.

This is **domain / product vocabulary** — not the architectural lexicon in `unslop-repo/LANGUAGE.md` (module, seam, adapter, depth, etc.).

## Structure

```markdown
# {Project Name} — Context

One or two sentences: what this vocabulary covers and why it exists.

## Terms

**Order**:
A request from a customer to fulfill goods or services.
_Avoid_: purchase, transaction

**Invoice**:
A payment request sent after delivery.
_Avoid_: bill, payment request
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick one. List others under `_Avoid:_`.
- **Keep definitions tight.** One or two sentences. Define what it IS, not what it does.
- **Project-specific only.** General programming concepts (timeout, DTO, handler) do not belong.
- **No implementation details.** Glossary only — not a spec or scratch pad.
- **Module names must match.** Names in `solution_overview.md` feature/module trees use these bold terms exactly.
- **Flag ambiguities** under `## Flagged ambiguities` when a term is used two ways — resolve before `/get-prd` if load-bearing.
- **Resolve raw terms.** Each entry in `problem_summary.md` → **Terms surfaced (raw)** should become a canonical term or move to Open questions in `solution_overview.md`.

## During `/solutionize`

- Sharpen terms inline as the conversation crystallizes — update `docs/foundation/CONTEXT.md` when saving outputs.
- Do not duplicate the full glossary inside `solution_overview.md`; link to `CONTEXT.md` instead.

## Single vs multi-area repos

**Most repos:** one `docs/foundation/CONTEXT.md`.

**Multiple bounded areas:** optional `docs/CONTEXT-MAP.md` listing per-area context files and relationships. Only split when terms genuinely conflict across areas.
