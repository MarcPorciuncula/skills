# Test-Driven Development

This skill is **rigid** — follow it exactly. The discipline has no exceptions for perceived simplicity or time pressure.

Skipping the verification plan or writing implementation before a failing test produces code that *appears* tested but isn't. The test suite becomes a liability: it passes regardless of whether the behavior is correct.

**Violating the letter of the rules is violating the spirit of the rules.**

## Red Flags — Stop

If you find yourself thinking any of these, stop — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This fix is too small for a full red-green cycle" | Small fixes are exactly where untested bugs hide. The cycle is fast for small changes. |
| "I already know the solution — I'll write tests after" | Tests written after implementation verify what you wrote, not what the code should do. |
| "I'll write all tests upfront, then implement everything" | This is not TDD. Each logical change gets its own cycle. |
| "The test is clearly failing — I don't need to check the failure message" | Tests can fail for the wrong reason (missing import, wrong setup). Verify the message points to missing behavior. |
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I need to explore first" | Fine. Throw away exploration, start with TDD. |
| "Test hard = design unclear" | Listen to test. Hard to test = hard to use. |
| "TDD will slow me down" | TDD faster than debugging. |
| "Existing code has no tests" | You're improving it. Add tests for the code you change. |

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? **Delete it.** Start over.

**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

Implement fresh from tests. Period.

**Why:** Keeping code you wrote before tests biases the tests. You'll test what you built, not what the code should do. "I'll just use it as a reference" means you'll adapt it, which means you're testing after. The sunk cost is already gone — keeping unverified code is technical debt.

---

A disciplined test-driven development workflow. Every logical change follows its own red-green-refactor cycle. A full implementation may produce multiple cycles: red, green, red, green, red, green.

## Before writing any tests

### 1. Understand the change

Read the code being changed or added. Understand what behavior is being introduced or modified.

### 2. Examine the existing test suite

Thoroughly review the existing tests for the affected code. Determine what needs to be added, modified, or removed. This is an opportunity to:

- Remove frivolous or redundant tests
- Restructure tests that use complex setup to indirectly test something that could be verified more directly
- Consolidate overlapping test cases

### 3. Plan your verification strategy

For each behavior you need to test, answer these questions before writing anything:

- **What assertion will I write?** What specific output, state change, or side effect will I check?
- **What input produces a detectably different result if the implementation is wrong?** If you can't answer this, you can't verify the behavior at this level.
- **If the implementation were buggy, would this test actually fail?** If the answer is "no" or "only with very contrived input," you're testing at the wrong level — go one level down and ask these questions again.

Once you find the level where behavior is directly verifiable in a function's inputs and outputs, that's where comprehensive test coverage belongs (edge cases, boundary conditions, error paths). Then write at least one higher-level test that exercises one path through the smaller unit, to verify the integration/wiring.

**Example — test lower:** A method processes items in batches. A sub-function splits items so no batch contains duplicate IDs. The public method produces the same final result regardless of how batches are split — a test on the public method cannot verify the splitting logic. Test the split function comprehensively, and add one integration test through the public method for wiring.

**Example — test higher:** A function validates input and returns an error. The error is directly observable in the return value. Test the public function — don't extract validation into a helper just to unit-test it.

## Red phase

1. Write or modify tests according to your verification plan. Add, change, or remove tests as needed.
2. **Tests MUST compile.** A test that doesn't compile is not "running red" — it's not running at all. Use real types, valid imports, and correct syntax. Stub or zero-initialize values where the implementation doesn't exist yet, but the test code itself must be valid.
3. Run the tests.

<HARD-GATE>
Do NOT proceed to implementation until:
- The test **compiles** without errors
- The test **runs and fails**
- The failure message **clearly points to the missing behavior** — not a setup error, wrong import, or misconfigured test harness

If the test passes before any implementation exists, the test is wrong. Fix it before continuing.
</HARD-GATE>

4. Commit the failing tests with a message describing what's being tested, e.g. `Add tests for batch deduplication` or `Update validation tests for new error cases`.

<Good>
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };

  const result = await retryOperation(operation);

  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```
Clear name, tests real behavior, one thing
</Good>

<Bad>
```typescript
test('retry works', async () => {
  const mock = jest.fn()
    .mockRejectedValueOnce(new Error())
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce('success');
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(3);
});
```
Vague name, tests mock not code
</Bad>

## Green phase

1. Write the **minimum code** to make the failing tests pass. No speculative code, no extra features.
2. Run the tests for the file/package under change and known callers (see `verification.md` "Scope of verification").
3. Commit the implementation with a normal descriptive message, e.g. `Implement batch deduplication` or `Add input validation for expired tokens`.

<Good>
```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === 2) throw e;
    }
  }
  throw new Error('unreachable');
}
```
Just enough to pass
</Good>

<Bad>
```typescript
async function retryOperation<T>(
  fn: () => Promise<T>,
  options?: {
    maxRetries?: number;
    backoff?: 'linear' | 'exponential';
    onRetry?: (attempt: number) => void;
  }
): Promise<T> {
  // YAGNI
}
```
Over-engineered
</Bad>

## Refactor phase

After green, clean up both production and test code while keeping tests passing. This is optional — only refactor if there's something to improve. If you do refactor, commit separately.

## Phased implementation

Do NOT write all tests for the entire change upfront. Break the implementation into logical steps. Each step gets its own red-green-refactor cycle:

1. Plan the sequence of logical changes needed
2. For the first logical change: red → green → refactor
3. For the next logical change: red → green → refactor
4. Repeat until the full implementation is complete

Each cycle should be small and focused. If you're writing more than a handful of related tests before implementing, the cycle is probably too large — split it.

## Test quality

- **Test names describe behavior, not implementation.** "rejects expired tokens" not "checks token.exp field".
- **One logical behavior per test.** Multiple assertions about the same behavior are fine. Testing unrelated behaviors in one test is not.
- **Failure messages should be informative.** When a test fails, the output should make it obvious what went wrong without reading the test source.

## Why Order Matters

**"I'll write tests after to verify it works"**

Tests written after code pass immediately. Passing immediately proves nothing:
- Might test wrong thing
- Might test implementation, not behavior
- Might miss edge cases you forgot
- You never saw it catch the bug

Test-first forces you to see the test fail, proving it actually tests something.

**"I already manually tested all the edge cases"**

Manual testing is ad-hoc. You think you tested everything but:
- No record of what you tested
- Can't re-run when code changes
- Easy to forget cases under pressure
- "It worked when I tried it" ≠ comprehensive

Automated tests are systematic. They run the same way every time.

**"Deleting X hours of work is wasteful"**

Sunk cost fallacy. The time is already gone. Your choice now:
- Delete and rewrite with TDD (X more hours, high confidence)
- Keep it and add tests after (30 min, low confidence, likely bugs)

The "waste" is keeping code you can't trust. Working code without real tests is technical debt.

**"TDD is dogmatic, being pragmatic means adapting"**

TDD IS pragmatic:
- Finds bugs before commit (faster than debugging after)
- Prevents regressions (tests catch breaks immediately)
- Documents behavior (tests show how to use code)
- Enables refactoring (change freely, tests catch breaks)

"Pragmatic" shortcuts = debugging in production = slower.

**"Tests after achieve the same goals — it's spirit not ritual"**

No. Tests-after answer "What does this do?" Tests-first answer "What should this do?"

Tests-after are biased by your implementation. You test what you built, not what's required. You verify remembered edge cases, not discovered ones.

Tests-first force edge case discovery before implementing. Tests-after verify you remembered everything (you didn't).

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Tests after achieve same goals" | Tests-after = "what does this do?" Tests-first = "what should this do?" |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code is technical debt. |
| "Keep as reference, write tests first" | You'll adapt it. That's testing after. Delete means delete. |
| "Need to explore first" | Fine. Throw away exploration, start with TDD. |
| "Test hard = design unclear" | Listen to test. Hard to test = hard to use. |
| "TDD will slow me down" | TDD faster than debugging. Pragmatic = test-first. |
| "Manual test faster" | Manual doesn't prove edge cases. You'll re-test every change. |
| "Existing code has no tests" | You're improving it. Add tests for existing code. |
| "Just this once" | No exceptions. |
| "This is different because..." | No it isn't. Delete code. Start with test. |

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write wished-for API. Write assertion first. Ask your human partner. |
| Test too complicated | Design too complicated. Simplify interface. |
| Must mock everything | Code too coupled. Use dependency injection. |
| Test setup huge | Extract helpers. Still complex? Simplify design. |

## Debugging Integration

Bug found? Write failing test reproducing it. Follow TDD cycle. Test proves fix and prevents regression.

Never fix bugs without a test.

## Testing Anti-Patterns

Tests must verify real behavior, not mock behavior. Mocks are a means to isolate, not the thing being tested.

**Core principle:** Test what the code does, not what the mocks do.

### Anti-Pattern 1: Testing Mock Behavior

```typescript
// ❌ BAD: Testing that the mock exists
test('renders sidebar', () => {
  render(<Page />);
  expect(screen.getByTestId('sidebar-mock')).toBeInTheDocument();
});

// ✅ GOOD: Test real component or don't mock it
test('renders sidebar', () => {
  render(<Page />);  // Don't mock sidebar
  expect(screen.getByRole('navigation')).toBeInTheDocument();
});
```

Before asserting on any mock element, ask: "Am I testing real component behavior or just mock existence?" If testing mock existence, delete the assertion or unmock the component.

### Anti-Pattern 2: Test-Only Methods in Production

```typescript
// ❌ BAD: destroy() only used in tests
class Session {
  async destroy() {  // Looks like production API!
    await this._workspaceManager?.destroyWorkspace(this.id);
  }
}

// ✅ GOOD: Test utilities handle test cleanup
// Session has no destroy() - it's stateless in production
// In test-utils/
export async function cleanupSession(session: Session) {
  const workspace = session.getWorkspaceInfo();
  if (workspace) {
    await workspaceManager.destroyWorkspace(workspace.id);
  }
}
```

Before adding any method to a production class, ask: "Is this only used by tests?" If yes, put it in test utilities instead.

### Anti-Pattern 3: Mocking Without Understanding

```typescript
// ❌ BAD: Mock breaks test logic
test('detects duplicate server', () => {
  // Mock prevents config write that test depends on!
  vi.mock('ToolCatalog', () => ({
    discoverAndCacheTools: vi.fn().mockResolvedValue(undefined)
  }));

  await addServer(config);
  await addServer(config);  // Should throw - but won't!
});

// ✅ GOOD: Mock at correct level
test('detects duplicate server', () => {
  vi.mock('MCPServerManager'); // Just mock slow server startup

  await addServer(config);  // Config written
  await addServer(config);  // Duplicate detected ✓
});
```

Before mocking any method: (1) What side effects does the real method have? (2) Does this test depend on any of those side effects? (3) Do I fully understand what this test needs? If unsure, run with the real implementation first, observe what needs to happen, then add minimal mocking.

### Anti-Pattern 4: Incomplete Mocks

```typescript
// ❌ BAD: Partial mock - only fields you think you need
const mockResponse = {
  status: 'success',
  data: { userId: '123', name: 'Alice' }
  // Missing: metadata that downstream code uses
};

// ✅ GOOD: Mirror real API completeness
const mockResponse = {
  status: 'success',
  data: { userId: '123', name: 'Alice' },
  metadata: { requestId: 'req-789', timestamp: 1234567890 }
};
```

Mock the COMPLETE data structure as it exists in reality, not just fields your immediate test uses. Partial mocks fail silently when code depends on omitted fields.

### Mock Red Flags

- Assertion checks for `*-mock` test IDs
- Methods only called in test files
- Mock setup is >50% of test
- Test fails when you remove mock
- Can't explain why mock is needed
- Mocking "just to be safe"

When mocks become too complex (setup longer than test logic, mocking everything to make test pass), consider integration tests with real components — often simpler than complex mocks.

## Verification Checklist

Before marking work complete:

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] Tests for the code under change pass (proportional scope per `verification.md`)
- [ ] Output pristine (no errors, warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

Can't check all boxes? You skipped TDD. Start over.
