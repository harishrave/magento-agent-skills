# How to Extend Core Magento Behavior

Magento gives you several hooks to change platform behavior. Choosing the wrong one is the
fastest path to upgrade pain and module conflicts. Walk through the flowchart below and stop
at the first match.

## Flowchart

1. **Is there a purpose-built hook?** (domain event, extension attribute, `di.xml` array
   argument, layout handle, queue topic) → use that first.
2. **React after something happens, without changing its outcome?** → **event observer**.
3. **Change arguments or return value of a public method?** → **plugin** (interceptor).
4. **Must reach protected/private code?** → redesign if possible (plugin a different public
   method). Only then consider a **preference** with the smallest possible override.

## Plugins

Register in area-scoped `etc/di.xml` when the change is area-specific:

```xml
<type name="Magento\Quote\Api\CartRepositoryInterface">
    <plugin name="ravedigital_storelocator_validate_address"
            type="RaveDigital\StoreLocator\Plugin\Quote\ValidateStoreCoordinates"
            sortOrder="20"/>
</type>
```

```php
namespace RaveDigital\StoreLocator\Plugin\Quote;

use Magento\Quote\Api\CartRepositoryInterface;
use Magento\Quote\Api\Data\CartInterface;

class ValidateStoreCoordinates
{
    /**
     * Reject saves when the selected store locator is no longer available.
     */
    public function beforeSave(
        CartRepositoryInterface $subject,
        CartInterface $quote
    ): array {
        // return [$quote] unchanged, or throw LocalizedException to block the save
        return [$quote];
    }

    public function afterGet(
        CartRepositoryInterface $subject,
        CartInterface $result
    ): CartInterface {
        return $result;
    }
}
```

Practical limits:

- Plugins only wrap **public** methods on classes the ObjectManager builds. They do **not**
  apply to `final` classes/methods, private/protected methods, `__construct`, virtual types,
  or objects created with `new`.
- Prefer `after` over `before`, and use `around` only when you must short-circuit. A broken
  `around` plugin that skips `$proceed()` disables every lower `sortOrder` plugin on that method.
- Targeting an **interface** (`CartRepositoryInterface`) applies to all implementations — usually
  what you want for service contracts.
- Inspect effective plugins: `bin/magento dev:di:info "Magento\Quote\Api\CartRepositoryInterface"`.

## Observers

Side effects only — observers cannot change the outcome of the event that already fired.

```xml
<!-- etc/events.xml -->
<event name="sales_order_place_after">
    <observer name="ravedigital_storelocator_geocode_location"
              instance="RaveDigital\StoreLocator\Observer\GeocodeLocation"/>
</event>
```

```php
namespace RaveDigital\StoreLocator\Observer;

use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;

class GeocodeLocation implements ObserverInterface
{
    public function execute(Observer $observer): void
    {
        $order = $observer->getEvent()->getOrder();
        // persist location row, enqueue geocode job, etc.
    }
}
```

- Heavy work belongs in a message queue, not inline in the observer.
- Confirm event names by grepping core for `->dispatch('` in the relevant area.
- Scope with `etc/frontend/events.xml` when the observer is storefront-only.

## Preferences (last resort)

```xml
<preference for="Magento\Shipping\Model\Carrier\AbstractCarrier"
            type="RaveDigital\StoreLocator\Model\Carrier\InStorePickup"/>
```

Only one preference wins per class globally. Two modules rewriting the same class is an
unresolvable conflict (module `sequence` decides the survivor). Legitimate uses:

- Binding **your** interface to **your** implementation (normal DI, not a "rewrite").
- Replacing a class that has zero extension points — document why in the module README.

When extending core, override the minimum and call `parent::`.

## Constructor argument injection (often overlooked)

Many core classes accept strategy arrays in their constructor. Add your item via `di.xml`
instead of subclassing:

```xml
<type name="Magento\Sales\Model\Order\Email\Container\OrderIdentity">
    <arguments>
        <argument name="templateContainer" xsi:type="array">
            <item name="locator_ready" xsi:type="string">ravedigital_storelocator_updated</item>
        </argument>
    </arguments>
</type>
```

Read the target class constructor before reaching for a plugin.

## Quick lookup

| Goal | Use |
|---|---|
| Log, email, or queue after an action | Observer |
| Alter method input | `before` plugin |
| Alter method output | `after` plugin |
| Skip or replace a method body | `around` plugin (rare) |
| Register a handler/strategy | `di.xml` `<arguments>` array item |
| Expose your own service | `preference` on your `Api/` interface |
| Replace core class entirely | `preference` (document + sequence review) |
