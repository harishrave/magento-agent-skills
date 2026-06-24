# Browser Test Completion Checklist

## Cursor browser (default — interactive)

- [ ] Magento project open as Cursor workspace root
- [ ] New Agent chat after skill install
- [ ] Tested against **dev/staging** — not production
- [ ] Base URL confirmed (`bin/magento config:show web/unsecure/base_url` or user prompt)
- [ ] CAPTCHA/2FA disabled in test environment
- [ ] Agent used snapshot + stable roles/labels — not brittle CSS
- [ ] Screenshot on failure or for deliverable
- [ ] Findings documented (pass/fail + steps to reproduce)

## Optional Playwright MCP (explicit Playwright request)

- [ ] User asked for Playwright / E2E automation / generated specs
- [ ] `.cursor/mcp.json` has `playwright` server or setup instructions given
- [ ] `npx playwright install chromium` run if browsers missing
- [ ] Exploration via Playwright MCP; specs use getByRole/getByLabel/getByTestId
- [ ] Screenshots on failure

## Local Playwright (optional — CI only)

- [ ] User explicitly requested CI/regression suite
- [ ] `@playwright/test` in `package.json`; browsers installed
- [ ] `playwright.config.ts` with `baseURL` from env
- [ ] `npx playwright test` passes locally

## Handoffs

- [ ] PHP bugs → **magento-module**
- [ ] Grid/form bugs → **magento-admin-ui**
- [ ] Code quality → **magento-module** (`static-analysis.md`)
