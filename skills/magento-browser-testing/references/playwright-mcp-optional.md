# Playwright MCP (optional)

**Not required for Cursor-only teams.** Cursor's built-in browser is the RaveDigital default — see [cursor-browser.md](cursor-browser.md).

Use **Microsoft Playwright MCP** (`@playwright/mcp`) only when:

- Developers use **non-Cursor** MCP clients (Claude Desktop, Windsurf, etc.)
- You want a **shared MCP browser server** across multiple tools
- Cursor browser tools are unavailable in your environment

## Setup (optional)

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

Restart Cursor after adding config.

Docs: [Playwright MCP](https://github.com/microsoft/playwright-mcp) | [getting started](https://playwright.dev/docs/getting-started-mcp)

## Do not duplicate

If **Cursor browser** already works, **do not** add Playwright MCP — two browser MCP servers add confusion with little benefit.

## CI regression

Playwright MCP does **not** replace CI. For `npx playwright test` in pipelines, use [playwright-setup.md](playwright-setup.md).
