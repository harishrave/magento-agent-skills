---
name: magento-browser-testing
description: >-
  Magento 2 / Mage-OS / Adobe Commerce browser testing via Playwright MCP in Cursor: functional,
  regression, and E2E UI validation, customer login, checkout, product search, cart, B2B flows,
  and admin panel checks. Use when the user asks to test in browser, Playwright MCP, validate UI,
  checkout flow, customer login, admin grid in browser, or debug browser failures. Default path is
  Playwright MCP + Cursor — not local npm install. Use local @playwright/test only for CI regression
  suites. For PHPUnit use magento-testing. For module code use magento-module.
---

# Magento Browser Testing (RaveDigital)

Browser validation for Magento storefront and admin using **Playwright MCP in Cursor**.

## Default: Playwright MCP + Cursor

RaveDigital teams **do not** require `npm init playwright` in the Magento repo for interactive testing.

1. **Check Playwright MCP** — configured in Cursor (`.cursor/mcp.json` or user MCP settings).
2. **If missing** — setup steps in [references/playwright-mcp.md](references/playwright-mcp.md).
3. **Run tests via MCP** — navigate, snapshot, click, type, screenshot; use accessibility tree (role/label/text).
4. **Report** findings; screenshot on failure.

Local `*.spec.ts` suite: **only** when user asks for CI, regression in git, or `npx playwright test` — see [references/playwright-setup.md](references/playwright-setup.md).

## Skill behavior (always)

| Step | Action |
|---|---|
| 1 | Prefer **Playwright MCP** tools over writing spec files |
| 2 | If MCP unavailable, guide [playwright-mcp.md](references/playwright-mcp.md) setup |
| 3 | Use stable interactions — roles, labels, test ids from snapshot |
| 4 | Never hard-code production URLs |
| 5 | If user wants **CI regression**, switch to [playwright-setup.md](references/playwright-setup.md) |

## Workflow — pick your task

| Task | Read first |
|---|---|
| **Playwright MCP + Cursor setup** | [references/playwright-mcp.md](references/playwright-mcp.md) |
| Local Playwright for CI (optional) | [references/playwright-setup.md](references/playwright-setup.md) |
| Selectors and interaction patterns | [references/selectors-and-pom.md](references/selectors-and-pom.md) |
| Storefront: login, search, cart, checkout | [references/storefront-flows.md](references/storefront-flows.md) |
| B2B: company, quotes, approval | [references/b2b-flows.md](references/b2b-flows.md) |
| Admin panel validation | [references/admin-browser-tests.md](references/admin-browser-tests.md) |
| Failures / MCP issues | [references/browser-troubleshooting.md](references/browser-troubleshooting.md) |
| Pre-merge checklist | [references/browser-test-checklist.md](references/browser-test-checklist.md) |

## MCP setup (quick reference)

`.cursor/mcp.json` in Magento project:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

One-time: `npx playwright install chromium`

## Selector priority

Same for MCP snapshots and local specs:

1. Role / button name
2. Label (forms)
3. `data-testid`
4. Visible text (exact when possible)

Avoid fragile CSS/XPath. See [selectors-and-pom.md](references/selectors-and-pom.md).

## Master prompts (copy-paste)

See [docs/example-prompts.md](../../docs/example-prompts.md#magento-browser-testing) for the full library.

**Storefront smoke (MCP):**

```
Smoke-test storefront with Playwright MCP: homepage loads, customer login form visible.
Screenshot failures. playwright-mcp.md. Base URL: https://magento.test
```

**Guest checkout (MCP):**

```
Validate guest checkout through shipping with Playwright MCP per storefront-flows.md.
Add product → checkout → shipping address. Report pass/fail with steps.
```

**Admin grid (MCP):**

```
Validate RaveDigital_StoreLocator admin grid with Playwright MCP — columns load, no stuck spinner.
admin-browser-tests.md
```

## Decision shortcuts

| User says | Action |
|---|---|
| Test in browser / validate UI / Playwright MCP | MCP workflow — this skill |
| Add CI tests / `npx playwright test` / spec files | [playwright-setup.md](references/playwright-setup.md) |
| PHPUnit / phpcs | **magento-testing** |
| Build admin grid | **magento-admin-ui** → MCP validate here |
| MFTF | Mention only if user explicitly asks |

## Handoffs

| After browser test finds… | Skill |
|---|---|
| PHP/module bug | **magento-module** |
| Admin ui_component issue | **magento-admin-ui** |
| Missing PHPUnit coverage | **magento-testing** |

## Agent compatibility

Skills: `./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).  
MCP: [docs/install.md](../../docs/install.md#playwright-mcp-cursor).
