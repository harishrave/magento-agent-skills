# Quick Start (RaveDigital)

Get Magento agent skills running in under five minutes.

## 1. Install all skills

From your **Magento project root**:

```bash
git clone https://github.com/harishrave/magento-agent-skills.git

cd /var/www/html/mage-os   # your Magento root

../magento-agent-skills/install.sh --agents cursor
```

Or one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/harishrave/magento-agent-skills/main/install.sh | sh -s cursor
```

Confirm all five skills exist:

```
.agents/skills/magento-module/SKILL.md
.agents/skills/magento-admin-ui/SKILL.md
.agents/skills/magento-testing/SKILL.md
.agents/skills/magento-audit/SKILL.md
.agents/skills/magento-browser-testing/SKILL.md
```

**Update later:** `git pull` in the cloned skills repo (symlink installs pick up changes instantly).

## 2. Open the Magento codebase in Cursor

Skills apply to the project you have open — point Cursor at your Mage-OS / Adobe Commerce install.

## 3. Start a new Agent chat

Use a **new chat** after installing or updating skills.

## 4. Try a prompt

Copy fuller templates from [example-prompts.md](example-prompts.md). Quick starters:

**Module (magento-module):**

> We need a store locator module. Create RaveDigital_StoreLocator in app/code per module-scaffold.md. Done when setup:upgrade and setup:di:compile pass.

**Admin UI (magento-admin-ui):**

> Add a "Visible in locator" column to product_listing via merge XML — select filter, no core edits. extend-core-grids.md.

**PHPUnit (magento-testing):**

> Unit test StoreHours::getOpenHours() with mocked ScopeConfig. Run phpunit. unit-test-generation.md.

**Browser (magento-browser-testing):**

> Smoke-test storefront with Cursor browser: homepage + customer login. Screenshot failures. cursor-browser.md.

No extra MCP setup — Cursor browser is built in. See [install.md](install.md#cursor-browser-testing).

## 5. Team rollout

| Approach | Command |
|---|---|
| Clone + symlink (recommended) | `./magento-agent-skills/install.sh cursor` |
| One-liner | `curl …/install.sh \| sh -s cursor` |
| Commit symlinks in Magento repo | Zero setup for new clones |

See [install.md](install.md).

## More

- [example-prompts.md](example-prompts.md) — prompt library
- [skills-map.md](skills-map.md) — which skill when
- [testing-skills.md](testing-skills.md) — verify skills work
- [contributing.md](contributing.md) — improving skills
