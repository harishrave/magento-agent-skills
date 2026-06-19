# Unit Test Generation for a Module

Systematic workflow to **write** PHPUnit unit tests for classes in `app/code/Vendor/Module/`.
Patterns adapted from [ProcessEight — Testing in Magento 2](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747).

## Agent prompt (copy-paste)

```
Write PHPUnit unit tests for RaveDigital_StoreLocator per unit-test-generation.md.

Target classes:
- Model/StoreHours.php
- Model/Validator/CoordinateValidator.php

Mock all dependencies. Place under Test/Unit/. Run phpunit command when done.
```

## Step 1 — Pick classes to test

Prioritize:

1. Classes with business logic (validators, calculators, services)
2. Plugins and observers (test plugin class directly)
3. View models with non-trivial methods

Skip for unit tests: repositories, resource models, controllers (use integration).

### Unit vs integration decision

Choose **unit** when ([ProcessEight](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747)):

- Few dependencies, mockable interfaces
- Single-method behavior, black-box input/output
- No database, filesystem, or HTTP

Choose **integration** when:

- Repository save/load, collections, di.xml wiring
- Controllers, routes, module registration

## Step 2 — File layout

Class `RaveDigital\StoreLocator\Model\StoreHours` →

```
Test/Unit/Model/StoreHoursTest.php
namespace RaveDigital\StoreLocator\Test\Unit\Model;
```

Rules:

- Suffix `Test` on class and file
- Mirror source directory under `Test/Unit/`
- `declare(strict_types=1);`
- Extend `PHPUnit\Framework\TestCase`

## Step 3 — Scaffold test class

```php
<?php
declare(strict_types=1);

namespace RaveDigital\StoreLocator\Test\Unit\Model;

use Magento\Framework\App\Config\ScopeConfigInterface;
use PHPUnit\Framework\TestCase;
use RaveDigital\StoreLocator\Model\StoreHours;

class StoreHoursTest extends TestCase
{
    private ScopeConfigInterface $scopeConfig;
    private StoreHours $subject;

    protected function setUp(): void
    {
        $this->scopeConfig = $this->createMock(ScopeConfigInterface::class);
        $this->subject = new StoreHours($this->scopeConfig);
    }

    public function testReturnsEmptyHoursWhenFeatureDisabled(): void
    {
        $this->scopeConfig->method('isSetFlag')->willReturn(false);
        $this->assertSame([], $this->subject->getOpenHours('soho', '2026-06-20'));
    }
}
```

## Step 4 — Mocking rules

| Rule | Detail |
|---|---|
| Mock **interfaces** only | `createMock(ScopeConfigInterface::class)` |
| Abstract interfaces | `getMockBuilder(Interface::class)->getMockForAbstractClass()` — not `setMethods()` subset |
| Expectations | Always chain `->method('name')` with `expects()` |
| No ObjectManager | Instantiate class under test with `new` + mocks |
| Test behavior | Assert outputs and side effects — not private methods |

### Mock example with expectations

```php
$this->scopeConfig->expects($this->once())
    ->method('isSetFlag')
    ->with('ravedigital_storelocator/general/enabled', \Magento\Store\Model\ScopeInterface::SCOPE_STORE)
    ->willReturn(true);
```

### Plugin unit test

```php
$plugin = new ValidateStoreCoordinates($this->storeHoursMock);
$quote = $this->createMock(\Magento\Quote\Api\Data\CartInterface::class);
$result = $plugin->beforeSave($this->quoteRepositoryMock, $quote);
$this->assertIsArray($result);
```

## Step 5 — Data providers

```php
/**
 * @dataProvider invalidHourProvider
 */
public function testRejectsInvalidHour(int $hour): void
{
    $this->expectException(\InvalidArgumentException::class);
    $this->subject->assertValidHour($hour);
}

public static function invalidHourProvider(): array
{
    return ['negative' => [-1], 'too high' => [24]];
}
```

## Step 6 — Exceptions

```php
public function testThrowsWhenStoreCodeEmpty(): void
{
    $this->expectException(\InvalidArgumentException::class);
    $this->expectExceptionMessage('Store code is required');
    $this->subject->getOpenHours('', '2026-06-20');
}
```

## Step 7 — Naming conventions

| Good | Bad |
|---|---|
| `testReturnsEmptyHoursWhenDisabled` | `testGetOpenHours` |
| `testRejectsInvalidHour` | `testHour` |

Name tests after **scenario + expected outcome**.

## Step 8 — Run and iterate

```bash
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit/Model/StoreHoursTest.php
```

Fix until green, then run full module unit suite:

```bash
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit
```

## Coverage guidance (RaveDigital)

- At least one test per public method with non-trivial logic
- Happy path + one failure/edge case per method
- Plugins: test that logic runs **and** does not run when conditions not met
- Do not chase 100% coverage with meaningless asserts

## Common generation mistakes

| Mistake | Fix |
|---|---|
| `getMockBuilder` with incomplete `setMethods()` on interface | Use `getMockForAbstractClass()` or `createMock()` |
| ObjectManager in unit test | Constructor-inject mocks |
| Testing Magento core | Only test `app/code/Vendor/Module` |
| Identical tests in two classes, one fails | Add `@magentoAppIsolation` on integration only — unit tests should not share state |

## Handoff

After unit tests pass, run [static-analysis.md](static-analysis.md) on the same module.
