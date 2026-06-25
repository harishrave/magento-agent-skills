# Extending Core Admin Grids

Add columns, filters, or mass actions to `product_listing`, `sales_order_grid`, etc. without
touching `vendor/`.

## Merge mechanism

Place a file with the **same name** as the core listing in your module:

```
view/adminhtml/ui_component/product_listing.xml
```

Magento merges XML — your module adds children under existing nodes.

## Example: show-in-locator flag on products

`view/adminhtml/ui_component/product_listing.xml`:

```xml
<?xml version="1.0"?>
<listing xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Ui:etc/ui_configuration.xsd">
    <columns name="product_columns">
        <column name="show_in_locator"
                class="RaveDigital\StoreLocator\Ui\Component\Listing\Column\ShowInLocator">
            <settings>
                <filter>select</filter>
                <options class="Magento\Config\Model\Config\Source\Yesno"/>
                <label translate="true">Visible in locator</label>
                <dataType>select</dataType>
            </settings>
        </column>
    </columns>
</listing>
```

Use the core columns group name (`product_columns` for catalog).

## Data for non-base-table columns

When the value is not on `catalog_product_entity`:

1. Plugin `Magento\Catalog\Ui\DataProvider\Product\ProductDataProvider`, or
2. Plugin the product collection used by the grid, or
3. Custom `SearchResult` if you own the entire listing

For a single EAV attribute, batch-load in `prepareDataSource()` — never `load()` per row.

## Filters

XML `filter` settings plus collection support:

```xml
<column name="distance_radius_km">
    <settings>
        <filter>textRange</filter>
        <label translate="true">Locator radius (km)</label>
    </settings>
</column>
```

Plugin the collection or data provider to handle `addFieldToFilter('distance_radius_km', ...)`.

## product_listing.xml map

| Node | Role |
|---|---|
| `dataSource` / `product_listing_data_source` | Data + ACL `Magento_Catalog::products` |
| `listingToolbar` / `listing_filters` | Store filter, fulltext |
| `listing_massaction` | Bulk actions |
| `columns` / `product_columns` | Column definitions |

Read the full core file under `vendor/mage-os/module-catalog/view/adminhtml/ui_component/product_listing.xml`
before extending.

## module.xml sequence

```xml
<sequence>
    <module name="Magento_Catalog"/>
</sequence>
```

## Verify

```bash
bin/magento cache:clean layout block_html
```

Hard-refresh admin; inspect `mui/index/render` JSON — new field in `items[]`.

## Avoid

- Editing vendor listing XML
- Columns without collection/filter support
- Per-row `load()` in `prepareDataSource()` on large catalogs
