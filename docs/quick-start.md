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

Confirm all four skills exist:

```
.agents/skills/magento-module/SKILL.md
.agents/skills/magento-admin-ui/SKILL.md
.agents/skills/magento-testing/SKILL.md
.agents/skills/magento-audit/SKILL.md
```

**Update later:** `git pull` in the cloned skills repo (symlink installs pick up changes instantly).

## 2. Open the Magento codebase in Cursor

Skills apply to the project you have open — point Cursor at your Mage-OS / Adobe Commerce install.

## 3. Start a new Agent chat

Use a **new chat** after installing or updating skills.

## 4. Try a prompt

**Module scaffold:**

> Create RaveDigital_StoreLocator in app/code following module-scaffold.md — registration.php, module.xml, composer.json with sequence on Magento_Store. Run setup:upgrade and setup:di:compile.

**Admin grid:**

> Add a "Visible in locator" yes/no column to the product admin grid using ui_component merge XML.

**Testing:**

> Add a unit test for `RaveDigital\StoreLocator\Model\StoreHours` covering disabled config and valid store code.

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
