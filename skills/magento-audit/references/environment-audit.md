# Environment Audit

**Category 1** — platform baseline. Run first in every full audit.

## Evidence to collect

```bash
bin/magento --version
bin/magento deploy:mode:show
bin/magento cache:status
bin/magento module:status
bin/magento config:show web/unsecure/base_url
php -v
composer --version 2>/dev/null
composer show magento/product-community-edition 2>/dev/null || \
  composer show magento/product-enterprise-edition 2>/dev/null || \
  composer show mage-os/product-community-edition 2>/dev/null
```

Read `app/etc/env.php` (redact secrets in report) for cache/session/search backends.

## Checklist

| Item | How | Report if missing |
|---|---|---|
| Magento version + patch | `bin/magento --version` | Unable to verify |
| Edition | composer.lock product metapackage | Open Source / Adobe Commerce / Mage-OS |
| PHP version | `php -v` | Compare to [system requirements](https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/system-requirements.html) |
| Composer version | `composer --version` | Info |
| Database | `env.php` → `db` connection | MySQL / MariaDB version if queryable |
| Redis / Valkey | `env.php` cache/session | Not configured → note opportunity |
| RabbitMQ | `env.php` message consumers | Unable to verify if not in repo |
| OpenSearch / Elasticsearch | `env.php` search config | MySQL search → **High** for large catalogs |
| Web server | User input / hosting docs | Unable to verify from code alone |
| Deployment mode | `deploy:mode:show` | **developer** in production → **Critical** |
| Cache status | `cache:status` | Disabled caches → performance risk |
| Installed modules | `module:status` | Count enabled/disabled custom modules |
| Theme | `config:show design/theme/theme_id` or DB | Active theme path |

## Report table

| Component | Current | Supported? | Notes |
|---|---|---|---|
| Magento | e.g. 2.4.7-p7 | Y/N | Target patch recommendation |
| PHP | e.g. 8.2.28 | Y/N | |
| Database | | | |
| Redis | | | |
| Search | | | |
| Mode | production/developer | | |

## Inputs unavailable

If SSH, `env.php`, or hosting access is missing:

> **Unable to verify:** Redis, RabbitMQ, web server, PHP-FPM pool — recommend infrastructure appendix with hosting provider export.

See [version-and-security.md](version-and-security.md) for patch/CVE detail.
