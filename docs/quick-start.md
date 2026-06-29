# Quick Start (RaveDigital)

## 1. Install all skills

```bash
git clone https://github.com/harishrave/magento-agent-skills.git
cd /var/www/html/mage-os
../magento-agent-skills/install.sh --agents cursor
```

Confirm **three** skills:

```
.agents/skills/magento-module/SKILL.md
.agents/skills/magento-audit/SKILL.md
.agents/skills/magento-browser-testing/SKILL.md
```

## 2. Open Magento project in Cursor — new Agent chat

## 3. Try a prompt

**Module + admin grid:**

> Create RaveDigital_StoreLocator with admin location grid per admin-grid.md. Done when compile passes and grid loads rows.

**Browser:**

> Smoke-test storefront with Cursor browser. cursor-browser.md.

**Audit:**

> Project audit per audit-report-template.md. Findings only.

See [example-prompts.md](example-prompts.md) and [install.md](install.md).
