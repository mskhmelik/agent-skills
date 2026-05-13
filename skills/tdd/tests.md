# Good and Bad Tests

## Good Tests

**Integration-style**: test through real interfaces, not mocks of internal parts.

```
// GOOD: tests observable behavior
test "user can checkout with valid cart":
  cart = createCart()
  cart.add(product)
  result = checkout(cart, paymentMethod)
  assert result.status == "confirmed"
```

Characteristics:
- Tests behavior callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: coupled to internal structure.

```
// BAD: tests implementation details
test "checkout calls paymentService.process":
  mockPayment = mock(paymentService)
  checkout(cart, payment)
  assert mockPayment.process was called with cart.total
```

Red flags:
- Mocking internal collaborators
- Testing private methods
- Asserting on call counts or order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT

## Bypassing the interface (also bad)

```
// BAD: bypasses interface to verify
test "createUser saves to database":
  createUser(name: "Alice")
  row = db.query("SELECT * FROM users WHERE name = 'Alice'")
  assert row exists

// GOOD: verifies through interface
test "createUser makes user retrievable":
  user = createUser(name: "Alice")
  retrieved = getUser(user.id)
  assert retrieved.name == "Alice"
```

The second test survives any storage change (DB, file, cache) as long as the interface contract holds.
