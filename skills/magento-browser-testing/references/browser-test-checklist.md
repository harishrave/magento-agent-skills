# Browser Test Completion Checklist

## Playwright MCP (default — interactive)

- [ ] Playwright MCP configured in Cursor (`.cursor/mcp.json` or user settings)
- [ ] `npx playwright install chromium` run once if browser missing
- [ ] Tested against **dev/staging** — not production
- [ ] Storefront/admin URLs confirmed with user or `bin/magento config:show web/unsecure/base_url`
- [ ] CAPTCHA/2FA disabled in test environment
- [ ] Agent used snapshot/role/label — not brittle CSS
- [ ] Screenshot captured on failure or for deliverable
- [ ] Findings documented (pass/fail + steps to reproduce)

## Local Playwright (optional — CI only)

- [ ] User explicitly requested CI/regression suite
- [ ] `@playwright/test` in `package.json`; browsers installed
- [ ] `playwright.config.ts` with `baseURL` from env
- [ ] `npx playwright test` passes locally
- [ ] Secrets in `.env` (gitignored)

## Handoffs

- [ ] PHP bugs → **magento-module**
- [ ] Grid/form bugs → **magento-admin-ui**
- [ ] Missing PHPUnit → **magento-testing**
