# Test Completion Checklist

Before marking testing work done:

## Structure

- [ ] Unit tests under `Test/Unit/`; integration under `Test/Integration/`
- [ ] Namespace matches PSR-4 (`Vendor\Module\Test\Unit\...`)
- [ ] `declare(strict_types=1);` on new test files
- [ ] Test class name matches filename (`StoreHoursTest.php` → `class StoreHoursTest`)

## Unit tests

- [ ] Extend `PHPUnit\Framework\TestCase`
- [ ] All dependencies mocked — no DB, no ObjectManager in unit tests
- [ ] Test method names describe scenario (`testReturnsEmptyWhenDisabled`)
- [ ] Happy path + at least one edge/failure case per non-trivial method

## Integration tests

- [ ] `@magentoDbIsolation` on tests that write data
- [ ] Dependencies from `Bootstrap::getObjectManager()`
- [ ] Fixtures in `Test/Integration/_files/` when reusable setup needed
- [ ] Module registration test if new module ([module-testing.md](module-testing.md))

## Static analysis (module-scoped)

- [ ] `vendor/bin/phpcs --standard=Magento2 app/code/Vendor/Module` — no new critical violations
- [ ] `phpstan analyse app/code/Vendor/Module` — no new errors at project level (if PHPStan configured)
- [ ] See [static-analysis.md](static-analysis.md)

## Execution

- [ ] `vendor/bin/phpunit` passes for added/changed tests
- [ ] Full module path run: `phpunit … app/code/Vendor/Module/Test/Unit`
- [ ] No skipped tests without comment
- [ ] Tests deterministic — no `sleep()`, mock time when needed

## Version upgrade (if applicable)

- [ ] Baseline captured before upgrade ([version-upgrade-testing.md](version-upgrade-testing.md))
- [ ] `setup:di:compile` passes on target version
- [ ] Test + static analysis results compared to baseline

## Scope

- [ ] Tests cover the change — not 100% coverage for its own sake
- [ ] No trivial `assertTrue(true)` tests left in production suite
