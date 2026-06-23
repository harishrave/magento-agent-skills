# Selectors, Assertions, and Page Objects

Applies to **Playwright MCP** (pick elements from accessibility snapshot by role/label) and **optional** local `@playwright/test` specs.

## Selector priority

```typescript
// 1. Role (best for buttons, links, headings)
await page.getByRole('button', { name: 'Sign In' }).click();
await page.getByRole('link', { name: 'My Account' }).click();

// 2. Label (forms)
await page.getByLabel('Email').fill('customer@example.com');
await page.getByLabel('Password').fill('Password1!');

// 3. Test id (custom modules — add in templates)
await page.getByTestId('store-locator-search').click();

// 4. Text (use exact when duplicate text exists)
await page.getByText('Add to Cart', { exact: true }).click();
```

Avoid unless necessary:

```typescript
// Fragile — theme/class changes break tests
await page.locator('.action.primary.tocart').click();
await page.locator('xpath=//div[@id="checkout"]//button[1]').click();
```

## Explicit assertions

Always use Playwright `expect` — not manual `if` checks:

```typescript
import { test, expect } from '@playwright/test';

test('mini cart shows item count', async ({ page }) => {
  await page.goto('/simple-product.html');
  await page.getByRole('button', { name: 'Add to Cart' }).click();
  await expect(page.getByRole('link', { name: /Shopping Cart/ })).toBeVisible();
  await expect(page.locator('.counter-number')).toHaveText('1');
});
```

## Wait for readiness — not sleep

```typescript
// Good
await expect(page.getByRole('heading', { name: 'Checkout' })).toBeVisible();
await page.getByLabel('Email').fill('guest@example.com');

// Bad (avoid)
await page.waitForTimeout(3000);
```

Use `waitForTimeout` only when debugging a known animation with no stable locator — document why.

## Page object model

Use POM when a flow has 3+ steps or repeats across specs.

```typescript
// page-objects/LoginPage.ts
import { type Page, expect } from '@playwright/test';

export class LoginPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/customer/account/login/');
  }

  async login(email: string, password: string) {
    await this.page.getByLabel('Email').fill(email);
    await this.page.getByLabel('Password').fill(password);
    await this.page.getByRole('button', { name: 'Sign In' }).click();
    await expect(this.page.getByRole('heading', { name: 'My Account' })).toBeVisible();
  }
}
```

```typescript
// tests/storefront/login.spec.ts
import { test } from '@playwright/test';
import { LoginPage } from '../../page-objects/LoginPage';

test.describe('Customer login', () => {
  test('registered customer can sign in', async ({ page }) => {
    const login = new LoginPage(page);
    await login.goto();
    await login.login(process.env.MAGENTO_CUSTOMER_EMAIL!, process.env.MAGENTO_CUSTOMER_PASSWORD!);
  });
});
```

## Fixtures (shared auth)

```typescript
// tests/fixtures/auth.ts
import { test as base } from '@playwright/test';
import { LoginPage } from '../page-objects/LoginPage';

export const test = base.extend({
  loggedInCustomer: async ({ page }, use) => {
    const login = new LoginPage(page);
    await login.goto();
    await login.login(process.env.MAGENTO_CUSTOMER_EMAIL!, process.env.MAGENTO_CUSTOMER_PASSWORD!);
    await use(page);
  },
});
```

## Test descriptions

```typescript
test.describe('Store locator admin grid', () => {
  test('lists enabled locations with store code column', async ({ page }) => {
    // ...
  });
});
```

## Screenshots and traces

Config (see [playwright-setup.md](playwright-setup.md)):

```typescript
use: {
  screenshot: 'only-on-failure',
  trace: 'on-first-retry',
}
```

Manual debug in a test:

```typescript
await page.screenshot({ path: 'debug-checkout-shipping.png', fullPage: true });
```

After failure:

```bash
npx playwright show-trace test-results/.../trace.zip
```

## API-assisted UI testing

Seed state via REST/GraphQL, assert UI:

```typescript
test('order history shows placed order', async ({ page, request }) => {
  // Create order via API (integration token) — project-specific helper
  await seedCustomerOrder(request);
  await page.goto('/sales/order/history/');
  await expect(page.getByText('000000123')).toBeVisible();
});
```

Keep API helpers in `tests/helpers/` — not in every spec file.
