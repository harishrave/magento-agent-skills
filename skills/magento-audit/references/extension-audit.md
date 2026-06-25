# Extension Audit

**Category 3** — every installed module: custom, third-party, core.

## Evidence to collect

```bash
bin/magento module:status
composer show -i 2>/dev/null | head -80
ls app/code/
grep -r '"name":' app/code/*/composer.json 2>/dev/null
```

For vendor packages:

```bash
composer show vendor/package 2>/dev/null
```

## Per-module assessment

For each **custom** (`app/code`) and **sampled third-party** module, document:

| Field | Source |
|---|---|
| Module name | `module:status` |
| Vendor | Namespace / composer vendor |
| Version | `composer.json` / `setup_module` |
| Purpose | `module.xml` description, README, or inferred |
| Supported | Packagist/GitHub last release vs Magento patch |
| Deprecated | Abandoned >2 years, PHP incompatibility |
| Duplicate functionality | Two modules solving same problem |
| Unused | Disabled or zero references in di.xml/events |
| Adobe compatibility | Vendor compatibility matrix if published |
| PHP compatibility | `composer.json` `php` constraint |
| Upgrade risk | Preferences on core, InstallSchema, PHP 8.x breaks |

## Red flags

| Pattern | Severity |
|---|---|
| Same feature in 2+ extensions (e.g. two SEO suites) | **Medium**–**High** |
| Disabled module still in `app/code` with plugins active | **Medium** |
| `composer.json` requires PHP 7.x on PHP 8.2 store | **High** |
| Unknown `app/code` vendor with obfuscated code | **Critical** — escalate |
| Core module disabled without documented reason | **High** |

## Third-party vendor sample

Prioritize high-risk extensions: checkout, payment, search, cache, SEO, admin tools.

> **Extension:** Amasty_SeoToolkit v2.x — compatible with 2.4.7; vendor lists 2.4.8 support. **Upgrade risk:** Low. **Note:** Overlaps with native meta — review duplicate canonical tags.

## Unable to verify

Full `vendor/` inventory without `composer.lock`:

> **Unable to verify:** Complete third-party extension list — require `composer.lock` or `composer show -i` from deployment environment.

## Handoff

Removal or refactor → **magento-module**. Admin UX of extension config → **magento-module**.
