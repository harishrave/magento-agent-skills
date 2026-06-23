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

## Local Playwright (optional — CI only)

- [ ] User explicitly requested CI/regression suite
- [ ] `@playwright/test` in `package.json`; browsers installed
- [ ] `playwright.config.ts` with `baseURL` from env
- [ ] `npx playwright test` passes locally

## Handoffs

- [ ] PHP bugs → **magento-module**
- [ ] Grid/form bugs → **magento-admin-ui**
- [ ] Missing PHPUnit → **magento-testing**
