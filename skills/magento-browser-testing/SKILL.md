---
name: magento-browser-testing
description: >-
  Magento 2 / Mage-OS / Adobe Commerce browser testing in Cursor using built-in browser tools:
  functional, regression, and E2E UI validation, customer login, checkout, product search, cart,
  B2B flows, and admin panel checks. Use when the user asks to test in browser, validate UI,
  checkout flow, customer login, admin grid in browser, or debug browser failures. Default path is
  Cursor browser MCP — no npm install. Use local @playwright/test only for CI regression suites.
  Optional Playwright MCP for non-Cursor clients. For PHPUnit use magento-testing. For module code
  use magento-module.
---

# Magento Browser Testing (RaveDigital)

Browser validation for Magento storefront and admin using **Cursor's built-in browser tools**.

## Default: Cursor browser (no extra MCP)

RaveDigital teams on **Cursor** do **not** need Playwright MCP or `npm init playwright` for interactive testing.

1. **Use Cursor browser tools** — navigate, snapshot, click, type, screenshot.
2. **Read** [references/cursor-browser.md](references/cursor-browser.md) for workflow and prompts.
3. **Report** findings; screenshot on failure.
4. **Do not** default to `*.spec.ts` unless user asks for **CI regression** — [playwright-setup.md](references/playwright-setup.md).

Optional: [playwright-mcp-optional.md](references/playwright-mcp-optional.md) for non-Cursor MCP clients only.

## Skill behavior (always)

| Step | Action |
|---|---|
| 1 | Prefer **Cursor browser tools** over writing spec files |
| 2 | Snapshot before interact — use roles/labels from accessibility tree |
| 3 | Never hard-code production URLs |
| 4 | If user wants **CI regression**, switch to [playwright-setup.md](references/playwright-setup.md) |
| 5 | If user is **not on Cursor**, point to [playwright-mcp-optional.md](references/playwright-mcp-optional.md) |

## Workflow — pick your task

| Task | Read first |
|---|---|
| **Cursor browser testing (default)** | [references/cursor-browser.md](references/cursor-browser.md) |
| Local Playwright for CI (optional) | [references/playwright-setup.md](references/playwright-setup.md) |
| Playwright MCP (non-Cursor only) | [references/playwright-mcp-optional.md](references/playwright-mcp-optional.md) |
| Selectors and interaction patterns | [references/selectors-and-pom.md](references/selectors-and-pom.md) |
| Storefront: login, search, cart, checkout | [references/storefront-flows.md](references/storefront-flows.md) |
| B2B: company, quotes, approval | [references/b2b-flows.md](references/b2b-flows.md) |
| Admin panel validation | [references/admin-browser-tests.md](references/admin-browser-tests.md) |
| Failures | [references/browser-troubleshooting.md](references/browser-troubleshooting.md) |
| Pre-merge checklist | [references/browser-test-checklist.md](references/browser-test-checklist.md) |

## Selector priority

1. Role / button name (from snapshot)
2. Label (forms)
3. `data-testid`
4. Visible text (exact when possible)

See [selectors-and-pom.md](references/selectors-and-pom.md).

## Master prompts (copy-paste)

See [docs/example-prompts.md](../../docs/example-prompts.md#magento-browser-testing) for the full library.

**Storefront smoke:**

```
Use Cursor browser tools to smoke-test the storefront: homepage loads, customer login form visible.
Screenshot failures. cursor-browser.md. Base URL: https://magento.test
```

**Guest checkout:**

```
Validate guest checkout through shipping with Cursor browser per storefront-flows.md.
Add product → checkout → shipping. Report pass/fail with steps.
```

**Admin grid:**

```
Validate RaveDigital_StoreLocator admin grid in Cursor browser — columns load, no stuck spinner.
admin-browser-tests.md
```

## Decision shortcuts

| User says | Action |
|---|---|
| Test in browser / validate UI | **Cursor browser** — this skill |
| Add CI tests / `npx playwright test` | [playwright-setup.md](references/playwright-setup.md) |
| PHPUnit / phpcs | **magento-testing** |
| Build admin grid | **magento-admin-ui** → browser validate here |
| MFTF | Only if user explicitly asks |

## Handoffs

| After browser test finds… | Skill |
|---|---|
| PHP/module bug | **magento-module** |
| Admin ui_component issue | **magento-admin-ui** |
| Missing PHPUnit coverage | **magento-testing** |

## Agent compatibility

Skills: `./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).  
Cursor browser: [docs/install.md](../../docs/install.md#cursor-browser-testing).
