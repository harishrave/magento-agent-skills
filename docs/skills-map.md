# Skills Map — Which Skill When?

Use this when unsure which skill applies or when onboarding new developers.

```
                    ┌─────────────────────────┐
                    │   Magento task in Cursor │
                    └───────────┬─────────────┘
                                │
        ┌───────────┬───────────┼───────────┬───────────┐
        ▼           ▼           ▼           ▼           ▼
   Write/fix     Admin       Tests      Audit      Implement
   module code   grids                    report     audit fixes
        │           │           │           │           │
        ▼           ▼           ▼           ▼           ▼
  magento-module  magento-   magento-   magento-   magento-module
                  admin-ui   testing    audit      + admin-ui
```

## Skill comparison

| Skill | Scope | Strong triggers |
|---|---|---|
| **magento-module** | `app/code` modules: DI, schema, plugins, APIs, layout, cron | `di.xml`, `db_schema.xml`, `setup:di:compile` |
| **magento-admin-ui** | `ui_component`, data providers, admin grids/forms | `product_listing.xml`, `mui/index/render` |
| **magento-testing** | PHPUnit, PHPCS, PHPStan, upgrade regression for modules | `Test/Unit`, `phpcs`, `phpstan`, upgrade test |
| **magento-browser-testing** | Playwright E2E, UI validation, checkout, admin browser tests | `playwright`, `E2E`, `browser test`, checkout test |
| **magento-audit** | Client audits: version, DB, code review, UI/UX reports | audit, upgrade assessment, technical review, deprecated code |

## Out of scope

| Topic | Notes |
|---|---|
| Adobe Commerce Storefront / EDS / drop-ins | Storefront-specific rules |
| Payment/shipping webhooks, App Builder | Integration starter kits |
| Penetration testing / formal WCAG certification | Note in audit; separate engagement |
| Shopify, WooCommerce | Not Magento |

## Skill handoffs

| From | To | When |
|---|---|---|
| magento-audit | magento-module | Client approves code/schema fixes |
| magento-audit | magento-admin-ui | Audit recommends admin UX changes |
| magento-audit | magento-testing | Audit finds missing test coverage |
| magento-module | magento-admin-ui | Task is mostly ui_component XML |
| magento-module | magento-testing | Module code done; add PHPUnit tests |
| magento-module | magento-browser-testing | Custom storefront/admin UI needs E2E |
| magento-admin-ui | magento-browser-testing | Grid/form built; validate in browser |
| magento-admin-ui | magento-module | Grid needs new DB table or API |

## Install

```bash
./magento-agent-skills/install.sh cursor
```

See [install.md](install.md).
