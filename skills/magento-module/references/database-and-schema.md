# Database Schema with db_schema.xml

Magento 2.3+ manages structure declaratively. Put table definitions in `etc/db_schema.xml`;
run `bin/magento setup:upgrade` to apply diffs. Do **not** add new `InstallSchema` /
`UpgradeSchema` classes — they are legacy and hide the real schema state.

Use **data patches** (`Setup\Patch\Data`) for seed rows, EAV attributes, and CMS blocks — not
for DDL.

## Satellite table example

`RaveDigital_StoreLocator` stores physical store locations in its own table:

```xml
<?xml version="1.0"?>
<schema xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Setup/Declaration/Schema/etc/schema.xsd">
    <table name="ravedigital_store_location" resource="default" engine="innodb"
           comment="RaveDigital physical store locations">
        <column xsi:type="int" name="location_id" unsigned="true" nullable="false"
                identity="true" comment="Location ID"/>
        <column xsi:type="varchar" name="name" length="255" nullable="false" comment="Display name"/>
        <column xsi:type="varchar" name="store_code" length="32" nullable="false" comment="Store code"/>
        <column xsi:type="varchar" name="street" length="255" nullable="true" comment="Street"/>
        <column xsi:type="varchar" name="city" length="128" nullable="true" comment="City"/>
        <column xsi:type="varchar" name="postcode" length="32" nullable="true" comment="Postcode"/>
        <column xsi:type="decimal" name="latitude" scale="6" precision="10" nullable="true" comment="Latitude"/>
        <column xsi:type="decimal" name="longitude" scale="6" precision="10" nullable="true" comment="Longitude"/>
        <column xsi:type="text" name="hours_json" nullable="true" comment="Opening hours JSON"/>
        <column xsi:type="varchar" name="status" length="16" nullable="false" default="enabled" comment="Status"/>
        <column xsi:type="timestamp" name="created_at" on_update="false" nullable="false"
                default="CURRENT_TIMESTAMP" comment="Created"/>
        <constraint xsi:type="primary" referenceId="PRIMARY">
            <column name="location_id"/>
        </constraint>
        <index referenceId="RAVEDIGITAL_STORE_LOCATION_STORE_CODE" indexType="btree">
            <column name="store_code"/>
        </index>
        <index referenceId="RAVEDIGITAL_STORE_LOCATION_STATUS" indexType="btree">
            <column name="status"/>
        </index>
    </table>
</schema>
```

Common pitfalls:

- `referenceId` on foreign keys must be unique across the entire database.
- Renaming a column: add `onCreate="migrateDataFrom(old_column)"` on the new column or data is dropped.
- Removing columns/tables requires an up-to-date whitelist — regenerate after every schema edit:

```bash
bin/magento setup:db-declaration:generate-whitelist --module-name=RaveDigital_StoreLocator
```

Commit `etc/db_schema_whitelist.json`. Then `setup:upgrade` and confirm with
`bin/magento setup:db:status`.

## Avoid altering core tables

Do not add columns to `sales_order` or `catalog_product_entity` unless there is no alternative.
Prefer:

**Extension attributes** for API-visible fields on core entities:

```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Api/etc/extension_attributes.xsd">
    <extension_attributes for="Magento\Sales\Api\Data\OrderInterface">
        <attribute code="locator_store_code" type="string"/>
        <attribute code="locator_hours_json" type="string"/>
    </extension_attributes>
</config>
```

Persist values in your satellite table; load/save via plugins on the entity repository
(`afterGet`, `afterSave`, `afterGetList`).

**EAV attributes** when merchants must manage product-level locator visibility in admin.

## Data patch skeleton

```php
namespace RaveDigital\StoreLocator\Setup\Patch\Data;

use Magento\Framework\Setup\ModuleDataSetupInterface;
use Magento\Framework\Setup\Patch\DataPatchInterface;

class SeedDefaultStoreHours implements DataPatchInterface
{
    public function __construct(private readonly ModuleDataSetupInterface $setup) {}

    public function apply(): self
    {
        $this->setup->getConnection()->startSetup();
        // insert default rows, create EAV attributes, etc.
        $this->setup->getConnection()->endSetup();
        return $this;
    }

    public static function getDependencies(): array { return []; }
    public function getAliases(): array { return []; }
}
```

Patches run once, tracked in `patch_list`. Implement `PatchRevertableInterface` only when
uninstall must roll back data.

## Model layer for custom tables

Standard stack:

- `Model/StoreLocation.php` — `AbstractModel`, `_init(ResourceModel\StoreLocation::class)`
- `Model/ResourceModel/StoreLocation.php` — `AbstractDb`, table `ravedigital_store_location`
- `Model/ResourceModel/StoreLocation/Collection.php` — `AbstractCollection`

Expose CRUD through `Api/LocationRepositoryInterface` + `Api/Data/LocationInterface`
with `preference` bindings in `etc/di.xml`. Other modules should depend on the contract, not the model.
