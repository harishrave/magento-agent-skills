# Local Playwright (optional — CI / regression)

Use this **only** when the team needs a **versioned test suite** in git or **CI** (`npx playwright test` on every PR).

For day-to-day validation in Cursor, use **[cursor-browser.md](cursor-browser.md)** — no npm or extra MCP config.

## When to use local vs Cursor browser

| Scenario | Use |
|---|---|
| "Test checkout in browser now" | Cursor browser |
| "Validate admin grid while coding" | Cursor browser |
| "Add regression tests for CI" | Local Playwright (this doc) |
| "Don't break login on 2.4.8 upgrade" | Local Playwright |

## Detect existing install

| Signal | Location |
|---|---|
| Config | `playwright.config.ts`, `playwright.config.js` |
| Dependency | `package.json` → `@playwright/test` |
| Tests | `tests/`, `e2e/` |

## Install

From Magento root or dedicated `e2e/` folder:

```bash
npm init playwright@latest
```

Or:

```bash
npm install -D @playwright/test
npx playwright install
```

## Minimal config

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? 'https://magento.test',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
});
```

## Environment

```bash
PLAYWRIGHT_BASE_URL=https://magento.test
MAGENTO_ADMIN_USER=admin
MAGENTO_ADMIN_PASSWORD=***
MAGENTO_CUSTOMER_EMAIL=customer@example.com
MAGENTO_CUSTOMER_PASSWORD=***
```

## Run

```bash
npx playwright test
npx playwright test tests/storefront/login.spec.ts
npx playwright test --ui
npx playwright show-report
```

## Patterns

Follow [selectors-and-pom.md](selectors-and-pom.md), [storefront-flows.md](storefront-flows.md), and [admin-browser-tests.md](admin-browser-tests.md) for spec examples.

After Cursor browser exploration validates a flow, **optionally** codify it as a `*.spec.ts` for CI.

## Magento notes

- CAPTCHA / 2FA off in test env
- `bin/magento cache:flush` if stale UI during dev
- Prefer `e2e/` subfolder to keep PHP repo root clean
