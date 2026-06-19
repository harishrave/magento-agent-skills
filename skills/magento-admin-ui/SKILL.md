---
name: magento-admin-ui
description: >-
  Magento 2 / Mage-OS / Adobe Commerce admin UI development with ui_component: admin grids
  (listing), forms, columns, filters, mass actions, data providers, collection factories,
  extending core grids like product_listing, ACL wiring, and debugging grids that show no
  data or wrong columns. Use when the user works on view/adminhtml/ui_component XML,
  adminhtml layout that loads a uiComponent, Listing\Column classes, DataProvider classes,
  di.xml collection factory registration, or asks to add a column/filter to an admin grid.
  Strong triggers: product_listing.xml, ui_component, admin grid, mass action, listingToolbar,
  dataSource, mui/index/render. For module scaffolding, plugins, or schema use magento-module.
  For system.xml menus and ACL basics only, magento-module references/admin-configuration.md is enough.
requires: magento-module
---

# Magento 2 / Mage-OS Admin UI (ui_component)

RaveDigital guide for admin grids and forms built on Magento's UI Component framework — XML layout,
data providers, collection registration, extending core listings, and debugging empty grids.

## RaveDigital conventions

- **UI components for new admin listings** — not legacy `Magento\Backend\Block\Widget\Grid`.
- **ACL on every listing** — `<aclResource>` must match a real id in `etc/acl.xml`.
- **Register collections in `di.xml`** — missing `CollectionFactory` mapping yields an empty grid with no clear error.
- **Consistent naming** — ui_component filename, layout reference, `dataSource name`, and
  `js_config provider` must match (e.g. `ravedigital_store_location_listing` throughout).
- **Extend core listings via module XML merge** — never edit files under `vendor/`.
- **Translate labels** — `translate="true"` plus `i18n/en_US.csv`.
- **Custom column classes** for non-trivial cell output — subclass `Listing\Columns\Column`.

## Workflow

1. **Identify the task** and read the matching reference:

   | Task | Read first |
   |---|---|
   | New admin grid from scratch | [references/admin-grid.md](references/admin-grid.md) |
   | New admin form | [references/admin-form.md](references/admin-form.md) |
   | Data provider / collection wiring | [references/grid-data-providers.md](references/grid-data-providers.md) |
   | Add column/filter to existing grid | [references/extend-core-grids.md](references/extend-core-grids.md) |
   | Component types, deps, settings | [references/ui-component-structure.md](references/ui-component-structure.md) |
   | Grid empty, wrong data, JS errors | [references/admin-ui-troubleshooting.md](references/admin-ui-troubleshooting.md) |

2. **Study a core example** before inventing structure. Good references in vendor:
   - `Magento_Catalog::view/adminhtml/ui_component/product_listing.xml` — full-featured listing
   - `Magento_Cms::view/adminhtml/ui_component/cms_block_listing.xml` — simpler custom entity grid

3. **Wire the full stack** (all required for a new grid):
   - `etc/acl.xml` + controller `ADMIN_RESOURCE`
   - `etc/adminhtml/routes.xml` + `menu.xml`
   - `view/adminhtml/layout/<route>_<controller>_<action>.xml` → `<uiComponent name="..."/>`
   - `view/adminhtml/ui_component/<name>_listing.xml`
   - Collection + DataProvider + `etc/di.xml` virtual types

4. **Verify before declaring done:**

   ```bash
   bin/magento setup:di:compile
   bin/magento cache:flush
   bin/magento cache:clean layout block_html
   # Load admin grid in browser; check var/log/system.log and browser console
   vendor/bin/phpcs --standard=Magento2 app/code/Vendor/Module
   ```

## Decision shortcuts

- "Add a column to product grid" → extend `product_listing.xml` in your module +
  [references/extend-core-grids.md](references/extend-core-grids.md); column class if
  formatted output needed.
- "Grid shows headers but no rows" → data provider / collection registration in `di.xml`
  ([references/grid-data-providers.md](references/grid-data-providers.md)).
- "Filter doesn't work" → check `filter` element, `dataScope`, and collection `addFieldToFilter`
  support in the data provider.
- "Mass action needed" → `listingToolbar` → `massaction` + controller with
  `MassActionFilter` ([references/admin-grid.md](references/admin-grid.md)).
- "Edit form for entity" → form ui_component + `buttons` + data provider with `DataPersistor`
  ([references/admin-form.md](references/admin-form.md)).

## Final checklist

- [ ] ui_component name matches layout reference
- [ ] `dataSource` provider string matches `js_config.provider`
- [ ] Collection registered in `CollectionFactory` collections array
- [ ] ACL resource exists and controller enforces it
- [ ] Labels translated; `i18n/en_US.csv` updated
- [ ] No edits inside `vendor/` — all overrides in `app/code`

## Mage-OS notes

Mage-OS uses the same ui_component framework as Magento 2.4.x. Core listing XML lives under
`vendor/mage-os/` with identical patterns; reference those paths when working on Mage-OS installs.

## Agent compatibility

Open `SKILL.md` format — works with Cursor, Claude Code, Codex, Windsurf, and other agents.
Install from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills) via
[Vercel Skills CLI](https://github.com/vercel-labs/skills) or copy into your agent's skills directory.
See [docs/install.md](../../docs/install.md).
