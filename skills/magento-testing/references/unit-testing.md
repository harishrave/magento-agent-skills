# Unit Testing Magento Modules

Unit tests run **without** booting Magento. Mock every dependency injected into the class under test.

## When unit tests fit

- Pure PHP logic (date math, slot validation, string formatting)
- Services that only need mocked `ScopeConfigInterface`, `LoggerInterface`, etc.
- Plugins/observers after extracting logic into a dedicated class

## When unit tests do not fit

- Repository save/load against the database → use integration tests
- Verifying di.xml wiring end-to-end → integration test
- Layout or ui_component rendering → manual or MFTF (out of scope)

## Structure

```
Test/Unit/<Path>/<ClassName>Test.php
```

Namespace: `RaveDigital\StoreLocator\Test\Unit\...` (append `\Test\Unit` after vendor module segment).

## Mocking constructor deps

```php
$logger = $this->createMock(LoggerInterface::class);
$logger->expects($this->once())->method('info')->with($this->stringContains('soho'));

$subject = new GeocodeService($logger, $locationFactory);
```

Use `createMock()` for interfaces. For final classes without interfaces, consider extracting an interface or testing via integration.

## Testing plugins

Prefer unit-testing the plugin class directly:

```php
$subject = new ValidateStoreCoordinates($storeHours);
$quote = $this->createMock(CartInterface::class);
$result = $subject->beforeSave($quoteRepository, $quote);
$this->assertIsArray($result);
```

Mock the **first argument** (intercepted type) lightly — focus on your plugin's behavior.

## Data providers

```php
/**
 * @dataProvider invalidHourProvider
 */
public function testRejectsInvalidHour(int $hour): void
{
    $this->expectException(\InvalidArgumentException::class);
    (new SlotValidator())->assertValidHour($hour);
}

public static function invalidHourProvider(): array
{
    return [[-1], [24], [99]];
}
```

## Running

From Magento root — see [module-testing.md](module-testing.md) for full module-scoped runs:

```bash
vendor/bin/phpcs --standard=Magento2 app/code/RaveDigital/StoreLocator  # after tests pass
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit/Model/StoreHoursTest.php
```

Filter by class:

```bash
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist --filter StoreHoursTest
```

## Writing new tests

Use [unit-test-generation.md](unit-test-generation.md) for step-by-step class selection and scaffolding.

## Common mistakes

| Mistake | Fix |
|---|---|
| Extending Magento integration base class in Unit/ | Use `PHPUnit\Framework\TestCase` |
| Real DB calls in unit test | Mock the repository interface |
| Testing private methods | Test via public API or refactor |
| Missing `declare(strict_types=1);` | Add for new RaveDigital test files |
| Incomplete interface mock | Use `createMock()` or `getMockForAbstractClass()` — see [test-troubleshooting.md](test-troubleshooting.md) |
