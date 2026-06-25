# Admin Forms (ui_component)

Entity edit screens use a `<form>` root with fieldsets, fields, and optional button providers.

## Form XML

`view/adminhtml/ui_component/ravedigital_store_location_form.xml`:

```xml
<?xml version="1.0"?>
<form xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Ui:etc/ui_configuration.xsd">
    <argument name="data" xsi:type="array">
        <item name="js_config" xsi:type="array">
            <item name="provider" xsi:type="string">
                ravedigital_store_location_form.ravedigital_store_location_form_data_source
            </item>
        </item>
    </argument>
    <settings>
        <namespace>ravedigital_store_location_form</namespace>
        <dataScope>data</dataScope>
        <deps>
            <dep>ravedigital_store_location_form.ravedigital_store_location_form_data_source</dep>
        </deps>
    </settings>
    <dataSource name="ravedigital_store_location_form_data_source">
        <argument name="data" xsi:type="array">
            <item name="js_config" xsi:type="array">
                <item name="component" xsi:type="string">Magento_Ui/js/form/provider</item>
            </item>
        </argument>
        <settings>
            <submitUrl path="ravedigital_storelocator/location/save"/>
        </settings>
        <dataProvider class="RaveDigital\StoreLocator\Ui\DataProvider\Location\Form\DataProvider"
                      name="ravedigital_store_location_form_data_source">
            <settings>
                <requestFieldName>location_id</requestFieldName>
                <primaryFieldName>location_id</primaryFieldName>
            </settings>
        </dataProvider>
    </dataSource>
    <fieldset name="location_details">
        <settings><label translate="true">Location details</label></settings>
        <field name="store_code" formElement="input">
            <settings>
                <dataType>text</dataType>
                <label translate="true">Store code</label>
                <validation>
                    <rule name="required-entry" xsi:type="boolean">true</rule>
                </validation>
            </settings>
        </field>
        <field name="hours_json" formElement="textarea">
            <settings>
                <dataType>text</dataType>
                <label translate="true">Opening hours (JSON)</label>
            </settings>
        </field>
        <field name="latitude" formElement="input">
            <settings>
                <dataType>text</dataType>
                <label translate="true">Latitude</label>
            </settings>
        </field>
        <field name="longitude" formElement="input">
            <settings>
                <dataType>text</dataType>
                <label translate="true">Longitude</label>
            </settings>
        </field>
    </fieldset>
</form>
```

## Form data provider

Load by `location_id` from request; set `$this->data[$id] = $model->getData()`.
New record: empty data under key `''` or `0`. On validation failure, persist input with
`DataPersistor` and redirect back to the form.

## Save controller

- `HttpPostActionInterface` + `ADMIN_RESOURCE`
- Validate input, call repository `save()`, flash messages, redirect to grid or stay on edit

## Buttons

Add via `<button>` nodes or `ToolbarInterface` plugins. Copy button provider pattern from
`Magento\Cms\Block\Adminhtml\Block\Edit\SaveButton` for Back / Delete / Save.

## Layout

```xml
<uiComponent name="ravedigital_store_location_form"/>
```

Route: `ravedigital_storelocator/location/edit` with `location_id` for existing records.
