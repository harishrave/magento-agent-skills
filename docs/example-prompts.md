# Example Prompts

Copy-paste prompts for RaveDigital Magento agent skills. Each template includes **context**, **goal**, and **done criteria** so the agent routes to the right skill and delivers reviewable output.

Replace `RaveDigital_StoreLocator`, URLs, and versions with your project values.

---

## Prompt structure (use this pattern)

```
[Context] We are building / fixing … on Magento 2.4.x / Mage-OS.

[Goal] …

[Constraints] Follow RaveDigital conventions; use <skill-name> and <reference.md>.

[Done when] …
```

---

## magento-module

### Scaffold a new module

```
We need a physical store locator for click-and-collect.

Create RaveDigital_StoreLocator in app/code per module-scaffold.md:
registration.php, etc/module.xml, composer.json (sequence: Magento_Store).

Done when:
- Naming is aligned across all three files
- bin/magento setup:upgrade && setup:di:compile succeed
- Module shows enabled in module:status
```

### Plugin vs observer

```
When a customer saves the quote, we must block checkout if the selected store is outside
opening hours (StoreHours service already exists).

Should this be a plugin or observer? Implement your recommendation with di.xml,
constructor injection, and compile-safe PHP. Module: RaveDigital_StoreLocator.
```

### Declarative schema

```
Add ravedigital_store_location via db_schema.xml for RaveDigital_StoreLocator:
name, store_code, street, city, postcode, latitude, longitude, hours_json, status.

Include whitelist steps and the standard Model / ResourceModel / Collection stack.
Follow database-and-schema.md.
```

### REST API

```
Expose store locations as a REST API for headless consumers.

Service contract + repository + webapi.xml + ACL (RaveDigital_StoreLocator::locations).
Follow web-apis.md. No raw controllers for CRUD.
```

### Diagnose compile failure

```
setup:di:compile fails: "Cannot instantiate interface" for LocationRepositoryInterface.

Module: RaveDigital_StoreLocator. Trace di.xml preferences and interfaces;
fix and re-run compile. Use module-troubleshooting.md.
```

### Static analysis (PHPCS + PHPStan)

```
Run PHPCS (Magento2) and PHPStan on app/code/RaveDigital/StoreLocator.

Group findings by severity per static-analysis.md.
Recommend fixes — do not implement yet.
```

### Post-upgrade static analysis

```
We upgraded 2.4.7-p7 → 2.4.8-p4. Run setup:di:compile, then PHPCS and PHPStan
on all app/code modules per static-analysis.md. Report pass/fail summary.
```

### Admin grid (full stack)

```
Build the admin "Store Locations" grid for RaveDigital_StoreLocator:

- menu.xml + ACL
- layout + ui_component listing
- data provider + CollectionFactory in di.xml
- columns: location_id, name, store_code, status, actions

Follow admin-grid.md and grid-data-providers.md.
Done when grid loads rows from ravedigital_store_location (no empty grid).
```

### Extend core product grid

```
Merchants need to flag products that appear in the store locator.

Add a "Visible in locator" yes/no column to product_listing via ui_component merge XML,
with select filter and column class. No core file edits — extend-core-grids.md only.
```

### Empty grid triage

```
Admin grid shows headers but zero rows.

Module: RaveDigital_StoreLocator
dataProvider: ravedigital_store_location_listing_data_source

Diagnose using admin-ui-troubleshooting.md and grid-data-providers.md.
Fix di.xml / collection / primaryFieldName — verify rows load.
```

---

## magento-browser-testing

**Default:** Cursor built-in browser (no extra MCP config, no `npm init playwright` unless CI is requested).

### Storefront smoke

```
Smoke-test the storefront with Cursor browser tools:

1. Open base URL — homepage title loads
2. Open /customer/account/login — Sign In form visible
3. Screenshot any failure

cursor-browser.md. Base URL: https://magento.test (ask if unsure).
```

### Customer login

```
End-to-end: registered customer login via Cursor browser.

Steps: login page → fill email/password → submit → My Account dashboard visible.
Use roles/labels from snapshot (storefront-flows.md). Screenshot on failure.
Credentials from env or I will provide in chat.
```

### Guest checkout

```
Validate guest checkout through the shipping step using Cursor browser.

Add a simple product to cart, proceed to checkout, complete shipping address.
Wait on visible elements in snapshot — no arbitrary delays. Report pass/fail with steps.
Payment: check/money order or test method only.
```

### Product search regression

```
Regression: catalog search still works after our last deploy.

Cursor browser: search "bag" from homepage → results page shows at least one product.
Document steps and outcome. storefront-flows.md.
```

### Admin grid validation

```
We shipped RaveDigital_StoreLocator admin grid — validate in Cursor browser.

URL: /admin/ravedigital_storelocator/location/index
Expect: column headers (store code, status), grid not stuck loading.

admin-browser-tests.md. Admin credentials in env / prompt.
```

### Debug flaky browser flow

```
Checkout intermittently fails at shipping method selection (Cursor browser).

Reproduce, capture screenshot, identify unstable selector.
Recommend stable role/label approach per browser-troubleshooting.md.
```

### CI regression suite (explicit request only)

```
We need committed Playwright specs for CI — not browser-only validation.

Add customer login regression under tests/storefront/ per playwright-setup.md.
getByRole/getByLabel, screenshot on failure, document npx playwright test command.
```

### Playwright MCP — explore and generate specs (optional)

```
Use Playwright MCP for E2E automation on https://magento.test:

1. Check Playwright MCP is configured; if not, show .cursor/mcp.json setup
2. Explore guest checkout through shipping with Playwright MCP
3. Generate tests/storefront/checkout.spec.ts from observed steps
4. getByRole/getByLabel/getByTestId only; screenshot on failure

playwright-mcp-optional.md + storefront-flows.md
```

### Playwright — B2B company login and RFQ (optional)

```
Adobe Commerce B2B: use Playwright MCP to validate company user login and request a quote.
Generate Playwright specs if flow passes. b2b-flows.md + playwright-mcp-optional.md
```

---

## magento-audit

### Full enterprise audit (client deliverable)

```
Run a RaveDigital enterprise Magento audit (magento-audit). Client deliverable — findings only.

Follow evidence-and-severity.md and audit-report-template.md.
All 11 categories: environment, code, extensions, database, performance, security,
infrastructure, SEO, frontend, best practices, business opportunities.

Deliver: executive summary with health scores, top 10 critical findings, top 10 quick wins,
detailed evidence-backed findings, recommended roadmap.

Never invent findings — use "Unable to verify" when evidence is missing. No code changes.
```

### Security + environment only

```
Security and environment audit only (magento-audit).

security-audit.md + environment-audit.md + evidence-and-severity.md.
Patch level, composer audit, deployment mode, 2FA, secrets exposure.
Findings table with evidence — no implementation.
```

### Upgrade readiness

```
Upgrade assessment: bin/magento --version is 2.4.7-p7.

version-and-security.md + extension-audit.md: target patch, APSB gaps,
custom module blockers, third-party compatibility. Severity table + roadmap.
```

### Code audit (app/code)

```
Enterprise code audit of app/code per code-review.md.

Check: ObjectManager, preferences, around plugins, heavy observers, raw SQL,
deprecated APIs, N+1 patterns, PHPCS summary. evidence-and-severity.md format.
Critical / High / Medium / Low — no code changes yet.
```

### Performance + SEO

```
Performance and SEO audit (magento-audit).

performance-audit.md + seo-audit.md. Use Lighthouse data if I provide it;
otherwise mark CWV metrics as "Unable to verify". Business impact per finding.
```

### UX + frontend

```
Frontend and UX audit:

- frontend-audit.md — accessibility, console errors, CWV if provided
- ui-ux-review.md — checkout, admin usability

Prioritized recommendations — no implementation yet.
```

---

## Multi-skill workflows

### Module → admin UI → quality gate (feature complete)

```
Ship RaveDigital_StoreLocator end-to-end:

1. Module scaffold + db_schema (magento-module)
2. Admin location grid + edit form (magento-module → admin-grid.md)
3. PHPCS + PHPStan on module (magento-module → static-analysis.md)
4. setup:di:compile must pass

Stop after each phase with a short status; use module-scaffold.md and admin-grid.md.
```

### Module → browser validation

```
RaveDigital_StoreLocator admin grid is merged. Before PR:

Use Cursor browser tools to confirm grid loads, Add New opens the form, Save shows success message.
admin-browser-tests.md. Report pass/fail with screenshots.
```

### Audit → remediate (phased)

```
Phase 1 — Run magento-audit (full pillars, audit-report-template.md).
Phase 2 — Implement top 3 Critical/High code findings only (magento-module).
Phase 3 — Re-run PHPCS on touched modules (magento-module → static-analysis.md).

Do not start Phase 2 until I approve the audit summary.
```

### Upgrade: audit + test + browser

```
Planning 2.4.7-p7 → 2.4.8-p4:

1. magento-audit: version-and-security.md upgrade blockers
2. magento-module: setup:di:compile + PHPCS/PHPStan on app/code (static-analysis.md)
3. magento-browser-testing: Cursor browser smoke on homepage, login, checkout

Single combined report: blockers, static analysis summary, browser pass/fail.
```

---

## Quick reference — which skill?

| You want… | Skill |
|---|---|
| New module, API, schema, plugin, admin grid/form | **magento-module** |
| PHPCS, PHPStan, compile gate | **magento-module** |
| Browser / Cursor browser testing | **magento-browser-testing** |
| Client audit report | **magento-audit** |
