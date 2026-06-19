# Data Providers and Grid Collections

Headers with zero rows → almost always missing or mis-keyed `CollectionFactory` registration.

## Wiring chain

```
ui_component XML
  → dataProvider (extends AbstractDataProvider)
    → collection (factory-created)
      → registered in di.xml CollectionFactory → collections[]
```

## DataProvider

```php
namespace RaveDigital\StoreLocator\Ui\DataProvider\Location;

use Magento\Ui\DataProvider\AbstractDataProvider;

class DataProvider extends AbstractDataProvider
{
    public function __construct(
        string $name,
        string $primaryFieldName,
        string $requestFieldName,
        \RaveDigital\StoreLocator\Model\ResourceModel\StoreLocation\CollectionFactory $collectionFactory,
        array $meta = [],
        array $data = []
    ) {
        $this->collection = $collectionFactory->create();
        parent::__construct($name, $primaryFieldName, $requestFieldName, $meta, $data);
    }
}
```

## di.xml registration (required)

```xml
<virtualType name="RaveDigital\StoreLocator\Model\ResourceModel\StoreLocation\Grid\Collection"
             type="Magento\Framework\View\Element\UiComponent\DataProvider\SearchResult">
    <arguments>
        <argument name="mainTable" xsi:type="string">ravedigital_store_location</argument>
        <argument name="resourceModel" xsi:type="string">
            RaveDigital\StoreLocator\Model\ResourceModel\StoreLocation
        </argument>
    </arguments>
</virtualType>
<type name="Magento\Framework\View\Element\UiComponent\DataProvider\CollectionFactory">
    <arguments>
        <argument name="collections" xsi:type="array">
            <item name="ravedigital_store_location_listing_data_source" xsi:type="string">
                RaveDigital\StoreLocator\Model\ResourceModel\StoreLocation\Grid\Collection
            </item>
        </argument>
    </arguments>
</type>
```

The `item name` must **exactly equal** the `dataProvider name` attribute in ui_component XML.

## SearchResult vs custom collection

| Approach | When |
|---|---|
| `SearchResult` virtual type | Single main table, standard filters |
| Custom `Collection` subclass | Joins, computed columns, complex filters |
| Plugin on core data provider | Extending `product_listing` data |

Custom filters: override `addFilter()` on SearchResult subclass or plugin the data provider.

## Form data providers

Same `AbstractDataProvider` base; populate `$this->data[$entityId]` for edit forms. Use
`DataPersistor` to repopulate after validation errors — see [admin-form.md](admin-form.md).

## Debug checklist

1. `collections` key matches `dataProvider name`
2. `mainTable` matches `db_schema.xml`
3. `primaryFieldName` matches DB primary key (`location_id`, not `entity_id` unless that's your key)
4. ACL allows current admin user
5. Network tab: `mui/index/render` response — check `items`, `totalRecords`, `exception.log`
