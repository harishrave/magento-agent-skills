# Admin Grid Listings (ui_component)

End-to-end pattern for `RaveDigital_StoreLocator` store location grid.

## 1. Layout

`view/adminhtml/layout/ravedigital_store_location_index.xml`:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="content">
            <uiComponent name="ravedigital_store_location_listing"/>
        </referenceContainer>
    </body>
</page>
```

## 2. Listing XML

`view/adminhtml/ui_component/ravedigital_store_location_listing.xml`:

```xml
<?xml version="1.0"?>
<listing xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Ui:etc/ui_configuration.xsd">
    <argument name="data" xsi:type="array">
        <item name="js_config" xsi:type="array">
            <item name="provider" xsi:type="string">
                ravedigital_store_location_listing.ravedigital_store_location_listing_data_source
            </item>
        </item>
    </argument>
    <settings>
        <spinner>ravedigital_store_location_columns</spinner>
        <deps>
            <dep>ravedigital_store_location_listing.ravedigital_store_location_listing_data_source</dep>
        </deps>
    </settings>
    <dataSource name="ravedigital_store_location_listing_data_source"
                component="Magento_Ui/js/grid/provider">
        <settings>
            <storageConfig>
                <param name="indexField" xsi:type="string">location_id</param>
            </storageConfig>
            <updateUrl path="mui/index/render"/>
        </settings>
        <aclResource>RaveDigital_StoreLocator::locations</aclResource>
        <dataProvider class="RaveDigital\StoreLocator\Ui\DataProvider\Location\DataProvider"
                      name="ravedigital_store_location_listing_data_source">
            <settings>
                <requestFieldName>id</requestFieldName>
                <primaryFieldName>location_id</primaryFieldName>
            </settings>
        </dataProvider>
    </dataSource>
    <listingToolbar name="listing_top">
        <bookmark name="bookmarks"/>
        <columnsControls name="columns_controls"/>
        <filters name="listing_filters"/>
        <paging name="listing_paging"/>
        <massaction name="listing_massaction">
            <action name="cancel">
                <settings>
                    <confirm>
                        <message translate="true">Disable selected locations?</message>
                        <title translate="true">Disable locations</title>
                    </confirm>
                    <url path="ravedigital_storelocator/location/massDisable"/>
                    <type>cancel</type>
                    <label translate="true">Cancel</label>
                </settings>
            </action>
        </massaction>
    </listingToolbar>
    <columns name="ravedigital_store_location_columns">
        <selectionsColumn name="ids">
            <settings><indexField>location_id</indexField></settings>
        </selectionsColumn>
        <column name="location_id">
            <settings>
                <filter>textRange</filter>
                <label translate="true">ID</label>
                <sorting>asc</sorting>
            </settings>
        </column>
        <column name="store_code">
            <settings>
                <filter>text</filter>
                <label translate="true">Store</label>
            </settings>
        </column>
        <column name="hours_json">
            <settings>
                <filter>dateRange</filter>
                <label translate="true">Opening hours</label>
            </settings>
        </column>
        <column name="status" class="RaveDigital\StoreLocator\Ui\Component\Listing\Column\Status">
            <settings>
                <filter>select</filter>
                <options class="RaveDigital\StoreLocator\Model\Source\LocationStatus"/>
                <label translate="true">Status</label>
            </settings>
        </column>
        <actionsColumn name="actions"
                       class="RaveDigital\StoreLocator\Ui\Component\Listing\Column\LocationActions">
            <settings><indexField>location_id</indexField></settings>
        </actionsColumn>
    </columns>
</listing>
```

## 3. Actions column

Extend `Magento\Ui\Component\Listing\Columns\Column`. In `prepareDataSource()`, add an
`actions` array per row with `href`, `label`, optional `confirm`.

## 4. Mass action controller

`HttpPostActionInterface`, `ADMIN_RESOURCE`, inject `Magento\Ui\Component\MassAction\Filter`,
iterate filtered collection, update status or delete.

## Filter types

| Filter | Column type |
|---|---|
| `text` | Strings |
| `textRange` | Numeric IDs |
| `select` | Status / boolean (options class) |
| `dateRange` | Dates |
| `filterSelect` | Toolbar dropdowns (store view, etc.) |

Custom rendering: column `class` + `prepareDataSource()` — batch-load related data to avoid N+1.
