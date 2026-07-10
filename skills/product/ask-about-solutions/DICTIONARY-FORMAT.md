# DICTIONARY.md Format

Repo output: **`docs/foundation/DICTIONARY.md`**. Produced by `/ask-about-solutions`.
Consumed by `/to-spec`, `/to-tickets`, `/unslop-repo`, and dev agents.

This is **domain / product vocabulary** — not the architectural lexicon in `unslop-repo/LANGUAGE.md` (module, seam, adapter, depth, etc.).

## Structure

```markdown
# {Project Name} — Dictionary

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
- **No implementation details.** Dictionary only — not a spec or scratch pad.
- **Component names must match.** Bold component names in `OVERVIEW.md` use these terms exactly.
- **Flag ambiguities** under `## Flagged ambiguities` when a term is used two ways — resolve before `/to-spec` if load-bearing.
- **Resolve raw terms.** Each entry in OVERVIEW.md → **Terms surfaced (raw)** should become a canonical term or stay listed as open.

## During `/ask-about-solutions`

- Sharpen terms inline as the conversation crystallizes — update `docs/foundation/DICTIONARY.md` the moment a term is resolved.
- Do not duplicate the dictionary inside `OVERVIEW.md`; component names reference it.

## Single vs multi-area repos

**Most repos:** one `docs/foundation/DICTIONARY.md`.

**Multiple bounded areas:** optional `docs/DICTIONARY-MAP.md` listing per-area dictionaries and relationships. Only split when terms genuinely conflict across areas.
