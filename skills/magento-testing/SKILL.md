---
name: magento-testing
description: >-
  Magento 2 / Mage-OS / Adobe Commerce automated testing: PHPUnit unit and integration tests,
  module-scoped test runs, version upgrade regression testing, writing unit tests for specific
  modules, PHPCS (Magento2 coding standard) and PHPStan static analysis on app/code modules,
  test directory layout (Test/Unit, Test/Integration), @magentoAppIsolation, @magentoDbIsolation,
  fixtures, and troubleshooting. Use when the user asks to add, fix, or run tests; test after
  Magento upgrade; run tests for Vendor_Module; write unit tests for a module; run phpcs or
  phpstan on app/code; mock dependencies; or test Repository, Model, Plugin. For implementing
  module code use magento-module. For project audits use magento-audit. Do NOT trigger for
  MFTF/browser tests unless explicitly requested, or non-Magento test frameworks.
requires: magento-module
---

# Magento Module Testing (RaveDigital)

PHPUnit, static analysis, and upgrade regression workflows for custom modules under `app/code/`.

## Workflow — pick your task

| Task | Read first |
|---|---|
| Write unit tests for a module | [references/unit-test-generation.md](references/unit-test-generation.md) |
| Run all tests for one module | [references/module-testing.md](references/module-testing.md) |
| Test after version/patch upgrade | [references/version-upgrade-testing.md](references/version-upgrade-testing.md) |
| PHPCS + PHPStan on a module | [references/static-analysis.md](references/static-analysis.md) |
| Unit test patterns (mocks, providers) | [references/unit-testing.md](references/unit-testing.md) |
| Integration tests (DB, Bootstrap) | [references/integration-testing.md](references/integration-testing.md) |
| Failures / flaky tests | [references/test-troubleshooting.md](references/test-troubleshooting.md) |
| Pre-merge checklist | [references/test-checklist.md](references/test-checklist.md) |

Reference: [ProcessEight — Testing in Magento 2](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747).

## Test types

| Type | Location | Boots Magento? | Use for |
|---|---|---|---|
| **Unit** | `Test/Unit/` | No — mocks only | Services, validators, plugins, view models |
| **Integration** | `Test/Integration/` | Yes | Repositories, di.xml, routes, module registration |
| **Static** | PHPCS / PHPStan | No | Coding standard and type safety on module path |

## Quick commands (module-scoped)

Replace `RaveDigital/StoreLocator` with your module path:

```bash
# Unit tests
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit

# Integration tests
vendor/bin/phpunit -c dev/tests/integration/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Integration

# PHPCS (Magento2 standard)
vendor/bin/phpcs --standard=Magento2 app/code/RaveDigital/StoreLocator

# PHPStan
vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator --level=5
```

## Master prompts (copy-paste)

**Unit tests for a module:**

```
Write PHPUnit unit tests for RaveDigital_StoreLocator per unit-test-generation.md.
Target Model/StoreHours and plugins with mocked dependencies. Run phpunit when done.
```

**Full module test gate:**

```
Run module-testing.md workflow for RaveDigital_StoreLocator: unit tests, PHPCS, PHPStan.
Report pass/fail summary.
```

**After upgrade:**

```
We upgraded from 2.4.7-p7 to 2.4.8-p4. Run version-upgrade-testing.md for all app/code modules.
Compare setup:di:compile and test results.
```

## Unit test rules (RaveDigital)

- Extend `PHPUnit\Framework\TestCase`
- Mock interfaces — `createMock()` or `getMockForAbstractClass()` for large interfaces
- No `ObjectManager::getInstance()` in unit tests
- `declare(strict_types=1);` on new files
- Descriptive method names: `testReturnsEmptyWhenDisabled`

## Integration annotations

- `@magentoDbIsolation` — DB writes rolled back
- `@magentoAppIsolation` — reset app state
- `@magentoDataFixture` — load fixture PHP

## Decision shortcuts

| User says | Action |
|---|---|
| "Test Vendor_Module" | [module-testing.md](references/module-testing.md) |
| "Write unit tests for …" | [unit-test-generation.md](references/unit-test-generation.md) |
| "Test after upgrade" | [version-upgrade-testing.md](references/version-upgrade-testing.md) |
| "Run phpcs/phpstan on module" | [static-analysis.md](references/static-analysis.md) |
| "PHPUnit fails with …" | [test-troubleshooting.md](references/test-troubleshooting.md) |

## Handoffs

| After testing finds… | Skill |
|---|---|
| Code/schema fixes | **magento-module** |
| Upgrade blockers (version) | **magento-audit** version-and-security |
| Missing admin test coverage | **magento-admin-ui** (manual/MFTF if requested) |

## Mage-OS notes

Same `dev/tests/unit` and `dev/tests/integration` layout as Magento 2.4.x.

## Agent compatibility

Install with `./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
See [docs/install.md](../../docs/install.md).
