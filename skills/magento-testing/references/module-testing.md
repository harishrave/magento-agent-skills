# Module-Scoped Testing

Run and validate tests for **one** `Vendor_Module` under `app/code/Vendor/Module/`.

## Discover module test layout

```
app/code/RaveDigital/StoreLocator/
├── Test/
│   ├── Unit/              # PHPUnit, no Magento bootstrap
│   └── Integration/       # Bootstrap + test DB
│       └── _files/        # Optional fixtures
```

If `Test/` is missing, the module has no automated tests yet — use [unit-test-generation.md](unit-test-generation.md).

## Register module in PHPUnit (if needed)

Copy and customize from Magento's dist config. Add a testsuite pointing at your vendor:

```xml
<!-- dev/tests/unit/phpunit.xml (project-level copy) -->
<testsuite name="RaveDigital Unit Tests">
    <directory>../../../app/code/RaveDigital/*/Test/Unit</directory>
</testsuite>
```

For one module only:

```xml
<testsuite name="RaveDigital StoreLocator">
    <directory>../../../app/code/RaveDigital/StoreLocator/Test/Unit</directory>
</testsuite>
```

Integration — see [integration-testing.md](integration-testing.md) for `TESTS_INSTALL_CONFIG_FILE` and DB setup.

## Run all tests for one module

Replace `RaveDigital/StoreLocator` with your path:

```bash
# Unit — fast, run first
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit

# Single test class
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit/Model/StoreHoursTest.php

# Filter by name
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  --filter StoreHoursTest

# Integration — slower, requires test DB
vendor/bin/phpunit -c dev/tests/integration/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Integration
```

Alternative Magento CLI (if `Magento_Developer` enabled):

```bash
bin/magento module:enable Magento_Developer
bin/magento dev:tests:run unit -- --filter RaveDigital
```

## Smoke test — environment OK

Before writing new tests, verify the rig runs ([ProcessEight quick start](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747)):

```php
public function testTestEnvironmentIsSetupCorrectly(): void
{
    $this->assertTrue(true);
}
```

Run it; if this fails, fix PHPUnit config before adding real tests.

## Module health integration tests

Standard integration checks for any custom module (from ProcessEight patterns):

### Module registered

```php
public function testModuleIsRegistered(): void
{
    $registrar = new \Magento\Framework\Component\ComponentRegistrar();
    $this->assertArrayHasKey(
        'RaveDigital_StoreLocator',
        $registrar->getPaths(\Magento\Framework\Component\ComponentRegistrar::MODULE)
    );
}
```

### Module enabled in test env

```php
use Magento\TestFramework\Helper\Bootstrap;

public function testModuleIsEnabled(): void
{
    $om = Bootstrap::getObjectManager();
    $moduleList = $om->create(\Magento\Framework\Module\ModuleList::class);
    $this->assertTrue($moduleList->has('RaveDigital_StoreLocator'));
}
```

### Plugin wired in di.xml

```php
public function testPluginIsConfiguredInGlobalScope(): void
{
    $om = Bootstrap::getObjectManager();
    $pluginList = $om->create(\Magento\TestFramework\Interception\PluginList::class);
    $pluginInfo = $pluginList->get(\Magento\Quote\Api\CartRepositoryInterface::class, []);
    $this->assertArrayHasKey('ravedigital_storelocator_validate', $pluginInfo);
}
```

## Module test checklist

| Step | Command |
|---|---|
| 1. Compile | `bin/magento setup:di:compile` |
| 2. Unit tests | `phpunit …/Test/Unit` |
| 3. PHPCS | [static-analysis.md](static-analysis.md) |
| 4. PHPStan | [static-analysis.md](static-analysis.md) |
| 5. Integration | `phpunit …/Test/Integration` |

## Decision: what to test in this module

| Class type | Test type | Reference |
|---|---|---|
| Service / validator / helper | Unit | [unit-test-generation.md](unit-test-generation.md) |
| Repository / resource model | Integration | [integration-testing.md](integration-testing.md) |
| Plugin logic | Unit (plugin class) or Integration (wiring) | Both references |
| Controller | Integration (`AbstractBackendController`) | ProcessEight gist — Controllers section |
| Routes | Integration | `Route\ConfigInterface` |

## Troubleshooting module-only runs

| Symptom | Fix |
|---|---|
| `No tests executed!` | Path wrong; class/file name mismatch (`FeatureTest.php` → `class FeatureTest`) |
| Tests from other modules run | Narrow path to `app/code/Vendor/Module/Test/Unit` |
| Class not found | `composer dump-autoload`; PSR-4 in module `composer.json` |

See [test-troubleshooting.md](test-troubleshooting.md) for full playbook.
