# Property-based testing

The skill does not scaffold a property-based-testing harness. It's a powerful tool but stack-specific and easy to misuse. This doc captures when to add it.

## When property-based testing earns its complexity

Use it when your code has an **invariant** that's easier to state than to enumerate. Classic shapes:

- **Round-trip identity**: `parse(serialize(x)) == x`. Libreta's markdown round-trip is exactly this.
- **Idempotence**: `f(f(x)) == f(x)`. Common in normalization, deduplication.
- **Commutativity / associativity**: `f(a, b) == f(b, a)`. Common in set operations, merges.
- **Refinement**: `expensive_correct(x) == fast_optimized(x)`. Confirms an optimization.
- **Total ordering**: `compare(a, b) + compare(b, a) == 0`. Common in sort comparators.

If your code has any of these shapes, write the property test first; example-based tests can come second to pin specific edge cases.

## When *not* to use it

- For UI code. Generators don't generate "user clicked the button after typing in the field"; example tests do.
- For code with side effects on real systems. Hypothesis-style libraries can shrink failures, but reproducing "this particular shrunk failure required these network calls" is painful.
- For code where the invariant is unclear. If you can't state the invariant in a sentence, you don't have a property — you have a bunch of examples.

## Tools by stack

- Python: `hypothesis` (the canonical implementation)
- TypeScript / JavaScript: `fast-check`
- Rust: `proptest` or `quickcheck`
- Go: `testing/quick` (built-in, limited) or `gopter`

## Where to put property tests

Same place as example-based tests, in their own file:

```
tests/
├── unit/
│   ├── test_serializer.py            # example tests
│   └── test_serializer_properties.py # property tests
```

They're not a separate test layer; they're a kind of unit test.

## CI considerations

Property-based tests have variable runtime. A test with 100 default inputs takes longer than a single example. In CI, set seeds so failures are reproducible, and consider a longer schedule for the property suite (e.g. nightly with more inputs).
