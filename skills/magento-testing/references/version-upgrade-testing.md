# Version Upgrade Testing

Regression testing after Magento/Mage-OS version or patch upgrades (e.g. 2.4.7-p7 → 2.4.8-p4).
Run **before** and **after** upgrade; compare results.

Reference: [ProcessEight Magento 2 testing notes](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747).

## Pre-upgrade baseline

Capture from Magento root:

```bash
bin/magento --version
php -v
composer show magento/product-community-edition 2>/dev/null || composer show mage-os/product-community-edition
bin/magento module:status > /tmp/modules-before.txt
bin/magento setup:db:status
bin/magento indexer:status
```

Run full test + static analysis baseline:

```bash
# All custom module unit tests
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist app/code/

# Per-module (example)
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist app/code/RaveDigital/StoreLocator/Test/Unit

# Integration (requires test DB)
vendor/bin/phpunit -c dev/tests/integration/phpunit.xml.dist app/code/

# Static analysis baseline
vendor/bin/phpcs --standard=Magento2 app/code/RaveDigital/StoreLocator
vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator -c phpstan.neon 2>/dev/null || true
```

Save output to `upgrade-test-baseline.txt` for diff after upgrade.

## Post-upgrade verification sequence

Run in order — stop and fix blockers before the next step:

```bash
composer install
bin/magento setup:upgrade
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f   # if production-like env
bin/magento indexer:reindex
bin/magento cache:flush
```

Then re-run the same PHPUnit and static analysis commands. **All previously passing tests must still pass.**

## Upgrade-specific test matrix

| Area | Command / check | Pass criteria |
|---|---|---|
| Core boots | `bin/magento --version` | Expected target patch |
| DI compiles | `setup:di:compile` | Exit 0 |
| DB schema | `setup:db:status` | No pending schema |
| Custom modules enabled | `module:status Vendor_Module` | Still enabled |
| Unit tests | `phpunit … app/code/Vendor/Module/Test/Unit` | 0 failures |
| Integration tests | `phpunit … app/code/Vendor/Module/Test/Integration` | 0 failures |
| PHPCS | `phpcs --standard=Magento2 app/code/Vendor/Module` | No new errors vs baseline |
| PHPStan | `phpstan analyse app/code/Vendor/Module` | No new errors vs baseline |

## PHPUnit version compatibility

Magento 2.4.x ships PHPUnit 9.x / 12.x depending on version — verify `vendor/bin/phpunit --version` matches project.

| Symptom | Fix |
|---|---|
| `Class 'PHPUnit_Framework_TestCase' not found` | Use `PHPUnit\Framework\TestCase` |
| `Interface 'PHPUnit\Framework\TestListener' not found` | PHPUnit version mismatch — align with `composer.lock` |
| Parse error on `fn` in vendor | PHP CLI version too old for dependencies |

## Integration test DB after upgrade

After minor/major bump, integration sandbox may need refresh:

```bash
# If TESTS_CLEANUP was disabled, clear sandbox
rm -rf dev/tests/integration/tmp/sandbox-*

# Re-copy install config if needed
cp dev/tests/integration/etc/install-config-mysql.php.dist \
   dev/tests/integration/etc/install-config-mysql.php
# Edit DB credentials, then re-run integration suite
```

Common post-upgrade integration failures:

| Error | Likely cause | Fix |
|---|---|---|
| `Area code not set` | Stale sandbox | Clear `dev/tests/integration/tmp/`; `TESTS_CLEANUP=enabled` |
| `Table doesn't exist` during install | Module queries DB in CLI constructor | Use `Proxy` in `di.xml` for heavy deps |
| `Bootstrap` not found | Wrong `phpunit.xml` | `-c dev/tests/integration/phpunit.xml.dist` |
| `No tests executed!` | Wrong path in testsuite XML | Path relative to `phpunit.xml`; suffix `Test.php` |

## Custom module compatibility checks

After upgrade, scan custom code for removed APIs:

```bash
rg "Zend_" app/code/Vendor/Module/
rg "InstallSchema|UpgradeSchema" app/code/Vendor/Module/
bin/magento dev:tests:run unit -- --filter Vendor_Module 2>/dev/null || true
```

Pair with **magento-audit** [version-and-security.md](../../magento-audit/references/version-and-security.md) for upgrade blockers report.

## Report template (upgrade test summary)

```markdown
## Upgrade test summary — [Vendor] [from] → [to]

- Unit tests: X passed, Y failed (was: X passed)
- Integration tests: …
- PHPCS: N new violations
- PHPStan: N new errors
- Blockers: [list]
- Recommended fixes: [hand off to magento-module]
```

## Agent workflow

When user asks to "test after upgrade":

1. Confirm target version installed (`bin/magento --version`)
2. Run `setup:di:compile` — must pass first
3. Run module-scoped unit tests → [module-testing.md](module-testing.md)
4. Run PHPCS/PHPStan → [static-analysis.md](static-analysis.md)
5. Run integration if test DB configured
6. Summarize delta vs baseline
