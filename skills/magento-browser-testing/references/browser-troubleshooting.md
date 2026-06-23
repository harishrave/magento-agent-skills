# Browser Test Troubleshooting

## Playwright MCP (Cursor — default)

| Symptom | Fix |
|---|---|
| MCP server missing | Add [playwright-mcp.md](playwright-mcp.md) `.cursor/mcp.json`; restart Cursor |
| 0 tools / red status | Use `"args": ["-y", "@playwright/mcp@latest"]`; Node 18+ |
| Browser not found | `npx playwright install chromium` |
| Agent writes spec files instead of using MCP | User wants CI — see local section below; else remind: use Playwright MCP |
| Wrong site loaded | Open **Magento project** in Cursor; confirm base URL with user |
| Admin login fails | CAPTCHA off; correct `/admin` URL; credentials in prompt |

## Local Playwright (CI only)

| Symptom | Fix |
|---|---|
| `playwright: not found` | [playwright-setup.md](playwright-setup.md) |
| Browser binaries missing | `npx playwright install chromium` |

## Flaky tests

| Symptom | Fix |
|---|---|
| Element not found | Replace sleep with `expect(locator).toBeVisible()` |
| Stale element | Re-query after navigation: `page.getByRole(...)` |
| Race on AJAX grid | `await expect(loadingMask).toBeHidden()` |
| Parallel collisions | Unique customer emails `test+${Date.now()}@example.com`; `workers: 1` in CI |

## Debug failing test

```bash
npx playwright test tests/checkout.spec.ts --debug
npx playwright test tests/checkout.spec.ts --trace on
npx playwright show-report
npx playwright show-trace test-results/.../trace.zip
```

Add in test temporarily:

```typescript
await page.pause(); // step through in inspector
await page.screenshot({ path: 'debug.png', fullPage: true });
```

## Wrong base URL

```bash
PLAYWRIGHT_BASE_URL=https://magento.test npx playwright test
```

Verify `bin/magento config:show web/unsecure/base_url` matches.

## Selector broke after theme change

1. `npx playwright codegen $PLAYWRIGHT_BASE_URL`
2. Refactor recording to `getByRole` / `getByLabel`
3. Add `data-testid` in custom module templates for stable hooks

## Admin tests redirect to login

- Re-run `auth.setup.ts`
- Delete stale `playwright/.auth/admin.json`
- Check session cookie domain matches `baseURL`

## Checkout payment failures

Use check/money order or sandbox payment in `env.php` / admin config — never real cards in tests.

## PHPUnit vs Playwright

| Layer | Tool | Skill |
|---|---|---|
| PHP unit/integration | PHPUnit | **magento-testing** |
| Browser E2E (interactive) | Playwright MCP in Cursor | **magento-browser-testing** |
| Browser E2E (CI specs) | Local `@playwright/test` | **magento-browser-testing** → playwright-setup.md |
| Adobe native functional | MFTF | Only if user explicitly requests MFTF |
