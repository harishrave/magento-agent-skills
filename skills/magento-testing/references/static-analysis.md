# Static Analysis — PHPCS and PHPStan

Run **Magento Coding Standard (PHPCS)** and **PHPStan** against a specific module in `app/code/Vendor/Module/`.

## Prerequisites

```bash
# Usually present in Magento projects
vendor/bin/phpcs --version
composer show magento/magento-coding-standard 2>/dev/null
composer show phpstan/phpstan 2>/dev/null
```

Install if missing (project decision):

```bash
composer require --dev magento/magento-coding-standard phpstan/phpstan
```

## PHPCS — Magento2 standard

### Single module

```bash
vendor/bin/phpcs --standard=Magento2 \
  app/code/RaveDigital/StoreLocator
```

### Summary only

```bash
vendor/bin/phpcs --standard=Magento2 --report=summary \
  app/code/RaveDigital/StoreLocator
```

### Specific paths

```bash
vendor/bin/phpcs --standard=Magento2 \
  app/code/RaveDigital/StoreLocator/Model \
  app/code/RaveDigital/StoreLocator/Test
```

### Auto-fix (safe whitespace etc.)

```bash
vendor/bin/phpcbf --standard=Magento2 \
  app/code/RaveDigital/StoreLocator
```

Re-run `phpcs` after `phpcbf` to see remaining violations.

## PHPStan

Project may have root `phpstan.neon` or `phpstan.neon.dist`. Scope analysis to one module:

```bash
vendor/bin/phpstan analyse \
  app/code/RaveDigital/StoreLocator \
  --level=5
```

With project config:

```bash
vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator -c phpstan.neon
```

### Minimal module-level config (if none exists)

Create `app/code/RaveDigital/StoreLocator/phpstan.neon` only when team approves module-local config:

```neon
parameters:
    level: 5
    paths:
        - .
    bootstrapFiles:
        - ../../../../vendor/autoload.php
```

Prefer **project-root** `phpstan.neon` with path includes — avoid duplicating config per module.

## Combined module quality gate

Run before marking module work or upgrade testing complete:

```bash
MODULE=app/code/RaveDigital/StoreLocator

echo "=== PHPCS ==="
vendor/bin/phpcs --standard=Magento2 --report=summary "$MODULE" || true

echo "=== PHPStan ==="
vendor/bin/phpstan analyse "$MODULE" --level=5 2>/dev/null || \
  vendor/bin/phpstan analyse "$MODULE" -c phpstan.neon 2>/dev/null || true

echo "=== Unit tests ==="
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist "$MODULE/Test/Unit" || true
```

## Report format for audits / client deliverables

| Tool | Metric | Module path |
|---|---|---|
| PHPCS | Errors: N, Warnings: M | `RaveDigital_StoreLocator` |
| PHPStan | N errors at level X | same |
| PHPUnit | X tests, Y assertions | `Test/Unit` |

Example finding:

> **PHPCS:** 12 warnings in `RaveDigital_StoreLocator` — mostly missing `@inheritdoc` and line length. No critical security sniffs.
>
> **PHPStan:** 3 errors — nullable return type on `StoreHours::getOpenHours()` when config missing.

## Severity guide for reports

| PHPCS / PHPStan | Treat as |
|---|---|
| Security sniffs (SQL injection, unescaped output) | **Critical** — fix before merge |
| Type errors on public APIs | **High** |
| Line length, docblock | **Low** — batch fix |
| PHPStan level 8 on legacy module | **Medium** — incremental bump |

## RaveDigital conventions checked by PHPCS

Aligns with **magento-module** skill:

- No `ObjectManager::getInstance()` in module code
- `$escaper` usage in `.phtml`
- Constructor property promotion / injection patterns
- `@inheritdoc` on interface methods

## Agent workflow

When user asks to "run PHPStan and CS on Vendor_Module":

1. Resolve path: `app/code/Vendor/Module`
2. Run `phpcs --standard=Magento2 --report=full` (or summary)
3. Run `phpstan analyse` with project config if present
4. Group findings by file and severity
5. Suggest fixes — implement only if user asks (**magento-module**)

## Exclude test directories (optional)

Some teams exclude `Test/` from PHPStan initially:

```bash
vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator/Model app/code/RaveDigital/StoreLocator/Api
```

Document exclusion in report if used.

## CI snippet (reference)

```yaml
- run: vendor/bin/phpcs --standard=Magento2 app/code/RaveDigital/StoreLocator
- run: vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist app/code/RaveDigital/StoreLocator/Test/Unit
- run: vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator -c phpstan.neon
```

## Pair with

- [module-testing.md](module-testing.md) — full module test run
- [version-upgrade-testing.md](version-upgrade-testing.md) — compare before/after upgrade
- **magento-audit** [code-review.md](../../magento-audit/references/code-review.md) — broader code audit
