---
name: magento-module
description: >-
  Magento 2 / Mage-OS / Adobe Commerce module development: scaffolding, plugins, observers,
  declarative schema, DI, APIs, CLI/cron, storefront layout, admin configuration (system.xml/ACL),
  admin grids and forms (ui_component), columns, filters, mass actions, data providers, extending
  core listings like product_listing, PHPCS and PHPStan static analysis, and debugging compile,
  layout, plugin, and admin grid failures. Use when writing or debugging app/code modules,
  di.xml, db_schema.xml, ui_component XML, admin grids, product_listing, dataSource,
  mui/index/render, listingToolbar, or bin/magento errors. Strong triggers: module scaffold,
  plugin vs observer, admin grid, empty grid, ui_component, phpcs, phpstan. For browser validation
  use magento-browser-testing. For enterprise audits use magento-audit. Do NOT trigger for
  operational admin tasks, hosting questions, or non-Magento platforms.
---

# Magento 2 / Mage-OS Module Development

RaveDigital standards for custom Magento modules: code that compiles cleanly, survives code review,
and aligns with 2.4.x / Mage-OS practices.

## Hard rules (RaveDigital review)

- **No `ObjectManager::getInstance()` in module code** — constructor injection only
- **Schema via `db_schema.xml` only** — not InstallSchema/UpgradeSchema
- **Prefer plugins over preferences**
- **View models** for template logic — not custom Block classes
- **Escape all `.phtml` output**
- **UI components for new admin listings** — not legacy Widget Grid
- **ACL on every listing** — `<aclResource>` matches `etc/acl.xml`
- **Register collections in `di.xml`** — missing CollectionFactory → empty grid
- **Extend core listings via merge XML** — never edit `vendor/`

## Workflow — pick your task

| Task | Read first |
|---|---|
| New module from scratch | [references/module-scaffold.md](references/module-scaffold.md) |
| Plugins, observers, preferences | [references/plugins-and-observers.md](references/plugins-and-observers.md) |
| Database tables / columns | [references/database-and-schema.md](references/database-and-schema.md) |
| DI, factories, virtual types | [references/dependency-injection.md](references/dependency-injection.md) |
| Admin settings, menus, ACL | [references/admin-configuration.md](references/admin-configuration.md) |
| **New admin grid** | [references/admin-grid.md](references/admin-grid.md) |
| **New admin form** | [references/admin-form.md](references/admin-form.md) |
| **Data provider / collection** | [references/grid-data-providers.md](references/grid-data-providers.md) |
| **Extend core grid** | [references/extend-core-grids.md](references/extend-core-grids.md) |
| **ui_component structure** | [references/ui-component-structure.md](references/ui-component-structure.md) |
| **Empty admin grid / JS errors** | [references/admin-ui-troubleshooting.md](references/admin-ui-troubleshooting.md) |
| Storefront layout, view models | [references/storefront-layout.md](references/storefront-layout.md) |
| REST / GraphQL APIs | [references/web-apis.md](references/web-apis.md) |
| CLI, cron, queues | [references/background-jobs.md](references/background-jobs.md) |
| PHPCS + PHPStan | [references/static-analysis.md](references/static-analysis.md) |
| Compile / module errors | [references/module-troubleshooting.md](references/module-troubleshooting.md) |
| Composer packaging | [references/composer-packaging.md](references/composer-packaging.md) |

## Admin UI conventions (ui_component)

- ui_component filename, layout reference, `dataSource name`, and `js_config provider` must **match**
- Study core examples: `product_listing.xml`, `cms_block_listing.xml`
- Full stack for new grid: ACL + routes + menu + layout + ui_component + DataProvider + di.xml

**Verify admin work:**

```bash
bin/magento setup:di:compile
bin/magento cache:flush
bin/magento cache:clean layout block_html
vendor/bin/phpcs --standard=Magento2 app/code/Vendor/Module
```

## Verify before declaring done

```bash
bin/magento module:enable Vendor_Module
bin/magento setup:upgrade
bin/magento setup:di:compile
vendor/bin/phpcs --standard=Magento2 app/code/Vendor/Module
vendor/bin/phpstan analyse app/code/Vendor/Module -c phpstan.neon 2>/dev/null || true
bin/magento cache:flush
```

See [static-analysis.md](references/static-analysis.md). Compile failures → [module-troubleshooting.md](references/module-troubleshooting.md).

## Decision shortcuts

| User says | Action |
|---|---|
| Plugin vs observer | [plugins-and-observers.md](references/plugins-and-observers.md) |
| Add column to product grid | [extend-core-grids.md](references/extend-core-grids.md) |
| Grid shows headers, no rows | [grid-data-providers.md](references/grid-data-providers.md) |
| Mass action on grid | [admin-grid.md](references/admin-grid.md) |
| Entity edit form | [admin-form.md](references/admin-form.md) |
| phpcs / phpstan | [static-analysis.md](references/static-analysis.md) |

## Master prompts

See [docs/example-prompts.md](../../docs/example-prompts.md#magento-module).

**Admin grid:**

```
Build Store Locations admin grid for RaveDigital_StoreLocator:
menu, ACL, layout, ui_component, data provider, CollectionFactory in di.xml.
Done when rows load. admin-grid.md + grid-data-providers.md.
```

**Empty grid:**

```
Grid shows headers but zero rows. RaveDigital_StoreLocator.
dataProvider: ravedigital_store_location_listing_data_source.
admin-ui-troubleshooting.md.
```

## Final checklist

- [ ] [review-checklist.md](references/review-checklist.md)
- [ ] Admin: ui_component name matches layout; collection in di.xml; ACL enforced
- [ ] [static-analysis.md](references/static-analysis.md) when PHPCS/PHPStan available

## Handoffs

| After module work needs… | Skill |
|---|---|
| Browser validation of admin/storefront | **magento-browser-testing** |
| Enterprise audit / findings report | **magento-audit** |

## Agent compatibility

`./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
