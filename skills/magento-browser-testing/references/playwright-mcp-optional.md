# Playwright MCP (optional)

**Optional path** when the user explicitly asks for **Playwright**, **Playwright tests**, **E2E automation**, or **generated test specs** from browser exploration.

For interactive validation without Playwright setup, use **[cursor-browser.md](cursor-browser.md)** (RaveDigital default).

## When to use this path

| User asks for… | Use |
|---|---|
| Test in browser / validate UI / smoke test | **Cursor browser** — [cursor-browser.md](cursor-browser.md) |
| **Playwright**, Playwright MCP, Playwright tests | **This doc** |
| E2E **automation suite** / generate `*.spec.ts` from exploration | **This doc** |
| CI pipeline (`npx playwright test` on every PR) | [playwright-setup.md](playwright-setup.md) |

## Agent workflow (when Playwright is requested)

### 1. Check Playwright MCP configuration

- Look for `.cursor/mcp.json` in the **Magento project root** with a `playwright` server entry
- Confirm Playwright MCP tools are available in the current Cursor session (MCP panel shows **playwright** connected)

If not configured, continue to step 2. If configured, skip to step 4.

### 2. Provide setup instructions

**Install Playwright browsers** (one-time per machine):

```bash
npx playwright install chromium
```

**Configure `.cursor/mcp.json`** in the Magento project root:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

Commit `.cursor/mcp.json` for team rollout if appropriate (config only — no test suite required in repo).

### 3. Enable MCP in Cursor

1. **Cursor Settings** → **MCP** → verify the **playwright** server appears
2. **Restart Cursor** or reload MCP after saving `.cursor/mcp.json`
3. Start a **new Agent chat** so tools are picked up
4. Re-run the user's Playwright request

### 4. Use Playwright MCP for browser exploration

- Navigate storefront, admin, and B2B URLs via Playwright MCP tools
- Read accessibility snapshots before interacting
- Prefer stable roles and labels from the snapshot
- **Screenshot** on failure or when the user wants evidence

Do **not** add Playwright MCP if **Cursor browser** already satisfies the request — avoid running two browser MCP servers unless the user explicitly wants Playwright.

### 5. Generate Playwright tests from observed actions

After exploration validates a flow:

- Codify steps as `*.spec.ts` using `@playwright/test` patterns
- Place under `tests/` or `e2e/` per [playwright-setup.md](playwright-setup.md)
- Use env vars for base URL and credentials — never hard-code production secrets

### 6. Selector priority

Align with [selectors-and-pom.md](selectors-and-pom.md):

1. `getByRole()`
2. `getByLabel()`
3. `getByTestId()`
4. Visible text (exact when possible)

Avoid brittle CSS chains and XPath position indexes.

### 7. Screenshots for debugging

- Capture screenshots on assertion failure (`screenshot: 'only-on-failure'` in config)
- Save repro screenshots when reporting bugs to **magento-module** or **magento-admin-ui**

### 8. Magento and Adobe Commerce flows

| Flow | Reference |
|---|---|
| Login | [storefront-flows.md](storefront-flows.md) |
| Registration | [storefront-flows.md](storefront-flows.md) |
| Product search | [storefront-flows.md](storefront-flows.md) |
| Add to cart | [storefront-flows.md](storefront-flows.md) |
| Checkout | [storefront-flows.md](storefront-flows.md) |
| Company accounts | [b2b-flows.md](b2b-flows.md) |
| RFQ / negotiable quotes | [b2b-flows.md](b2b-flows.md) |
| Admin validation | [admin-browser-tests.md](admin-browser-tests.md) |

CAPTCHA and 2FA must be **disabled** in dev/staging test environments.

## Example prompts

**Explore with Playwright MCP:**

```
Use Playwright MCP to smoke-test customer login on https://magento.test.
Screenshot failures. Then generate a Playwright spec from the steps.
```

**E2E automation suite:**

```
Build Playwright E2E tests for guest checkout through shipping.
Use Playwright MCP to explore first, then write tests/storefront/checkout.spec.ts
with getByRole/getByLabel. playwright-mcp-optional.md + playwright-setup.md.
```

## Troubleshooting

| Problem | Fix |
|---|---|
| MCP not listed | Add `.cursor/mcp.json`; restart Cursor |
| Browser not found | `npx playwright install chromium` |
| Two browser MCPs conflict | Use **either** Playwright MCP **or** Cursor browser per task |
| Login blocked | Disable CAPTCHA; verify test credentials |

See [browser-troubleshooting.md](browser-troubleshooting.md).

## Docs

- [Playwright MCP](https://github.com/microsoft/playwright-mcp)
- [Getting started with MCP](https://playwright.dev/docs/getting-started-mcp)
