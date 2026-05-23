# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, SMS, etc.)
- Databases (sometimes — prefer a real test DB when practical)
- Time / randomness
- File system (sometimes)

Don't mock:
- Your own classes or modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock.

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```
// Easy to mock
function processPayment(order, paymentClient):
  return paymentClient.charge(order.total)

// Hard to mock — creates its own dependency
function processPayment(order):
  client = new StripeClient(env.STRIPE_KEY)
  return client.charge(order.total)
```

**2. Prefer specific functions over generic fetchers**

Create one function per external operation instead of one generic dispatcher:

```
// GOOD: each function is independently mockable
api.getUser(id)
api.getOrders(userId)
api.createOrder(data)

// BAD: mocking requires conditional logic inside the mock
api.fetch(endpoint, options)
```

The specific approach means:
- Each mock returns one shape
- No conditional logic in test setup
- Easy to see which operations a test exercises
