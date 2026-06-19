# Example Prompts

Copy-paste prompts that reliably trigger the right RaveDigital skill. Adjust vendor names and paths for your project.

## magento-module

### Scaffold a new module

```
Create RaveDigital_StoreLocator in app/code for physical store locator.
Write registration.php, etc/module.xml, and composer.json per module-scaffold.md.
Sequence on Magento_Store. Verify naming alignment, then run setup:upgrade and setup:di:compile.
```

### Plugin vs observer

```
I need to validate store locator hours when a quote is saved. Should I use a plugin or observer?
Implement the recommended approach with di.xml and a PHP class.
```

### Database table

```
Add a ravedigital_store_location table via db_schema.xml for name, store_code, address fields,
latitude, longitude, hours_json, and status. Include whitelist generation steps.
```

### REST API

```
Expose store locations via REST using a service contract, webapi.xml, and repository.
ACL resource RaveDigital_StoreLocator::locations.
```

### Debugging

```
setup:di:compile fails with "Cannot instantiate interface" for my repository. Diagnose and fix.
Module is RaveDigital_StoreLocator.
```

---

## magento-admin-ui

### New admin grid

```
Build an admin grid for store locations: layout XML, ui_component listing, data provider,
CollectionFactory di.xml registration, and ACL. Module RaveDigital_StoreLocator.
```

### Extend product grid

```
Add a "Visible in locator" column to product_listing with a select filter and column class.
No vendor file edits.
```

### Empty grid debug

```
My admin grid shows column headers but no rows. dataProvider name is
ravedigital_store_location_listing_data_source. Walk through the fix.
```

---

## magento-testing

### Unit test

```
Write a PHPUnit unit test for RaveDigital\StoreLocator\Model\StoreHours::getOpenHours()
with mocked ScopeConfig. Place test in Test/Unit per Magento conventions.
```

### Integration test

```
Add an integration test that saves a StoreLocation through the repository API and
loads it back. Use @magentoDbIsolation and fixtures if needed.
```

### Module test gate (unit + PHPCS + PHPStan)

```
Run the full module-testing.md workflow for RaveDigital_StoreLocator:
unit tests, PHPCS (--standard=Magento2), and PHPStan. Report summary.
```

### Version upgrade regression

```
We upgraded Magento from 2.4.7-p7 to 2.4.8-p4. Follow version-upgrade-testing.md:
run setup:di:compile, then unit tests and static analysis on all app/code modules.
```

### Write unit tests for specific classes

```
Write PHPUnit unit tests for RaveDigital_StoreLocator per unit-test-generation.md.
Cover Model/StoreHours and Model/Validator/CoordinateValidator.
Mock all dependencies. Run phpunit when done.
```

### PHPCS and PHPStan on one module

```
Run PHPCS (Magento2 standard) and PHPStan on app/code/RaveDigital/StoreLocator.
Group findings by severity per static-analysis.md. Suggest fixes but do not implement yet.
```

---

## magento-audit

### Full project audit

```
Run a RaveDigital Magento project audit per magento-audit skill.

Cover:
1. Version & security — current patch vs latest recommended (e.g. 2.4.7-p7 → 2.4.8-p4)
2. Database optimization opportunities
3. Custom code review in app/code — deprecated patterns and Magento standards
4. UI/UX — admin and storefront suggestions

Output using audit-report-template.md. Findings only — do not change code yet.
```

### Version upgrade only

```
Audit Magento version and security patch level for this project.
bin/magento --version shows 2.4.7-p7. Recommend target version and upgrade blockers.
Use version-and-security.md.
```

### Code review only

```
Review app/code for deprecated Magento patterns: ObjectManager, InstallSchema, preferences,
unescaped templates. Produce a prioritized findings table per code-review.md.
```

### UI/UX review

```
Review storefront checkout flow and admin product grid UX. Provide prioritized suggestions
per ui-ux-review.md — no code changes yet.
```

---

## Combining skills

```
Create RaveDigital_StoreLocator with admin grid and location table, then add a unit test
for StoreHours and run setup:di:compile.
```

The agent should use **magento-module** + **magento-admin-ui** + **magento-testing** together.

```
Run a magento-audit on this project, then implement the top 3 code findings using magento-module.
```

Audit first (**magento-audit**), then remediate (**magento-module** / **magento-admin-ui**).
