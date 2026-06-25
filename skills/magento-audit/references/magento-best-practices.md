# Magento Best Practices

**Category 10** — platform operations, configuration, catalog, checkout.

## Evidence to collect

```bash
bin/magento cron:install 2>/dev/null; crontab -l 2>/dev/null
bin/magento indexer:status
bin/magento queue:consumers:list
bin/magento cache:status
bin/magento config:show catalog/search/engine
bin/magento config:show checkout/options/guest_checkout
ls -la var/log/ 2>/dev/null | head -10
du -sh pub/media/ 2>/dev/null
```

## Review areas

| Area | Checks |
|---|---|
| **Cron** | `cron:run` scheduled; `cron_schedule` backlog |
| **Consumers** | RabbitMQ consumers running for async ops |
| **Indexers** | Valid state; schedule vs update on save |
| **Cache** | FPC, block, layout enabled appropriately |
| **Configuration** | Scoped config; no secrets in DB dumps |
| **Logs** | `exception.log` growth; log level in prod |
| **Media** | `pub/media` size; old cache folders |
| **Catalog** | Flat catalog (legacy); EAV attribute count |
| **Search** | OpenSearch vs MySQL |
| **Checkout** | Guest checkout; min order; address validation |
| **Payment** | Test modes off in prod |
| **Shipping** | Real-time rates vs table rates |
| **Store config** | Base URLs, secure flags |
| **ACL** | Overly broad admin roles |
| **API / GraphQL** | Integration tokens; rate limits |

## Common findings

| Finding | Severity |
|---|---|
| `update on save` all indexers on high-traffic catalog | **High** |
| Cron not running | **Critical** |
| Guest checkout disabled without business reason | **Medium** |
| `developer` mode | **Critical** |
| Integration admin user with full ACL | **High** |

## Unable to verify

Production cron on server without SSH:

> **Unable to verify:** Cron execution — check `cron_schedule` table for recent `success` rows or server crontab.
