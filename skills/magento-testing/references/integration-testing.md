# Integration Testing Magento Modules

Integration tests bootstrap Magento's test framework and use the real ObjectManager (in a test sandbox).

## Setup

Tests live in `Test/Integration/` and run with:

```bash
vendor/bin/phpunit -c dev/tests/integration/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Integration
```

First run may require installing the test DB — follow your project's `dev/tests/integration/etc/install-config.php` or `INTEGRATION_TESTS_DB_*` env vars.

## Bootstrap pattern

```php
use Magento\TestFramework\Helper\Bootstrap;

$objectManager = Bootstrap::getObjectManager();
$this->repository = $objectManager->get(LocationRepositoryInterface::class);
```

Get dependencies from Bootstrap — do not call `ObjectManager::getInstance()` in test bodies.

## Database isolation

```php
/**
 * @magentoDbIsolation
 */
public function testDeleteLocation(): void
{
    // DB changes rolled back after this method
}
```

Use on every test that writes to the database unless using a dedicated fixture cleanup.

## App isolation

```php
/**
 * @magentoAppIsolation
 */
```

Resets application state between tests when tests mutate config, registry, or singletons.

## Data fixtures

```php
/**
 * @magentoDataFixture RaveDigital\StoreLocator\Test\Integration\_files/locations.php
 */
public function testListReturnsFixtureRows(): void
{
    $list = $this->repository->getList($this->searchCriteria);
    $this->assertGreaterThan(0, $list->getTotalCount());
}
```

Fixture file `Test/Integration/_files/locations.php`:

```php
use RaveDigital\StoreLocator\Api\LocationRepositoryInterface;
use Magento\TestFramework\Helper\Bootstrap;

$om = Bootstrap::getObjectManager();
/** @var LocationRepositoryInterface $repo */
$repo = $om->get(LocationRepositoryInterface::class);
// create and save test entities
```

## Module registration tests

See [module-testing.md](module-testing.md) for `ComponentRegistrar` and `ModuleList` integration tests.

## API contract tests

Integration tests are the right place to verify:

- Repository CRUD round-trips
- SearchCriteria filtering on `getList()`
- Extension attributes persist correctly
- Plugins registered in di.xml actually run (with focused assertions)

## Performance

Keep integration tests fast:

- Minimal fixture data
- Avoid full reindex in tests
- Do not loop hundreds of saves — batch or use unit tests for loops

## Debugging failures

| Failure | Check |
|---|---|
| `Connection refused` | Integration test DB not configured |
| `Table doesn't exist` | Run `setup:upgrade` on test instance |
| Stale config | Add `@magentoAppIsolation` |
| Data leaks between tests | Add `@magentoDbIsolation` |

More fixes: [test-troubleshooting.md](test-troubleshooting.md)
