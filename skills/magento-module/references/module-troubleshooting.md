# Troubleshooting Magento Modules

Step-by-step playbooks for the failures RaveDigital teams hit most often. Work top to bottom;
each step either fixes the issue or points to the next branch.

## setup:di:compile errors

Read the **first** error block — later lines are often cascading noise.

| Message | Fix |
|---|---|
| Incompatible argument type X vs Y | Wrong `di.xml` argument or preference — check class names and `xsi:type` |
| Class X does not exist (Factory/Proxy) | `rm -rf generated/code generated/metadata` then recompile; if persists, base class typo |
| Cannot instantiate interface X | Missing `<preference>` for an `Api/` interface you inject |
| Circular dependency | Proxy one side in `di.xml` or refactor ownership |
| Backend class in frontend compile | Move plugin/type to area-specific `di.xml` or proxy admin-only deps |

## Plugin or observer never runs

1. `bin/magento module:status RaveDigital_StoreLocator` — enabled?
2. `bin/magento cache:clean config`
3. Correct area? `etc/adminhtml/di.xml` plugins do not run on storefront.
4. Target valid? No plugins on final/private/protected/`__construct`/virtual types/`new` objects.
5. `bin/magento dev:di:info "Fully\Qualified\Class"` — is your plugin listed?
6. Observers: exact event name + correct `events.xml` area. Temporary `$logger->debug()` proves execution.
7. Production mode: recompile after `di.xml` changes.

## Layout XML not visible

1. `bin/magento cache:clean layout full_page block_html`
2. Filename = full action name: `ravedigital_store_location_index.xml` (underscores, lowercase).
3. Correct directory: `view/frontend/layout/` vs `view/adminhtml/layout/`.
4. Theme override in `app/design/` may remove your block — check merge order.
5. Invalid XML is skipped silently — check `var/log/system.log` for schema errors.
6. Template 404: `RaveDigital_StoreLocator::checkout/locator-map.phtml` must exist under
   `view/frontend/templates/checkout/locator-map.phtml`.
7. Enable template hints on staging: `bin/magento dev:template-hints:enable`.

## Works in developer mode, fails in production

1. Read `var/log/exception.log` on staging with production mode.
2. Missing `setup:di:compile` after deploy.
3. Stale/missing static assets → `setup:static-content:deploy` for all locales/themes.
4. Per-user output on a cacheable page → revisit FPC strategy (see [storefront-layout.md](storefront-layout.md)).

## Indexers and cron

```bash
bin/magento indexer:status
bin/magento cron:install --force
```

| Symptom | Action |
|---|---|
| Backlog never drains | System cron not calling `cron:run` — check `cron_schedule` for recent rows |
| Stuck "processing" | `indexer:reset <id>` then `indexer:reindex <id>` |
| Deadlocks during reindex | Toggle indexer mode schedule ↔ realtime once to rebuild mview |
| Custom consumer idle | `queue:consumers:list`; verify `cron_consumers_runner` in `env.php` |

## White screen / HTTP 500

1. Latest stack trace in `var/log/exception.log`.
2. `pub/static` or `generated/` permissions after deploy.
3. `bin/magento maintenance:status`.
4. Suspect module conflict → disable on staging and bisect with `module:disable`.
