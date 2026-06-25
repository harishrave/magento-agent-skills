# Cursor Browser Testing (RaveDigital default)

**Primary path** for Magento browser testing — uses **Cursor's built-in browser MCP**. No extra MCP server, no `npm init playwright`, no `.cursor/mcp.json` required for interactive tests.

## Prerequisites

| Requirement | Check |
|---|---|
| **Cursor** with browser automation enabled | Agent can use browser tools in chat |
| Magento project open as **workspace root** | `bin/magento` at project root |
| Storefront/admin reachable | e.g. `https://magento.test` |
| **magento-browser-testing** skill installed | `.agents/skills/magento-browser-testing/SKILL.md` |
| **New Agent chat** after skill install | Fresh session picks up skills |

No Playwright MCP install needed for Cursor-only teams.

## How it works

The agent uses Cursor browser tools to:

1. **Navigate** — open storefront or admin URL
2. **Snapshot** — read page structure (roles, labels, text — like `getByRole` / `getByLabel`)
3. **Interact** — click, type, fill forms, scroll
4. **Screenshot** — capture proof or failures
5. **Report** — pass/fail with steps to reproduce

Workflow: `browser_navigate` → `browser_lock` → interactions → `browser_unlock` when done.

## Agent workflow (skill behavior)

When the user asks to test in browser:

1. Confirm **base URL** (ask or `bin/magento config:show web/unsecure/base_url`)
2. **Navigate** to the target page
3. **Snapshot** before acting — pick elements by accessible name/label
4. Execute the flow (login, add to cart, open admin grid, etc.)
5. **Screenshot** on failure or when user wants evidence
6. Summarize findings — do **not** default to writing `*.spec.ts` unless user asks for **CI**

## Magento URLs

| Surface | Example |
|---|---|
| Storefront | `https://magento.test/` |
| Customer login | `/customer/account/login/` |
| Admin | `https://magento.test/admin` |
| Custom module | `/admin/ravedigital_storelocator/location/index` |

Never test against production without explicit approval.

## Credentials

Pass in the prompt or use team env (gitignored):

```
MAGENTO_ADMIN_USER / MAGENTO_ADMIN_PASSWORD
MAGENTO_CUSTOMER_EMAIL / MAGENTO_CUSTOMER_PASSWORD
```

Disable CAPTCHA and 2FA in dev/staging test environments.

## Selector mindset

Align with [selectors-and-pom.md](selectors-and-pom.md) — from snapshot, prefer:

| Prefer | Avoid |
|---|---|
| Button/link text from snapshot | Long CSS selectors |
| Form field labels | XPath position indexes |
| `data-testid` in custom modules | Theme-specific classes |

## Example prompts

**Smoke test:**

```
Use Cursor browser tools to smoke-test the storefront: homepage loads, then customer login page shows Sign In.
Screenshot any failure. Base URL: https://magento.test
```

**Guest checkout:**

```
Validate guest checkout through shipping using Cursor browser per storefront-flows.md.
Add a simple product, proceed to checkout, complete shipping. Report pass/fail with steps.
```

**Admin grid:**

```
Validate RaveDigital_StoreLocator admin location grid in Cursor browser — open index URL,
confirm column headers and grid finishes loading. admin-browser-tests.md
```

## Tips for reliable runs

- Start a **new Agent chat** if browser tools seem stale
- Prefer **clicking links** in the UI over guessing URLs when exploring
- Wait for page changes via **snapshot checks**, not arbitrary delays
- For admin: log in once per session; verify ACL allows the screen
- After deploy: `bin/magento cache:flush` if UI looks stale

## When to use something else

| Need | Tool |
|---|---|
| Test in browser while coding (Cursor) | **Cursor browser** (this doc) |
| CI pipeline on every PR | [playwright-setup.md](playwright-setup.md) |
| User asks for **Playwright** / generated specs | [playwright-mcp-optional.md](playwright-mcp-optional.md) |

## Troubleshooting

| Problem | Fix |
|---|---|
| Browser tools not available | Enable browser MCP in Cursor; new Agent chat |
| Wrong project context | Open **Magento** root in Cursor, not skills repo |
| Login blocked | CAPTCHA off; correct admin URL |
| Element not found | Fresh snapshot; add `data-testid` in module templates |

See [browser-troubleshooting.md](browser-troubleshooting.md).

## Handoffs

| Finding | Skill |
|---|---|
| PHP / module bug | **magento-module** |
| Grid / form XML | **magento-module** |
| Code quality / PHPCS | **magento-module** |
