# Test Troubleshooting

Condensed fixes from [ProcessEight — Testing in Magento 2](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747) and RaveDigital field notes.

## PHPUnit / environment

| Symptom | Fix |
|---|---|
| `No tests executed!` | Check `phpunit.xml` directory path (relative to xml file); no trailing `/*`; files end in `Test.php`; class name matches filename |
| `Class 'PHPUnit\Framework\TestCase' not found` | Run from Magento root; use `vendor/bin/phpunit` |
| `Bootstrap` not found (integration) | `-c dev/tests/integration/phpunit.xml.dist`; PHPUnit must use Magento's config |
| PhpStorm runs nothing | Match PHP CLI version to project; use project's `phpunit.xml` not auto-generated |
| Parse error `unexpected 'fn'` in vendor | PHP CLI too old — match `composer.json` PHP requirement |

## Mocks

| Symptom | Fix |
|---|---|
| Mock missing abstract methods | Use `createMock(Interface::class)` or `getMockForAbstractClass()` — do not use incomplete `setMethods()` |
| `No method matcher is set` | Add `->method('create')` (or correct name) between `expects()` and `willReturn()` |
| Expectation not met but code ran | Remove empty `testEnvironment` method that resets mocks; check `setUp()` order |

## Integration tests

| Symptom | Fix |
|---|---|
| `Area code not set` | `@magentoAppIsolation`; clear `dev/tests/integration/tmp/`; `TESTS_CLEANUP=enabled` |
| `Connection refused` | Configure `dev/tests/integration/etc/install-config-mysql.php` |
| `Table doesn't exist` on setup:install | Module CLI command injects DB-dependent service — use `Proxy` in `di.xml` |
| `Default website isn't defined` | Console command pulls Store too early — proxy the dependency |
| `Could not connect to Amqp` | Remove AMQP from integration `install-config-mysql.php` if unused |
| Duplicate module in `setup_module` | Module name > 50 chars truncated in DB — shorten module name |
| Identical test passes alone, fails in suite | `@magentoAppIsolation` or `@magentoDbIsolation` |
| Stale data between tests | `@magentoDbIsolation` on DB-writing tests |

## Magento Developer module

```bash
bin/magento module:enable Magento_Developer
```

Required for `bin/magento dev:tests:run`.

## Clear integration sandbox

```bash
rm -rf dev/tests/integration/tmp/sandbox-*
```

Use when `TESTS_CLEANUP` was `disabled`.

## Module name length

`setup_module.module` truncates at **50 characters**. Long module names cause duplicate install errors in integration tests.

## When to escalate

- Full integration DB rebuild fails after proxy fixes → list suspect third-party modules (disable in test `config.php` copy)
- PHPUnit version conflicts after upgrade → see [version-upgrade-testing.md](version-upgrade-testing.md)

## Further reading

- [ProcessEight gist](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747) — full examples (routes, controllers, plugins, TDD module bootstrap)
- Adobe DevDocs — integration test execution and annotations
