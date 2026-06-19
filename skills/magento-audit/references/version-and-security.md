# Version and Security Assessment

Audit the Magento platform version, patch level, and dependency security posture.

## Evidence to collect

```bash
bin/magento --version
php -v
composer show magento/product-community-edition 2>/dev/null
composer show mage-os/product-community-edition 2>/dev/null
composer outdated --direct
grep -E '"magento/|"mage-os/' composer.lock | head -30
```

Read `composer.json` / `composer.lock` for pinned versions and `extra.magento-force` or replace rules.

## Report format (example)

> **Magento Version:** Currently on **v2.4.7-p7**; recommend upgrading to **v2.4.8-p4** for the latest security patches in the 2.4.x line.
>
> **PHP:** 8.2.x — compatible with target release. Verify 8.3 if upgrading to 2.4.8+.
>
> **Risk:** Running N patch releases behind — review [Adobe security bulletins](https://helpx.adobe.com/security/products/magento.html) for applicable APSB entries.

Adapt numbers to what you actually find — never copy example versions blindly.

## Checklist

| Check | How | Severity if failed |
|---|---|---|
| Core patch level | `bin/magento --version` vs latest for minor line | **Critical** if known CVEs unpatched |
| PHP EOL | `php -v` vs Magento system requirements | **High** |
| Composer direct deps outdated | `composer outdated --direct` | **Medium**–**High** |
| Third-party modules abandoned | Packagist/GitHub last release date | **Medium** |
| `setup:upgrade` pending | `bin/magento setup:db:status` | **High** |
| Production mode | `bin/magento deploy:mode:show` | **Info** (dev mode in prod = **Critical**) |

## Mage-OS vs Adobe Commerce

| Platform | Version source |
|---|---|
| Adobe Commerce / Open Source | `magento/product-community-edition` or `magento/product-enterprise-edition` |
| Mage-OS | `mage-os/product-community-edition` |

Note Mage-OS versioning (e.g. 3.0.0) maps to Magento 2.4.x compatibility — cite Mage-OS release notes.

## Upgrade recommendations

Structure each recommendation:

1. **Target version** — specific patch (e.g. `2.4.8-p4`), not "latest" alone
2. **Prerequisites** — PHP, Elasticsearch/OpenSearch, MySQL version
3. **Blockers** — custom modules using removed APIs; list module names if found in code scan
4. **Suggested path** — incremental patches vs minor bump; staging validation steps

## Security (read-only audit)

- Admin URL not `/admin` (config `admin/url/custom`)
- Two-factor auth enabled for admin (`Magento_TwoFactorAuth`)
- Unmaintained `app/code` modules with `eval`, `shell_exec`, raw SQL in controllers
- Secrets in `env.php` committed to git (check `.gitignore`)

State clearly: full penetration testing is **out of scope** unless the engagement includes it.

## Pitfalls

| Mistake | Fix |
|---|---|
| Recommending 2.4.9 when project is on 2.4.6 | Match upgrade path to current minor line first |
| Ignoring composer patches | List `cweagans/composer-patches` entries |
| Only citing `composer.json` | Lock file is source of truth for deployed version |
