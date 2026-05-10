# Coverage thresholds considered harmful

The skill does not gate CI on test coverage. This is a deliberate choice; here's why.

## The argument for coverage gates

"If we drop below X% coverage, fail the build. This forces engineers to write tests."

Sounds reasonable. In practice it produces:

- **Nominal tests**. Tests that exercise lines without asserting meaningful behavior. They hit coverage but don't catch bugs. Worse: they pass when bugs are introduced, giving false confidence.
- **Coverage games**. Engineers write the *cheapest* tests that satisfy the threshold, not the *most useful* ones.
- **Test deletion friction**. When a test is genuinely redundant, deleting it now drops coverage and might fail the build. So the test stays, slowing CI.
- **Refactor friction**. Removing dead code drops coverage (the dead code's tests went with it). The threshold punishes the cleanup.

The metric measures *what's tested*, but what we want to know is *whether the tests catch bugs*. These are different.

## What the skill does instead

- **Track coverage if you want to see it.** `pytest --cov`, `vitest --coverage`, etc., are fine. Print the number; don't gate on it.
- **Pre-merge checklist** in CLAUDE.md asks "tests added if behavior changed?" — a human answer to a human question.
- **Property-based tests** for invariants where they apply (see [`property-based-testing.md`](./property-based-testing.md)). One property test exercises far more cases than coverage measures.

## When coverage gates make sense

If your project has compliance requirements that demand a specific coverage number, you're stuck with a gate. In that case, set the threshold low (60–70%) so it catches genuine regressions without forcing nominal tests.

For projects without that constraint, skip the gate. Use coverage as a diagnostic, not a target.

## See also

Goodhart's Law: "When a measure becomes a target, it ceases to be a good measure." Coverage is the canonical example in software testing.
