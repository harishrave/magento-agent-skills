# CLI Commands, Cron, and Message Queues

Background work shares one rule: thin entry class, injected service does the real work.

## Console commands

Register in `etc/di.xml` on `Magento\Framework\Console\CommandList`:

```xml
<type name="Magento\Framework\Console\CommandList">
    <arguments>
        <argument name="commands" xsi:type="array">
            <item name="ravedigital_storelocator_sync"
                  xsi:type="object">RaveDigital\StoreLocator\Console\Command\SyncGeocodesCommand</item>
        </argument>
    </arguments>
</type>
```

```php
namespace RaveDigital\StoreLocator\Console\Command;

use Magento\Framework\Console\Cli;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class SyncGeocodesCommand extends Command
{
    public function __construct(
        private readonly \RaveDigital\StoreLocator\Model\GeocodeService $releaseService,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this->setName('ravedigital:storelocator:sync-geocodes')
            ->setDescription('Geocode store locations missing coordinates')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Report only');
        parent::configure();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        try {
            $count = $this->releaseService->releaseExpired((bool) $input->getOption('dry-run'));
            $output->writeln("<info>Synced {$count} location(s).</info>");
            return Cli::RETURN_SUCCESS;
        } catch (\Throwable $e) {
            $output->writeln("<error>{$e->getMessage()}</error>");
            return Cli::RETURN_FAILURE;
        }
    }
}
```

- Proxy heavy constructor deps — every command is built on every `bin/magento` call.
- Return `Cli::RETURN_SUCCESS` / `RETURN_FAILURE` integers.
- Commands run in `AREA_GLOBAL`; use `Store\Model\App\Emulation` when store context matters.

## Cron

`etc/crontab.xml`:

```xml
<group id="default">
    <job name="ravedigital_storelocator_sync"
         instance="RaveDigital\StoreLocator\Cron\SyncGeocodes"
         method="execute">
        <schedule>0 * * * *</schedule>
    </job>
</group>
<group id="ravedigital_storelocator">
    <job name="ravedigital_storelocator_reindex"
         instance="RaveDigital\StoreLocator\Cron\ReindexLocations"
         method="execute">
        <config_path>ravedigital_storelocator/cron/reminder_schedule</config_path>
    </job>
</group>
```

```php
namespace RaveDigital\StoreLocator\Cron;

class SyncGeocodes
{
    public function __construct(
        private readonly \RaveDigital\StoreLocator\Model\GeocodeService $releaseService,
        private readonly \Psr\Log\LoggerInterface $logger,
    ) {}

    public function execute(): void
    {
        try {
            $this->releaseService->releaseExpired(false);
        } catch (\Throwable $e) {
            $this->logger->error('Store locator geocode cron failed: ' . $e->getMessage());
        }
    }
}
```

Cron requires system crontab calling `bin/magento cron:run` every minute (`cron:install` on new servers).
Use `<config_path>` when merchants should edit schedule in admin. Always catch exceptions — one
uncaught error can stall a cron group. Debug via `cron_schedule` table.

## Message queues

For work that must not block HTTP or a single cron tick (bulk export, webhook fan-out):

```xml
<!-- communication.xml -->
<topic name="ravedigital.storelocator.index" request="RaveDigital\StoreLocator\Api\Data\LocationInterface"/>

<!-- queue_consumer.xml -->
<consumer name="storeLocatorIndex"
          queue="ravedigital.storelocator.index"
          handler="RaveDigital\StoreLocator\Model\IndexHandler::process"/>
```

Publish: `PublisherInterface::publish('ravedigital.storelocator.index', $dto)`.

Run: `bin/magento queue:consumers:start storeLocatorIndex` or `cron_consumers_runner` in `env.php`.

## Verify

```bash
bin/magento setup:upgrade && bin/magento setup:di:compile
bin/magento ravedigital:storelocator:sync-geocodes --dry-run
bin/magento cron:run --group=ravedigital_storelocator
bin/magento queue:consumers:list
```
