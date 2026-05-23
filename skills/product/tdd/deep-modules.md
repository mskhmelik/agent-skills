# Deep Modules

For repo-wide architecture reviews, see **`/unslop-repo`** and its [LANGUAGE.md](../unslop-repo/LANGUAGE.md) (seam, adapter, leverage, locality).

From *A Philosophy of Software Design* (Ousterhout).

**Deep module** = small interface + lots of implementation

```
┌─────────────────────┐
│   Small Interface   │  ← few methods, simple params
├─────────────────────┤
│                     │
│                     │
│  Deep Implementation│  ← complex logic hidden inside
│                     │
│                     │
└─────────────────────┘
```

**Shallow module** = large interface + thin implementation (avoid)

```
┌─────────────────────────────────┐
│       Large Interface           │  ← many methods, complex params
├─────────────────────────────────┤
│  Thin Implementation            │  ← just passes through
└─────────────────────────────────┘
```

## Why it matters for TDD

Testing at a deep module's boundary is clean: the interface is small, so there are few behaviors to specify. Internal complexity is hidden, so tests don't need to know about it.

Testing shallow modules is painful: the interface is wide, so tests multiply. Internal pass-through logic means tests are brittle (they break when structure changes, even when behavior is fine).

## Questions to ask when designing

- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity inside?
- Could two shallow modules be one deep module?

## Refactoring toward depth

After a TDD cycle, look for shallow modules created during the GREEN phase — they're common because minimal code to pass a test is often a thin pass-through. The refactor step is the right time to deepen them.
