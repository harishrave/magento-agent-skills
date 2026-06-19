# Composer and Module Packaging

RaveDigital modules published or shared across projects need a correct `composer.json` alongside Magento's `registration.php` and `etc/module.xml`.

## composer.json essentials

```json
{
    "name": "ravedigital/module-store-locator",
    "description": "physical store locator for Magento 2",
    "type": "magento2-module",
    "version": "1.0.0",
    "license": "proprietary",
    "require": {
        "php": "^8.1",
        "magento/framework": "^103.0"
    },
    "autoload": {
        "files": ["registration.php"],
        "psr-4": {
            "RaveDigital\\StoreLocator\\": ""
        }
    }
}
```

## Naming alignment

| File | Must agree on |
|---|---|
| `composer.json` `name` | `ravedigital/module-store-locator` (vendor lowercase, module kebab) |
| `registration.php` | `RaveDigital_StoreLocator` |
| `etc/module.xml` | `RaveDigital_StoreLocator` |
| PSR-4 prefix | `RaveDigital\StoreLocator\` → module root |

## Mage-OS / Adobe Commerce

- Depend on `magento/framework` with a version range compatible with your target release.
- On Mage-OS, framework packages are provided by Mage-OS metapackages — avoid pinning `magento/product-community-edition` in reusable modules.
- Declare `sequence` in `module.xml` for modules whose XML you merge, not as composer dependencies unless you call their PHP code.

## Versioning

- **Module code version**: `composer.json` `version` field (semantic versioning).
- **Setup data version**: removed in modern Magento — use data patches, not `setup_version` in `module.xml`.
- Tag git releases when distributing outside a monorepo.

## Private RaveDigital packages

For internal Packagist or artifact repo:

```json
"repositories": [
    {
        "type": "composer",
        "url": "https://packages.ravedigital.com/"
    }
]
```

Keep proprietary license in `composer.json` (`"license": "proprietary"`) for internal modules.

## Verify package structure

```bash
composer validate app/code/RaveDigital/StoreLocator/composer.json
bin/magento module:status RaveDigital_StoreLocator
bin/magento setup:di:compile
```
