# UI Component Fundamentals

Admin grids and forms are XML configs rendered by Knockout/RequireJS. The filename (without
`.xml`) is the component name referenced in layout.

## File map

| Artifact | Location |
|---|---|
| Listing / form XML | `view/adminhtml/ui_component/<name>.xml` |
| Page layout | `view/adminhtml/layout/<route>_<controller>_<action>.xml` |
| Column renderer | `Ui/Component/Listing/Column/<Name>.php` |
| Data provider | `Ui/DataProvider/...` |

## Listing skeleton

```xml
<listing xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Ui:etc/ui_configuration.xsd">
    <argument name="data" xsi:type="array">
        <item name="js_config" xsi:type="array">
            <item name="provider" xsi:type="string">store_location_listing.store_location_listing_data_source</item>
        </item>
    </argument>
    <settings>
        <spinner>store_location_columns</spinner>
        <deps>
            <dep>store_location_listing.store_location_listing_data_source</dep>
        </deps>
    </settings>
    <dataSource name="store_location_listing_data_source" component="Magento_Ui/js/grid/provider">
        <!-- aclResource, updateUrl, dataProvider -->
    </dataSource>
    <listingToolbar name="listing_top">
        <!-- bookmarks, filters, paging, massaction -->
    </listingToolbar>
    <columns name="store_location_columns">
        <!-- column nodes -->
    </columns>
</listing>
```

## Naming contract

Provider string = `<listing_file_basename>.<dataSource_name>`:

| File | Listing name | DataSource | Provider |
|---|---|---|---|
| `store_location_listing.xml` | `store_location_listing` | `store_location_listing_data_source` | `store_location_listing.store_location_listing_data_source` |

Mismatch between `js_config.provider`, `settings.deps`, and `dataSource name` causes infinite
spinners with no PHP error.

## Important settings

| Setting | Purpose |
|---|---|
| `<spinner>` | Column group shown while loading |
| `<deps>` | Data sources the UI waits for |
| `<updateUrl path="mui/index/render"/>` | AJAX endpoint |
| `<aclResource>` | ACL checked before returning rows |

## Validation

Schema: `urn:magento:module:Magento_Ui:etc/ui_configuration.xsd`

Bad XML often yields a blank admin content area. After edits:

```bash
bin/magento cache:clean layout block_html full_page
```

## Extend vs replace

Same filename in your module merges with core — add or override child nodes. Never edit `vendor/`.
