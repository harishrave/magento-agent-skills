# RaveDigital Module Completion Checklist

Run before marking any module task done. Each item maps to a real code-review or marketplace finding.

## Build and standards

- [ ] `bin/magento setup:upgrade` clean (if schema or patches changed)
- [ ] `bin/magento setup:di:compile` passes
- [ ] `vendor/bin/phpcs --standard=Magento2 app/code/RaveDigital/StoreLocator` clean when CS installed
- [ ] No `ObjectManager::getInstance()`, superglobals, or SQL in templates/controllers
- [ ] PHPDoc on every class, constructor, and public method (description sentence or `@inheritDoc`)

## Module metadata

- [ ] `composer.json` name `ravedigital/module-store-locator` aligns with `registration.php` and `module.xml`
- [ ] `etc/module.xml` `<sequence>` lists modules whose XML you merge against
- [ ] `di.xml` files in the narrowest area directory
- [ ] `db_schema_whitelist.json` committed after schema changes

## Security

- [ ] All `.phtml` output escaped; `@noEscape` only with justification comment
- [ ] Admin controllers set `ADMIN_RESOURCE`; matching `acl.xml` entries exist
- [ ] POST actions implement `HttpPostActionInterface`
- [ ] Collection filters use API methods — never concatenate into raw `where()`
- [ ] Secrets use encrypted backend model; never logged

## Performance and cache

- [ ] No new `cacheable="false"` on shared layout handles
- [ ] Frontend models implement `IdentityInterface` when rendered on cacheable pages
- [ ] No I/O in constructors; CLI/cron deps proxied when heavy
- [ ] No `load()` inside loops over collections

## i18n

- [ ] User strings use `__('...')` or `translate="true"` in XML
- [ ] `i18n/en_US.csv` includes new phrases (e.g. `"Find a store","Find a store"`)

## Handoff

- [ ] Debug logging and commented code removed
- [ ] `bin/magento cache:flush` so QA sees current behavior
