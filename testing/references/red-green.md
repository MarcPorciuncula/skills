# Red-green workflow

Use this workflow only after the main skill admits a test for a production
behaviour change.

## Red

1. Write the smallest test that expresses the admitted behaviour.
2. Run the narrowest command that executes it.
3. Confirm that the test compiles and runs.
4. Confirm that it fails because the behaviour is missing, not because the
   imports, fixture, harness, or environment are wrong.
5. Record the command and relevant failure in the test-decision artifact.

Do NOT edit production code until the admitted test fails for the intended
reason.

If the test passes before implementation, fix or reject the test. A passing
test does not demonstrate the new behaviour.

## Green

1. Write the minimum production change that satisfies the failing behaviour.
2. Run the same narrow test command.
3. Confirm that the admitted test and its immediate neighbours pass.

Do not add unadmitted edge cases, error paths, abstractions, or higher-level
tests during green.

## Refactor

Refactor only when the passing implementation or related tests have something
to improve. Keep the narrow tests passing and apply the main skill's related-test
audit.

Repeat red, green, and refactor for the next admitted independent behaviour.

## Commit policy

For ordinary implementation work, keep the observed red phase local and commit
the passing result under the repository's normal commit policy.

When the user explicitly requests committed red-green history, commit and push
the failing test before implementation, then commit and push green. Do not infer
this mode from a general request to implement or test a change.
