# Refactor Candidates

After all tests are GREEN, look for:

- **Duplication** → extract function or module
- **Long methods** → break into private helpers (keep tests on the public interface, not the helpers)
- **Shallow modules** → combine or deepen (see [deep-modules.md](deep-modules.md))
- **Feature envy** → move logic to where the data lives
- **Primitive obsession** → introduce a value object or named type
- **Existing code** the new code reveals as problematic — now is a good time to fix it while context is fresh

## Rules

- Run tests after **every** refactor step — not just at the end
- If tests go RED during refactor, undo and diagnose before continuing
- Never refactor while RED — get to GREEN first, then clean up
- Do not add new behavior during refactor — that belongs in a new RED→GREEN cycle
