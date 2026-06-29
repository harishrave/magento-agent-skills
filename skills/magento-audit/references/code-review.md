# Code Review and Optimization

**Category 2** — custom code audit for `app/code/`, `app/design/`, `composer.json`, `composer.lock`.

Findings require [evidence-and-severity.md](evidence-and-severity.md). Implementation uses **magento-module**.

## Scan commands

```bash
bin/magento module:status | grep -E 'Custom|VendorPrefix|RaveDigital'
vendor/bin/phpcs --standard=Magento2 app/code/ --report=summary 2>/dev/null
rg "ObjectManager::getInstance" app/code/
rg "InstallSchema|UpgradeSchema" app/code/
rg "<preference for=" app/code/
rg "around[A-Z]" app/code/ --glob '*.php'
rg "->load\(\)" app/code/ --glob '*.php' | head -30
rg "SELECT .+ FROM" app/code/ --glob '*.php' -i
rg "Zend_" app/code/
```

## Project code checks

| Check | Evidence | Typical severity |
|---|---|---|
| ObjectManager usage | File:line | High |
| Preferences on core | `di.xml` path | Medium–High |
| Around plugins on hot paths | Plugin class + method | High |
| Heavy observers (`sales_*`, `catalog_*`) | `events.xml` | Medium–High |
| Large classes (>500 LOC) | File path | Medium |
| Large methods (>50 LOC) | File:line | Medium |
| Duplicate / dead code | rg unused classes | Low–Medium |
| Repository vs Collection misuse | `Collection->load()` in loops | High |
| Raw SQL in modules | `query()` / raw strings | High |
| Deprecated APIs | Registry, InstallSchema, Zend | High |
| Plugin conflicts | Same method, multiple around | High |
| XML validation | `xmllint` or compile errors | Medium |
| DI issues | `setup:di:compile` output | High |
| Exception handling | Empty catch, exposed traces | Medium |
| SOLID violations | God classes, tight coupling | Medium |
| Coding standards | PHPCS summary | Medium |
| Performance anti-patterns | N+1, sync API in checkout | High |

| Pattern | Severity | Recommendation |
|---|---|---|
| `ObjectManager::getInstance()` in module code | **High** | Constructor injection |
| `InstallSchema` / `UpgradeSchema` | **High** | Migrate to `db_schema.xml` + data patches |
| Preferences on core classes | **Medium**–**High** | Replace with plugins where possible |
| Custom `Block` with business logic | **Medium** | View models + thin templates |
| Unescaped `.phtml` output | **High** | `$escaper->escapeHtml()` etc. |
| Edits under `vendor/` | **Critical** | Move to `app/code` module |
| Plugins without vendor prefix in `name` | **Low** | Rename for merge safety |
| Missing `declare(strict_types=1)` on new code | **Info** | Adopt on touched files |

## Module structure review

Per custom module, spot-check:

- `registration.php`, `module.xml`, `composer.json` naming alignment
- `sequence` only where XML merge requires it
- `di.xml` scoped to `etc/frontend/` or `etc/adminhtml/` when area-specific
- Service contracts (`Api/`) for REST/headless surfaces

## Performance-oriented code (custom)

| Issue | Where to look | Suggestion |
|---|---|---|
| Load full collections in loops | Plugins, observers, blocks | Use repositories with filters; batch loads |
| Synchronous API calls in checkout | Plugins on quote/order | Queue or async; cache responses |
| Layout XML `<block>` cacheable=false everywhere | `view/frontend/layout` | Minimize non-cacheable blocks on catalog/PDP |
| Collection `->load()` in constructors | Blocks, view models | Defer to `getData()` or view model lazy load |

Deep FPC/Varnish tuning is optional add-on — note if engagement scope includes storefront performance.

## Third-party extensions

For `vendor/*` modules (Amasty, Mageplaza, etc.):

- Version vs current Magento patch compatibility
- Known conflicts (duplicate plugins on same method)
- Replace vs fix vs remove recommendation

## Deprecated API examples to flag

- `Magento\Framework\Registry` in new code
- `@api` classes extended without `@inheritdoc` discipline
- Web API exposing `Model` classes directly
- `Zend_` classes (migrate to Laminas equivalents)

## Report example

> **Code:** `Vendor_LegacyQuote` uses `InstallSchema.php` and `ObjectManager` in `Observer/AddFee.php` (line 42). **Recommendation:** Migrate schema to `db_schema.xml`; inject `FeeCalculator` via constructor. **Effort:** Medium.

## Handoff

| Finding type | Skill |
|---|---|
| Refactor module / schema / DI | **magento-module** |
| Admin grid UX after backend fix | **magento-module** (`admin-grid.md`) |
| PHPCS/PHPStan on module after fix | **magento-module** (`static-analysis.md`) |

## Out of scope

- Line-by-line review of entire `vendor/` tree
- Legal/license audit of proprietary extensions
- Automated SAST beyond available PHPCS in project
