---
name: magento-browser-testing
description: >-
  Magento 2 / Mage-OS / Adobe Commerce browser testing, UI testing, E2E testing, automation
  testing, website validation, and Playwright tests. Default path is Cursor built-in browser
  (no npm install). Optional Playwright MCP when user explicitly asks for Playwright, Playwright
  tests, or E2E automation with generated specs. Local @playwright/test for CI regression suites.
  Flows: login, registration, product search, cart, checkout, company accounts, RFQ, admin
  validation. For PHPCS/PHPStan use magento-module. For module code use magento-module.
---

# Magento Browser Testing (RaveDigital)

Browser validation for Magento storefront, admin, and B2B using **Cursor's built-in browser tools** by default.

## Default: Cursor browser (no extra MCP)

RaveDigital teams on **Cursor** do **not** need Playwright MCP or `npm init playwright` for interactive browser testing, UI validation, or smoke E2E checks.

1. **Use Cursor browser tools** — navigate, snapshot, click, type, screenshot.
2. **Read** [references/cursor-browser.md](references/cursor-browser.md).
3. **Report** findings; screenshot on failure.
4. **Do not** default to `*.spec.ts` unless user asks for **Playwright tests** or **CI regression**.

## Optional: Playwright MCP (explicit request only)

When the user asks for **Playwright**, **Playwright tests**, **E2E automation**, or **generated test specs**, follow [references/playwright-mcp-optional.md](references/playwright-mcp-optional.md):

| Step | Action |
|---|---|
| 1 | Check whether Playwright MCP is configured (`.cursor/mcp.json`, MCP panel) |
| 2 | If not configured — provide install + `.cursor/mcp.json` setup instructions |
| 3 | Explain how to enable MCP in Cursor (Settings → MCP, restart, new chat) |
| 4 | Use Playwright MCP for browser exploration when available |
| 5 | Generate Playwright tests from observed browser actions |
| 6 | Prefer `getByRole()`, `getByLabel()`, `getByTestId()` — [selectors-and-pom.md](references/selectors-and-pom.md) |
| 7 | Capture screenshots for debugging |
| 8 | Support Magento flows — login, registration, search, cart, checkout, company accounts, RFQ, admin |

## Skill behavior (always)

| Step | Action |
|---|---|
| 1 | **Default:** Cursor browser for browser/UI/E2E validation without saying "Playwright" |
| 2 | Snapshot before interact — roles/labels from accessibility tree |
| 3 | Never hard-code production URLs |
| 4 | User says **Playwright** / wants **spec files** → [playwright-mcp-optional.md](references/playwright-mcp-optional.md) |
| 5 | User wants **CI regression** → [playwright-setup.md](references/playwright-setup.md) |

## Workflow — pick your task

| Task | Read first |
|---|---|
| **Cursor browser testing (default)** | [references/cursor-browser.md](references/cursor-browser.md) |
| **Playwright MCP (optional)** | [references/playwright-mcp-optional.md](references/playwright-mcp-optional.md) |
| Local Playwright for CI | [references/playwright-setup.md](references/playwright-setup.md) |
| Selectors and interaction patterns | [references/selectors-and-pom.md](references/selectors-and-pom.md) |
| Storefront: login, search, cart, checkout | [references/storefront-flows.md](references/storefront-flows.md) |
| B2B: company, quotes, RFQ | [references/b2b-flows.md](references/b2b-flows.md) |
| Admin panel validation | [references/admin-browser-tests.md](references/admin-browser-tests.md) |
| Failures | [references/browser-troubleshooting.md](references/browser-troubleshooting.md) |
| Pre-merge checklist | [references/browser-test-checklist.md](references/browser-test-checklist.md) |

## Selector priority

1. `getByRole()` / role from snapshot
2. `getByLabel()` / label from snapshot
3. `getByTestId()`
4. Visible text (exact when possible)

See [selectors-and-pom.md](references/selectors-and-pom.md).

## Master prompts (copy-paste)

See [docs/example-prompts.md](../../docs/example-prompts.md#magento-browser-testing).

**Storefront smoke (default — Cursor browser):**

```
Use Cursor browser tools to smoke-test the storefront: homepage loads, customer login form visible.
Screenshot failures. cursor-browser.md. Base URL: https://magento.test
```

**Playwright E2E (optional):**

```
Use Playwright MCP to validate customer login, then generate tests/storefront/login.spec.ts
with getByRole/getByLabel. playwright-mcp-optional.md
```

## Decision shortcuts

| User says | Action |
|---|---|
| Test in browser / validate UI / website validation | **Cursor browser** |
| **Playwright** / Playwright tests / E2E automation specs | [playwright-mcp-optional.md](references/playwright-mcp-optional.md) |
| CI / `npx playwright test` | [playwright-setup.md](references/playwright-setup.md) |
| PHPCS / PHPStan | **magento-module** (`static-analysis.md`) |
| MFTF | Only if user explicitly asks |

## Handoffs

| After browser test finds… | Skill |
|---|---|
| PHP/module bug | **magento-module** |
| Admin ui_component issue | **magento-module** (`admin-ui-troubleshooting.md`) |
| Code quality gaps | **magento-module** (`static-analysis.md`) |

## Agent compatibility

Skills: `./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).  
Cursor browser: [docs/install.md](../../docs/install.md#cursor-browser-testing).
