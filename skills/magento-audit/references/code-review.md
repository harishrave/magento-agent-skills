# Code Review and Optimization

Custom code audit for `app/code/`, `app/design/`, and project-level overrides. Findings and recommendations — implementation uses **magento-module**.

## Scan commands

```bash
# Module inventory
bin/magento module:status | grep -E 'Custom|VendorPrefix'

# Standards (sample)
vendor/bin/phpcs --standard=Magento2 app/code/ --report=summary

# Deprecated patterns (ripgrep examples)
rg "ObjectManager::getInstance" app/code/
rg "InstallSchema|UpgradeSchema" app/code/
rg "<preference for=" app/code/*/etc/
rg "echo \$|->escapeHtml" app/code/ --glob '*.phtml'
```

## RaveDigital red flags (report as findings)

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
| Admin grid UX after backend fix | **magento-admin-ui** |
| Add tests for critical paths | **magento-testing** |

## Out of scope

- Line-by-line review of entire `vendor/` tree
- Legal/license audit of proprietary extensions
- Automated SAST beyond available PHPCS in project
