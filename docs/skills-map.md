# Skills Map — Which Skill When?

Use this when unsure which skill applies or when onboarding new developers.

```
                    ┌─────────────────────────┐
                    │   Magento task in Cursor │
                    └───────────┬─────────────┘
                                │
        ┌───────────┬───────────┼───────────┬───────────┐
        ▼           ▼           ▼           ▼           ▼
   Write/fix     Admin       PHPCS/      Audit      Browser
   module code   grids       PHPStan                validation
        │           │           │           │           │
        ▼           ▼           ▼           ▼           ▼
  magento-module  magento-   magento-   magento-   magento-browser-
                  admin-ui   module     audit      testing
```

## Skill comparison

| Skill | Scope | Strong triggers |
|---|---|---|
| **magento-module** | `app/code` modules: DI, schema, plugins, APIs, layout, PHPCS, PHPStan | `di.xml`, `db_schema.xml`, `phpcs`, `phpstan` |
| **magento-admin-ui** | `ui_component`, data providers, admin grids/forms | `product_listing.xml`, `mui/index/render` |
| **magento-browser-testing** | Cursor browser, UI validation, checkout, admin checks | `browser test`, `validate UI`, checkout test |
| **magento-audit** | Client audits: version, DB, code review, UI/UX reports | audit, upgrade assessment, technical review |

## Skill handoffs

| From | To | When |
|---|---|---|
| magento-audit | magento-module | Client approves code/schema fixes |
| magento-audit | magento-admin-ui | Audit recommends admin UX changes |
| magento-module | magento-admin-ui | Task is mostly ui_component XML |
| magento-module | magento-browser-testing | Custom storefront/admin UI needs validation |
| magento-admin-ui | magento-browser-testing | Grid/form built; validate in browser |
| magento-admin-ui | magento-module | Grid needs new DB table or API |

## Install

```bash
./magento-agent-skills/install.sh cursor
```

See [install.md](install.md).
