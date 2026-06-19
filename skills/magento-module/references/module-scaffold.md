# Module Scaffold (prompt workflow)

Use this when creating a **new** module from scratch. Write the three boilerplate files by hand
(following the templates below) — no helper script required.

## Agent scaffold prompt

When the user asks for a new module, follow this sequence:

1. Confirm **Vendor_Module** name (e.g. `RaveDigital_StoreLocator`) and target path (`app/code` by default).
2. Create the directory `app/code/<Vendor>/<Module>/`.
3. Write all three files below with **consistent naming** across every file.
4. Run verification commands before declaring done.

**Copy-paste prompt for users:**

```
Create a new Magento module RaveDigital_StoreLocator in app/code for physical store locations.
Include registration.php, etc/module.xml, and composer.json with sequence on Magento_Store.
Follow RaveDigital conventions in module-scaffold.md, then run setup:upgrade and setup:di:compile.
```

## Naming alignment (verify before finishing)

| Artifact | Example (`RaveDigital_StoreLocator`) |
|---|---|
| Module name | `RaveDigital_StoreLocator` |
| Directory | `app/code/RaveDigital/StoreLocator/` |
| composer.json `name` | `ravedigital/module-store-locator` |
| PSR-4 prefix | `RaveDigital\StoreLocator\` |
| PHP namespace | `RaveDigital\StoreLocator\...` |

Convert CamelCase module segment to kebab-case for composer: `StoreLocator` → `store-locator`.

## File 1: registration.php

Path: `app/code/<Vendor>/<Module>/registration.php`

```php
<?php
declare(strict_types=1);

use Magento\Framework\Component\ComponentRegistrar;

ComponentRegistrar::register(
    ComponentRegistrar::MODULE,
    'RaveDigital_StoreLocator',
    __DIR__
);
```

Replace `RaveDigital_StoreLocator` with the actual module name.

## File 2: etc/module.xml

Path: `app/code/<Vendor>/<Module>/etc/module.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="RaveDigital_StoreLocator">
        <sequence>
            <module name="Magento_Store"/>
        </sequence>
    </module>
</config>
```

- Omit `<sequence>` if the module does not merge XML from other modules.
- List every module whose layout, di.xml, or ui_component you extend.

## File 3: composer.json

Path: `app/code/<Vendor>/<Module>/composer.json`

```json
{
    "name": "ravedigital/module-store-locator",
    "description": "Physical store locator for Magento 2",
    "type": "magento2-module",
    "license": "proprietary",
    "version": "1.0.0",
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

Add `vendor/module-name` entries in `require` for each module in `<sequence>` when you call their PHP code.

## Verify scaffold

From the Magento root:

```bash
bin/magento module:enable RaveDigital_StoreLocator
bin/magento setup:upgrade
bin/magento setup:di:compile
bin/magento module:status RaveDigital_StoreLocator
```

All three must show the same module name. See [composer-packaging.md](composer-packaging.md) and [review-checklist.md](review-checklist.md).

## What scaffold does NOT include

Create these separately when the task requires them:

| Need | Add |
|---|---|
| Plugins / observers | `etc/di.xml`, `etc/events.xml` — [plugins-and-observers.md](plugins-and-observers.md) |
| Database table | `etc/db_schema.xml` — [database-and-schema.md](database-and-schema.md) |
| Admin config | `etc/adminhtml/system.xml`, `etc/acl.xml` — [admin-configuration.md](admin-configuration.md) |
| Storefront template | layout XML + view model — [storefront-layout.md](storefront-layout.md) |
| REST / GraphQL | `Api/` + `etc/webapi.xml` — [web-apis.md](web-apis.md) |
