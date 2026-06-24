# Browser Test Troubleshooting

## Cursor browser (default)

| Symptom | Fix |
|---|---|
| Browser tools not available | Enable browser in Cursor; start **new Agent chat** |
| Wrong site / no Magento context | Open **Magento project root** in Cursor (not skills repo) |
| Snapshot empty or stale | Re-navigate; `browser_lock` before long interactions |
| Login blocked | Disable CAPTCHA; verify admin URL and credentials |
| Agent writes spec files | User wants CI — [playwright-setup.md](playwright-setup.md); else use Cursor browser |
| Element not in snapshot | Add `data-testid` in module; try label/role from fresh snapshot |

## Local Playwright (CI only)

| Symptom | Fix |
|---|---|
| `playwright: not found` | [playwright-setup.md](playwright-setup.md) |
| Browser binaries missing | `npx playwright install chromium` |

## Flaky interactions (both)

| Symptom | Fix |
|---|---|
| Race on AJAX grid | Wait for loading mask hidden in snapshot before asserting rows |
| Stale session (admin) | Re-login; clear cookies for test env |
| Wrong base URL | `bin/magento config:show web/unsecure/base_url` |

## Debug local specs

```bash
npx playwright test tests/checkout.spec.ts --debug
npx playwright show-trace test-results/.../trace.zip
```

## PHPUnit vs browser

| Layer | Tool | Skill |
|---|---|---|
| PHP / static analysis | PHPCS/PHPStan | **magento-module** |
| Browser (interactive, Cursor) | Cursor browser | **magento-browser-testing** |
| Browser (CI specs) | Local Playwright | **magento-browser-testing** → playwright-setup.md |
| Adobe MFTF | MFTF | Only if user explicitly requests |

## Optional Playwright MCP

When the user **explicitly asks for Playwright** or generated `*.spec.ts` files — see [playwright-mcp-optional.md](playwright-mcp-optional.md).  
Cursor-only teams should **not** add Playwright MCP for general smoke/UI validation.
