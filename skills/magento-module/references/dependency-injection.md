# Dependency Injection in Magento Modules

The ObjectManager reads merged `di.xml` files and wires constructors. Module code never calls
`ObjectManager::getInstance()` — inject dependencies explicitly.

## Where to place di.xml

| Path | Scope |
|---|---|
| `etc/di.xml` | Global (every area) |
| `etc/frontend/di.xml` | Storefront HTTP |
| `etc/adminhtml/di.xml` | Admin panel |
| `etc/webapi_rest/di.xml` | REST API |
| `etc/graphql/di.xml` | GraphQL |
| `etc/crontab/di.xml` | Cron workers |

Register plugins in the narrowest area that needs them. A storefront-only formatter plugin
in global `di.xml` also runs during cron and API calls.

## Constructor injection

```php
namespace RaveDigital\StoreLocator\Model;

use Magento\Framework\App\Config\ScopeConfigInterface;
use Psr\Log\LoggerInterface;

class StoreHours
{
    public function __construct(
        private readonly ScopeConfigInterface $scopeConfig,
        private readonly LoggerInterface $logger,
    ) {}
}
```

- Type-hint interfaces (`ScopeConfigInterface`, `LoggerInterface`) over concrete classes.
- Do not inject `RequestInterface`, session, or registry into domain models — keep those in
  controllers, view models, or GraphQL resolvers.
- Constructors should assign only; no I/O, no business logic (plugins cannot intercept `__construct`).

## Factories for new instances

DI shares singletons. For a fresh model or collection per operation, inject the generated factory:

```php
public function __construct(
    private readonly \RaveDigital\StoreLocator\Model\StoreLocationFactory $locationFactory,
) {}

public function buildLocation(): \RaveDigital\StoreLocator\Model\StoreLocation
{
    return $this->locationFactory->create();
}
```

Never hand-write `StoreLocationFactory` — `setup:di:compile` generates it under `generated/`.

## Proxies for lazy dependencies

When a dependency is expensive but used on only some code paths, inject a proxy via `di.xml`:

```xml
<type name="RaveDigital\StoreLocator\Console\Command\SyncGeocodesCommand">
    <arguments>
        <argument name="releaseService"
                  xsi:type="object">RaveDigital\StoreLocator\Model\GeocodeService\Proxy</argument>
    </arguments>
</type>
```

CLI is the classic case: Magento instantiates **every** registered command on each
`bin/magento` invocation. Proxy anything that opens network connections or loads large config.

## Virtual types

Configure a class variant without writing a subclass:

```xml
<virtualType name="RaveDigitalStoreLocatorLogger" type="Magento\Framework\Logger\Monolog">
    <arguments>
        <argument name="handlers" xsi:type="array">
            <item name="storelocator" xsi:type="object">RaveDigitalStoreLocatorLogHandler</item>
        </argument>
    </arguments>
</virtualType>
<virtualType name="RaveDigitalStoreLocatorLogHandler" type="Magento\Framework\Logger\Handler\Base">
    <arguments>
        <argument name="fileName" xsi:type="string">/var/log/ravedigital_storelocator.log</argument>
    </arguments>
</virtualType>
<type name="RaveDigital\StoreLocator\Model\GeocodeService">
    <arguments>
        <argument name="logger" xsi:type="object">RaveDigitalStoreLocatorLogger</argument>
    </arguments>
</type>
```

Plugins cannot target virtual type names — they intercept the underlying concrete class.

## Argument type reference

```xml
<argument name="enabled" xsi:type="boolean">true</argument>
<argument name="maxSlots" xsi:type="number">12</argument>
<argument name="path" xsi:type="const">RaveDigital\StoreLocator\Model\Config::XML_PATH_ENABLED</argument>
<argument name="service" xsi:type="object">RaveDigital\StoreLocator\Model\DistanceCalculator</argument>
<argument name="service" xsi:type="object" shared="false">RaveDigital\StoreLocator\Model\DistanceCalculator</argument>
<argument name="stores" xsi:type="array">
    <item name="nyc" xsi:type="string">new_york</item>
</argument>
```

Array arguments **merge** across modules (later modules in `sequence` override same keys) —
ideal for adding validators or handlers to core arrays.

## Inspect wiring before you add plugins

```bash
bin/magento dev:di:info "RaveDigital\StoreLocator\Api\LocationRepositoryInterface"
```

Shows preferences, constructor args, and plugin stack. After refactors, clear stale generated code:

```bash
rm -rf generated/code generated/metadata
bin/magento setup:di:compile
```
