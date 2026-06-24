---
name: magento-module
description: >-
  Correct Magento 2 / Mage-OS / Adobe Commerce module development: scaffolding new modules,
  extending or customizing core behavior (plugin vs observer vs preference decisions),
  declarative schema and custom tables, product/EAV attributes, dependency injection,
  checkout/cart/totals and custom order or shipping fee logic, admin configuration
  (system.xml/ACL), admin grids and ui_components, layout XML and view models, upgrading or
  migrating custom modules (incl. to Mage-OS) and their composer.json constraints,
  PHPCS (Magento2 standard) and PHPStan static analysis on app/code modules, and debugging
  playbooks for setup:di:compile failures, layout not applying, and observers/plugins
  that don't fire. Use this skill whenever the user is writing, modifying, or debugging custom
  Magento, Mage-OS, or Adobe Commerce code — creating or extending a module/extension,
  intercepting core behavior, adding database tables or attributes, building admin settings or
  grids, frontend blocks or templates, running phpcs or phpstan on a module, or fixing errors
  from bin/magento commands — even if they don't say "module" explicitly. Strong triggers:
  "how do I override X in Magento", "my Magento layout/plugin/observer isn't working",
  "do I use an observer or a plugin", or anything touching app/code, di.xml, events.xml,
  db_schema.xml, or layout XML. For deep ui_component grid/form work (columns, filters, data
  providers, mass actions), prefer the magento-admin-ui skill. For browser E2E use
  magento-browser-testing. For project audits, version/security reviews, database optimization
  recommendations, code review reports, or UI/UX suggestions use magento-audit. Do NOT trigger
  for operational admin tasks (creating coupons, importing product CSVs, session/login settings),
  Magento hosting/sizing questions, content/SEO copy, or non-Magento platforms like Shopify
  or WooCommerce.
---

# Magento 2 / Mage-OS Module Development

RaveDigital standards for custom Magento modules: code that compiles cleanly, survives code review,
and aligns with 2.4.x / Mage-OS practices. Many public tutorials still show deprecated patterns
(InstallSchema, block classes, class rewrites) — treat those as historical context, not a template.

## Hard rules (RaveDigital review)

These items block merge or marketplace submission:

- **No `ObjectManager::getInstance()` in module code.** Dependencies belong in the constructor.
  Framework-generated factories/proxies may use ObjectManager internally — that is expected.
- **Schema via `db_schema.xml` only** — not `InstallSchema` / `UpgradeSchema` (deprecated since 2.3).
- **Prefer plugins over preferences.** Preferences replace a whole class and collide with other modules;
  plugins compose. See [references/plugins-and-observers.md](references/plugins-and-observers.md) before choosing.
- **Template logic in view models**, not custom `Block` subclasses.
- **Escape output in `.phtml`** — `$escaper->escapeHtml()`, `escapeHtmlAttr()`, `escapeUrl()`.
- **Depend on `Api/` contracts** when calling other modules, not concrete `Model` classes.
- **Scope `di.xml` by area** — `etc/frontend/di.xml` and `etc/adminhtml/di.xml` for area-specific wiring;
  avoid registering frontend-only plugins globally.

## Workflow

1. **Identify the task type** and read the matching reference before writing code:

   | Task | Read first |
   |---|---|
   | New module from scratch | [references/module-scaffold.md](references/module-scaffold.md) |
   | Change/intercept core behavior | [references/plugins-and-observers.md](references/plugins-and-observers.md) |
   | Database tables / columns | [references/database-and-schema.md](references/database-and-schema.md) |
   | DI wiring, virtual types, factories, proxies | [references/dependency-injection.md](references/dependency-injection.md) |
   | Admin settings, menus, ACL | [references/admin-configuration.md](references/admin-configuration.md) |
   | Admin grids/forms (ui_component) | **magento-admin-ui** skill (or admin-configuration.md for basics) |
   | Frontend pages, blocks, templates, layout | [references/storefront-layout.md](references/storefront-layout.md) |
   | REST / GraphQL / web APIs | [references/web-apis.md](references/web-apis.md) |
   | CLI commands, cron jobs, message queues | [references/background-jobs.md](references/background-jobs.md) |
   | Composer.json / package metadata | [references/composer-packaging.md](references/composer-packaging.md) |
   | PHPCS + PHPStan on a module | [references/static-analysis.md](references/static-analysis.md) |
   | Errors, "not working", compile failures | [references/module-troubleshooting.md](references/module-troubleshooting.md) |

2. **For a new module, follow the scaffold workflow** in [references/module-scaffold.md](references/module-scaffold.md):
   - Create `registration.php`, `etc/module.xml`, and `composer.json` with aligned naming.
   - Cross-check the naming table before moving on.
   - Run `module:enable`, `setup:upgrade`, and `setup:di:compile`.
   - Add di.xml, schema, plugins, and layout only when the task requires them.

3. **Implement** business logic in small, single-purpose classes. Plugin `name` attributes are
   global — prefix with the vendor (e.g. `ravedigital_storelocator_validate_address`).

4. **Verify before declaring done.** From the Magento root:

   ```bash
   bin/magento module:enable Vendor_Module
   bin/magento setup:upgrade
   bin/magento setup:di:compile         # must pass
   vendor/bin/phpcs --standard=Magento2 app/code/Vendor/Module   # if installed
   vendor/bin/phpstan analyse app/code/Vendor/Module -c phpstan.neon 2>/dev/null || true
   bin/magento cache:flush
   ```

   See [references/static-analysis.md](references/static-analysis.md) for PHPCS/PHPStan commands and report format.

   If `setup:di:compile` fails, go to [references/module-troubleshooting.md](references/module-troubleshooting.md).

## Decision shortcuts

- "Override what a core method returns/receives" → **plugin** (after/before).
- "React to something happening (order placed, product saved)" → **observer**, or a plugin
  on the service contract if you need to alter the result.
- "Replace an entire class implementation" → almost never; re-read
  [references/plugins-and-observers.md](references/plugins-and-observers.md).
- "Add a column to a core table" → don't; use an extension attribute or a satellite table
  ([references/database-and-schema.md](references/database-and-schema.md)).
- "Template needs data" → view model ([references/storefront-layout.md](references/storefront-layout.md)).
- "Expose data to REST/GraphQL/headless" → service contract (`Api/` interface) first
  ([references/web-apis.md](references/web-apis.md)).
- "Run phpcs/phpstan on module" → [static-analysis.md](references/static-analysis.md).

## Master prompts (copy-paste)

Full library: [docs/example-prompts.md](../../docs/example-prompts.md#magento-module).

**New module (end-to-end scaffold):**

```
We need a physical store locator for click-and-collect.

Create RaveDigital_StoreLocator in app/code per module-scaffold.md
(registration.php, module.xml, composer.json — sequence: Magento_Store).

Done when setup:upgrade && setup:di:compile pass and module:status shows enabled.
```

**Static analysis gate:**

```
Run PHPCS (Magento2) and PHPStan on app/code/RaveDigital/StoreLocator.
Group findings by severity per static-analysis.md. Recommend fixes — do not implement yet.
```

**Compile failure triage:**

```
setup:di:compile fails: "Cannot instantiate interface" for LocationRepositoryInterface.
Module: RaveDigital_StoreLocator. Fix di.xml/preferences and re-run compile.
module-troubleshooting.md.
```

## Final checklist

Before finishing any task, run through [references/review-checklist.md](references/review-checklist.md)
and [references/static-analysis.md](references/static-analysis.md) when PHPCS/PHPStan are available.

## Mage-OS notes

Mage-OS is a community fork, drop-in compatible with Magento 2.4.x. Code targeting Magento
2.4 works unchanged. In `composer.json`, depend on `magento/framework` version ranges (the
Mage-OS packages provide/replace them) rather than pinning `magento/product-community-edition`.

## Agent compatibility

Install from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
See [docs/install.md](../../docs/install.md).

## Pairing with live data (optional)

If a Magento MCP server (e.g. `elgentos/magento2-dev-mcp`) is connected, prefer it for
reading *merged* configuration (effective di.xml, layout) instead of reasoning from single
files — Magento merges XML across modules and the single-file view misleads.
