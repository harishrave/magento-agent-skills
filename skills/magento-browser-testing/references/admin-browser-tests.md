# Admin Panel Browser Tests

Validate custom admin modules (grids, forms) and core smoke after deploy.

**Default:** use **Playwright MCP** — navigate to admin URL, log in via snapshot fields, assert grid columns load. TypeScript below is for **optional** local CI specs.

## Admin authentication

Save session once, reuse across specs:

```typescript
// tests/admin/auth.setup.ts
import { test as setup, expect } from '@playwright/test';

const authFile = 'playwright/.auth/admin.json';

setup('authenticate admin', async ({ page }) => {
  await page.goto('/admin');
  await page.getByLabel('Username').fill(process.env.MAGENTO_ADMIN_USER!);
  await page.getByLabel('Password').fill(process.env.MAGENTO_ADMIN_PASSWORD!);
  await page.getByRole('button', { name: 'Sign in' }).click();
  await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible();
  await page.context().storageState({ path: authFile });
});
```

```typescript
// playwright.config.ts
projects: [
  { name: 'setup', testMatch: /auth\.setup\.ts/ },
  {
    name: 'admin',
    use: { storageState: 'playwright/.auth/admin.json' },
    dependencies: ['setup'],
  },
],
```

## Custom module grid (RaveDigital_StoreLocator)

After **magento-admin-ui** builds `ravedigital_store_location_listing`:

```typescript
import { test, expect } from '@playwright/test';

test.describe('Store locator admin', () => {
  test('location grid loads with columns', async ({ page }) => {
    await page.goto('/admin/ravedigital_storelocator/location/index/');
    await expect(page.getByRole('columnheader', { name: 'Store code' })).toBeVisible();
    await expect(page.getByRole('columnheader', { name: 'Status' })).toBeVisible();
    await expect(page.locator('.admin__data-grid-loading-mask')).toBeHidden();
  });
});
```

Admin grids use Magento UI components — wait for loading mask to hide before asserting rows.

## Admin form save

```typescript
test('can open new location form', async ({ page }) => {
  await page.goto('/admin/ravedigital_storelocator/location/index/');
  await page.getByRole('button', { name: 'Add New' }).click();
  await expect(page.getByRole('heading', { name: /New Location|Location/i })).toBeVisible();
  await page.getByLabel('Store code').fill('nyc_flagship');
  await page.getByRole('button', { name: 'Save' }).click();
  await expect(page.getByText('You saved the location')).toBeVisible();
});
```

## Browser workflow (manual + automated)

Align with **magento-admin-ui** troubleshooting:

1. Load grid in browser
2. Check `var/log/system.log` and browser console for JS errors
3. Automate the happy path with Playwright once selectors are stable

## ACL / 404

If test gets 404 or login redirect:

- Verify module enabled: `bin/magento module:status RaveDigital_StoreLocator`
- Verify admin user has `RaveDigital_StoreLocator::locations` ACL
- URL must match `routes.xml` frontName + controller path

## CAPTCHA / 2FA

Disable for test admin in dev, or use IP allowlist. Do not bypass security on production.
