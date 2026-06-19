# Admin Config, ACL, Menus, and Grids

Admin features are mostly XML. Failures usually come from mismatched ids across files — treat
`system.xml`, `acl.xml`, `menu.xml`, `routes.xml`, and controllers as one unit.

## system.xml + config.xml

`etc/adminhtml/system.xml` — Stores → Configuration fields:

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Config:etc/system_file.xsd">
    <system>
        <section id="ravedigital_storelocator" translate="label" sortOrder="120"
                 showInDefault="1" showInWebsite="1" showInStore="1">
            <label>Store Locator</label>
            <tab>sales</tab>
            <resource>RaveDigital_StoreLocator::config</resource>
            <group id="general" translate="label" sortOrder="10"
                   showInDefault="1" showInWebsite="1" showInStore="1">
                <label>General</label>
                <field id="enabled" translate="label" type="select" sortOrder="10"
                       showInDefault="1" showInWebsite="1" showInStore="1">
                    <label>Enable store locator on storefront</label>
                    <source_model>Magento\Config\Model\Config\Source\Yesno</source_model>
                </field>
                <field id="default_radius_km" translate="label" type="text" sortOrder="20"
                       showInDefault="1" showInWebsite="1" showInStore="1">
                    <label>Default map radius (km)</label>
                    <validate>validate-digits validate-greater-than-zero</validate>
                    <depends><field id="enabled">1</field></depends>
                </field>
            </group>
        </section>
    </system>
</config>
```

Defaults in `etc/config.xml`:

```xml
<default>
    <ravedigital_storelocator>
        <general>
            <enabled>0</enabled>
            <default_radius_km>25</default_radius_km>
        </general>
    </ravedigital_storelocator>
</default>
```

Centralize reads in a `Model\Config` class — do not scatter `scopeConfig->getValue()` calls.

API keys: use `Magento\Config\Model\Config\Backend\Encrypted` and list paths in deploy config
when pipelines inject secrets.

## acl.xml

```xml
<resource id="Magento_Backend::admin">
    <resource id="RaveDigital_StoreLocator::storelocator" title="Store Locator" sortOrder="90">
        <resource id="RaveDigital_StoreLocator::locations" title="Locations" sortOrder="10"/>
        <resource id="RaveDigital_StoreLocator::config" title="Configuration" sortOrder="20"/>
    </resource>
</resource>
```

## Routes, menu, controller

`etc/adminhtml/routes.xml`:

```xml
<route id="ravedigital_storelocator" frontName="ravedigital_storelocator">
    <module name="RaveDigital_StoreLocator"/>
</route>
```

`menu.xml` action: `ravedigital_storelocator/location/index`, resource:
`RaveDigital_StoreLocator::locations`.

```php
namespace RaveDigital\StoreLocator\Controller\Adminhtml\Location;

class Index extends \Magento\Backend\App\Action implements \Magento\Framework\App\Action\HttpGetActionInterface
{
    public const ADMIN_RESOURCE = 'RaveDigital_StoreLocator::locations';

    public function execute()
    {
        $page = $this->resultFactory->create(\Magento\Framework\Controller\ResultFactory::TYPE_PAGE);
        $page->setActiveMenu('RaveDigital_StoreLocator::storelocator');
        $page->getConfig()->getTitle()->prepend(__('Store Locations'));
        return $page;
    }
}
```

POST controllers: `HttpPostActionInterface`. Frontend POST: `CsrfAwareActionInterface` only when
you have a documented reason to customize CSRF handling.

## Admin grids

Modern listings are `ui_component` XML — see the **magento-admin-ui** skill for full grid/form
patterns. Minimum stack:

1. Layout: `ravedigital_store_location_index.xml` → `<uiComponent name="ravedigital_store_location_listing"/>`
2. Listing XML under `view/adminhtml/ui_component/`
3. Data provider + `CollectionFactory` registration in `etc/di.xml`

Study `Magento_Cms::cms_block_listing.xml` as a template — adapting core structure is standard practice.

## Cross-file consistency

| Must match |
|---|
| `system.xml` `<resource>` ↔ `acl.xml` id |
| `menu.xml` `resource` ↔ `acl.xml` |
| `menu.xml` `action` ↔ `routes.xml` frontName + controller path |
| Controller `ADMIN_RESOURCE` ↔ `acl.xml` |
| User-visible strings ↔ `i18n/en_US.csv` |
