# Storefront Layout, Templates, and View Models

## Request flow

`routes.xml` → front controller → action returns a `Page` result → layout system merges handles
(`default.xml` + route-specific XML from modules and theme) → blocks render `.phtml` templates.

Most storefront tasks are: layout XML + template + view model. Skip custom `Block` subclasses
unless you need `_prepareLayout` or custom cache identities.

## Layout XML

Path: `view/frontend/layout/<full_action_name>.xml`

Example — inject a store locator map on checkout (simplified):

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" layout="checkout"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="checkout.additional.fields">
            <block name="ravedigital.storelocator.map"
                   template="RaveDigital_StoreLocator::checkout/locator-map.phtml">
                <arguments>
                    <argument name="view_model" xsi:type="object">
                        RaveDigital\StoreLocator\ViewModel\LocatorMap
                    </argument>
                </arguments>
            </block>
        </referenceContainer>
    </body>
</page>
```

Useful operations:

- `<referenceContainer>` / `<referenceBlock>` — modify existing nodes
- `<move element="..." destination="..." before="-"/>`
- `<referenceBlock name="..." remove="true"/>`
- `<update handle="..."/>` — include another handle

No `class` on the block — default `Magento\Framework\View\Element\Template` is correct when
logic lives in the view model.

## View model

```php
namespace RaveDigital\StoreLocator\ViewModel;

use Magento\Framework\View\Element\Block\ArgumentInterface;
use RaveDigital\StoreLocator\Model\StoreHours;

class LocatorMap implements ArgumentInterface
{
    public function __construct(private readonly StoreHours $availability) {}

    /** @return array<int, string> hour => label */
    public function getAvailableHours(string $storeCode, string $date): array
    {
        return $this->availability->getOpenHours($storeCode, $date);
    }
}
```

Template `view/frontend/templates/checkout/locator-map.phtml`:

```php
<?php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \RaveDigital\StoreLocator\ViewModel\LocatorMap $viewModel */
$viewModel = $block->getData('view_model');
$hours = $viewModel->getAvailableHours('soho', '2026-06-20');
?>
<fieldset class="ravedigital-storelocator" data-mage-init='{"validation": {}}'>
    <legend><?= $escaper->escapeHtml(__('Find a store')) ?></legend>
    <select name="preferred_location_id" class="required-entry">
        <?php foreach ($hours as $hour => $label): ?>
            <option value="<?= $escaper->escapeHtmlAttr((string) $hour) ?>">
                <?= $escaper->escapeHtml($label) ?>
            </option>
        <?php endforeach; ?>
    </select>
</fieldset>
```

Escaping (required for security review):

| Output | Method |
|---|---|
| Text | `$escaper->escapeHtml()` |
| Attributes | `escapeHtmlAttr()` |
| URLs | `escapeUrl()` |
| Inline JS | `escapeJs()` |

Use `$escaper` (available since 2.4), not deprecated `$block->escapeHtml()`.

## Full-page cache

`cacheable="false"` on a block disables FPC for **every page using that handle**. For per-customer
fragments use:

- Customer sections (`sections.xml` + `customer-data`)
- Private blocks / ESI with Varnish
- Ajax-loaded partials

Models rendered on cacheable pages should implement `IdentityInterface` so tags invalidate correctly.

## JavaScript

Luma: RequireJS + optional Knockout via `data-mage-init`; register mixins in `requirejs-config.js`.
Keep JS small — heavy KO is a common Luma performance issue.

**Hyvä themes** use Alpine.js + Tailwind. Before writing Knockout:

```bash
composer show hyva-themes/magento2-default-theme 2>/dev/null
```

Hyvä templates use `x-data` instead of `data-mage-init`. Ship dual-theme support via a
`hyva-themes/...` compatibility module when needed.

## Controllers and routes

`etc/frontend/routes.xml` (router `standard`), controller implements `HttpGetActionInterface` /
`HttpPostActionInterface`, return `ResultFactory` results (`TYPE_PAGE`, `TYPE_JSON`, `TYPE_REDIRECT`).
Avoid echoing output or extending deprecated `Action\Action`.

## Static assets

Developer mode: flush `pub/static` as needed. Production: `setup:static-content:deploy` after JS/CSS
changes. Layout/template changes: `cache:clean layout block_html full_page`.
