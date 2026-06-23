# Storefront Flows

Patterns for Luma-compatible storefronts. **Default:** run via **Cursor browser** — use snapshot for roles/labels; TypeScript below is for **optional** local CI specs.

Hyvä/React checkout may need theme-specific selectors — inspect snapshot first.

## Customer registration

```typescript
test('customer can register', async ({ page }) => {
  await page.goto('/customer/account/create/');
  await page.getByLabel('First Name').fill('Test');
  await page.getByLabel('Last Name').fill('Customer');
  await page.getByLabel('Email', { exact: true }).fill(`test+${Date.now()}@example.com`);
  await page.getByLabel('Password', { exact: true }).fill('Test1234!');
  await page.getByLabel('Confirm Password').fill('Test1234!');
  await page.getByRole('button', { name: 'Create an Account' }).click();
  await expect(page.getByRole('heading', { name: 'My Account' })).toBeVisible();
});
```

## Customer login

See [selectors-and-pom.md](selectors-and-pom.md) `LoginPage` example.

```
Use Cursor browser tools to test customer login per storefront-flows.md.
```

## Optional local spec (CI)

## Product search

```typescript
test('search returns product', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('combobox', { name: /Search/i }).fill('bag');
  await page.getByRole('button', { name: 'Search' }).click();
  await expect(page.getByRole('link', { name: /Push Notification/i })).toBeVisible();
});
```

Selector names vary by theme — use codegen once, then refactor to `getByRole`:

```bash
npx playwright codegen $PLAYWRIGHT_BASE_URL
```

## Category navigation

```typescript
test('category page lists products', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('link', { name: 'Gear' }).click();
  await expect(page.getByRole('heading', { name: 'Gear' })).toBeVisible();
  await expect(page.locator('.product-item-info').first()).toBeVisible();
});
```

## Add to cart

```typescript
test('add simple product to cart', async ({ page }) => {
  await page.goto('/joust-duffle-bag.html');
  await page.getByRole('button', { name: 'Add to Cart' }).click();
  await expect(page.getByText('You added')).toBeVisible();
});
```

Configurable products: select options before Add to Cart.

## Mini cart validation

```typescript
test('mini cart shows line item', async ({ page }) => {
  await page.goto('/joust-duffle-bag.html');
  await page.getByRole('button', { name: 'Add to Cart' }).click();
  await page.getByRole('link', { name: /Shopping Cart/i }).click();
  await expect(page.getByRole('row', { name: /Joust Duffle Bag/ })).toBeVisible();
});
```

## Checkout flow (guest)

Multi-step — use a page object:

```typescript
// page-objects/CheckoutPage.ts — simplified
async fillShipping(email: string, first: string, last: string) {
  await this.page.getByLabel('Email').fill(email);
  await this.page.getByLabel('First Name').fill(first);
  await this.page.getByLabel('Last Name').fill(last);
  await this.page.getByRole('button', { name: 'Next' }).click();
}
```

```
Test Magento checkout flow.
```

Notes:

- Payment: use **check/money order** or **test payment** in dev
- Wait for shipping methods with `expect`, not sleep
- One-page checkout (Adobe) differs from multi-step Luma — match project theme

## Regression after upgrade

```
Generate regression tests for product search and guest checkout after 2.4.7 → 2.4.8 upgrade.
```

Cover: homepage, search, PDP, cart, checkout success page. Run against staging before production.

## Store locator example (RaveDigital_StoreLocator)

If custom storefront widget exists:

```typescript
test('store locator map loads', async ({ page }) => {
  await page.goto('/store-locator');
  await expect(page.getByRole('heading', { name: /Find a store/i })).toBeVisible();
  await expect(page.getByTestId('store-locator-map')).toBeVisible();
});
```

Add `data-testid` in module templates when building the feature (**magento-module**).
