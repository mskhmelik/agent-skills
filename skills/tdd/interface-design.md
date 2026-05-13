# Interface Design for Testability

Good interfaces make testing natural. Before writing any code, check for these traps.

## 1. Accept dependencies, don't create them

```
// Testable
function processOrder(order, paymentGateway): ...

// Hard to test — creates its own gateway inside
function processOrder(order): ...
  gateway = new StripeGateway()
```

Inject external dependencies as parameters. Tests can then pass fakes or stubs.

## 2. Return results, don't produce side effects

```
// Testable
function calculateDiscount(cart) -> Discount: ...

// Hard to test — mutates state, returns nothing
function applyDiscount(cart) -> void:
  cart.total -= discount
```

Pure functions (input → output, no side effects) are the easiest to test. When side effects are necessary, isolate them at the boundary.

## 3. Small surface area

- Fewer methods = fewer tests needed
- Fewer parameters = simpler test setup
- If a module needs many methods to be useful, consider whether it's doing too much

## 4. See also

[deep-modules.md](deep-modules.md) — how to structure modules so boundaries are clean and testable.
