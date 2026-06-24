# Static Analysis — PHPCS and PHPStan

Run **Magento Coding Standard (PHPCS)** and **PHPStan** against a specific module in `app/code/Vendor/Module/`.

## Prerequisites

```bash
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

### Auto-fix (safe whitespace etc.)

```bash
vendor/bin/phpcbf --standard=Magento2 \
  app/code/RaveDigital/StoreLocator
```

Re-run `phpcs` after `phpcbf` to see remaining violations.

## PHPStan

```bash
vendor/bin/phpstan analyse \
  app/code/RaveDigital/StoreLocator \
  --level=5
```

With project config:

```bash
vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator -c phpstan.neon
```

Prefer **project-root** `phpstan.neon` with path includes — avoid duplicating config per module.

## Module quality gate (static analysis)

Run before marking module work complete:

```bash
MODULE=app/code/RaveDigital/StoreLocator

echo "=== PHPCS ==="
vendor/bin/phpcs --standard=Magento2 --report=summary "$MODULE" || true

echo "=== PHPStan ==="
vendor/bin/phpstan analyse "$MODULE" --level=5 2>/dev/null || \
  vendor/bin/phpstan analyse "$MODULE" -c phpstan.neon 2>/dev/null || true
```

Pair with `bin/magento setup:di:compile` from the main **magento-module** workflow.

## Report format for audits / client deliverables

| Tool | Metric | Module path |
|---|---|---|
| PHPCS | Errors: N, Warnings: M | `RaveDigital_StoreLocator` |
| PHPStan | N errors at level X | same |

## Severity guide for reports

| PHPCS / PHPStan | Treat as |
|---|---|
| Security sniffs (SQL injection, unescaped output) | **Critical** — fix before merge |
| Type errors on public APIs | **High** |
| Line length, docblock | **Low** — batch fix |
| PHPStan level 8 on legacy module | **Medium** — incremental bump |

## RaveDigital conventions checked by PHPCS

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
5. Suggest fixes — implement only if user asks

## CI snippet (reference)

```yaml
- run: vendor/bin/phpcs --standard=Magento2 app/code/RaveDigital/StoreLocator
- run: vendor/bin/phpstan analyse app/code/RaveDigital/StoreLocator -c phpstan.neon
```

## Pair with

- [review-checklist.md](review-checklist.md) — pre-merge module checklist
- **magento-audit** [code-review.md](../../magento-audit/references/code-review.md) — broader code audit
