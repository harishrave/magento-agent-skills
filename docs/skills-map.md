# Skills Map — Which Skill When?

```
                    ┌─────────────────────────┐
                    │   Magento task in Cursor │
                    └───────────┬─────────────┘
                                │
              ┌─────────────────┼─────────────────┐
              ▼                 ▼                 ▼
        Module + admin      Project          Browser
        code / grids        audit              validation
              │                 │                 │
              ▼                 ▼                 ▼
        magento-module    magento-audit   magento-browser-testing
```

## Skill comparison

| Skill | Scope | Strong triggers |
|---|---|---|
| **magento-module** | Modules, DI, schema, plugins, admin ui_component, PHPCS, PHPStan | `di.xml`, `ui_component`, `product_listing`, `phpcs` |
| **magento-browser-testing** | Cursor browser, UI validation, checkout, admin checks | `browser test`, `validate UI` |
| **magento-audit** | Project audit: 11 categories, evidence-backed findings | `audit report`, `technical debt`, `security audit` |

## Skill handoffs

| From | To | When |
|---|---|---|
| magento-audit | magento-module | Client approves code/schema/admin fixes |
| magento-module | magento-browser-testing | Grid or storefront needs browser validation |
| magento-browser-testing | magento-module | UI bug is PHP/XML/DI issue |

## Install

```bash
./magento-agent-skills/install.sh cursor
```

See [install.md](install.md).
