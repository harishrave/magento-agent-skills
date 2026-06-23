# Playwright MCP + Cursor (RaveDigital default)

**Primary path** for Magento browser testing in Cursor — no `playwright.config.ts` or `tests/` folder required in the Magento repo.

Uses [Microsoft Playwright MCP](https://github.com/microsoft/playwright-mcp): the agent controls a real browser via MCP tools and accessibility snapshots (same selector mindset as `getByRole` / `getByLabel`).

## Prerequisites

| Requirement | Check |
|---|---|
| Node.js 18+ | `node --version` |
| Cursor with MCP | Settings → MCP |
| Magento running locally | `bin/magento --version`, storefront loads in browser |
| RaveDigital skills installed | `.agents/skills/magento-browser-testing/SKILL.md` |

Install browser binaries once per machine (if MCP reports missing browser):

```bash
npx playwright install chromium
```

## Cursor MCP setup

### Option 1 — Cursor Settings UI

1. **Cursor Settings** → **MCP** → **Add new MCP Server**
2. Type: **command**
3. Command: `npx -y @playwright/mcp@latest`

### Option 2 — Project config (team rollout)

Create or edit `.cursor/mcp.json` in the **Magento project root**:

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

Commit `.cursor/mcp.json` so teammates get the same server (Magento repo stays PHP-focused — only MCP config, no test suite).

### Option 3 — User-level config

`~/.cursor/mcp.json` — same JSON; applies to all projects on that machine.

## Verify MCP is working

1. Restart Cursor or reload MCP after config change
2. MCP panel shows **playwright** connected (green)
3. New Agent chat — ask:

```
Open https://magento.test in the browser and confirm the homepage title contains Magento.
```

Agent should use Playwright MCP tools (navigate, snapshot) — not ask you to run `npm init playwright`.

## Agent workflow (skill behavior)

When **Playwright MCP** is available:

1. **Navigate** to storefront or admin URL (from user or `web/unsecure/base_url`)
2. **Snapshot** page — read roles, labels, text (like `getByRole` / `getByLabel`)
3. **Interact** — click, type, select; prefer stable names from snapshot
4. **Screenshot** on failure or for visual proof
5. **Report** pass/fail and findings — optional: save repro steps for the team

Do **not** default to generating `*.spec.ts` files unless the user asks for a **CI regression suite** — see [playwright-setup.md](playwright-setup.md).

## Magento URLs

Ask the user or read from env — never assume production:

| Surface | Example |
|---|---|
| Storefront | `https://magento.test/` |
| Admin | `https://magento.test/admin` |
| Custom module | `https://magento.test/admin/ravedigital_storelocator/location/index` |

```bash
bin/magento config:show web/unsecure/base_url
```

## Test credentials

Use dev/staging only. Pass in the prompt or team `.env` (gitignored):

```
Admin: MAGENTO_ADMIN_USER / MAGENTO_ADMIN_PASSWORD
Customer: MAGENTO_CUSTOMER_EMAIL / MAGENTO_CUSTOMER_PASSWORD
```

CAPTCHA and 2FA must be **disabled in test environments**.

## Selector mindset (MCP)

Playwright MCP uses the **accessibility tree** — align with [selectors-and-pom.md](selectors-and-pom.md):

| Prefer | Avoid |
|---|---|
| Button/link names from snapshot | Long CSS chains |
| Form field labels | XPath position indexes |
| `data-testid` when you added them in modules | Class names that change per theme |

## Example agent prompts

**Smoke test:**

```
Use Playwright MCP to open the storefront homepage and confirm it loads.
Then open customer login and verify the Sign In form is visible.
```

**Checkout:**

```
Test guest checkout through shipping step using Playwright MCP.
Use snapshot to find fields by label. Screenshot if any step fails.
```

**Admin grid:**

```
Validate RaveDigital_StoreLocator admin grid: open the location index URL,
confirm column headers and that the grid finishes loading.
```

## Headless vs headed

Default MCP browser is often **headed** (visible). For CI-like runs on a server:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest", "--headless"]
    }
  }
}
```

Remote/display-less: run standalone server per [Playwright MCP docs](https://playwright.dev/docs/getting-started-mcp).

## When to add local Playwright instead

| Need | Tool |
|---|---|
| Test now in Cursor | **Playwright MCP** (this doc) |
| CI pipeline on every PR | [playwright-setup.md](playwright-setup.md) |
| Versioned regression suite in git | [playwright-setup.md](playwright-setup.md) |

## Troubleshooting

| Problem | Fix |
|---|---|
| MCP not listed | Add `.cursor/mcp.json`; restart Cursor |
| 0 tools / disconnected | Use `-y` in npx args; check Node 18+ |
| Browser not found | `npx playwright install chromium` |
| Wrong site | Confirm Magento project root open in Cursor |
| Login blocked | Disable CAPTCHA; check admin URL |

See [browser-troubleshooting.md](browser-troubleshooting.md).

## Pair with skills

| After MCP finds… | Skill |
|---|---|
| PHP / module bug | **magento-module** |
| Grid/form/XML issue | **magento-admin-ui** |
| Missing PHPUnit | **magento-testing** |
