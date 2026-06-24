# Verify Agent Skills

How to verify RaveDigital Magento agent skills work in Cursor. Use `/var/www/html/mage-os` (or your Magento 2.4 project) as the test target.

## Prerequisites

| Requirement | Check |
|---|---|
| Magento/Mage-OS project with `bin/magento` | `bin/magento --version` |
| Skills installed | `.agents/skills/magento-module/SKILL.md` exists |
| Cursor opens the **Magento project** (not this skills repo) | Project root = `mage-os/` |
| New Agent chat after install/update | Fresh session picks up skills |

```bash
cd /var/www/html/mage-os
../magento-agent-skills/install.sh --agents cursor
```

---

## Smoke tests

### A — Skill routing (module)

**Prompt:**

```
Which RaveDigital skill applies to adding a custom plugin on QuoteRepository?
List the skill and reference files. Do not write code yet.
```

**Pass if:** cites **magento-module** + `plugins-and-observers.md`.

### B — Static analysis routing

**Prompt:**

```
Run PHPCS and PHPStan on RaveDigital_StoreLocator. Which skill and reference apply?
```

**Pass if:** cites **magento-module** + `static-analysis.md` (not a removed testing skill).

### C — Admin UI routing

**Prompt:**

```
Empty admin grid — dataProvider ravedigital_store_location_listing_data_source. Which skill?
```

**Pass if:** cites **magento-admin-ui** + grid troubleshooting references.

### D — Browser scope boundary

**Prompt:**

```
Create a Playwright test for customer login.
```

**Pass if:** routes to **magento-browser-testing**, not PHPUnit.

### E — Audit routing

**Prompt:**

```
Client technical audit — version, database, app/code review. Findings only.
```

**Pass if:** cites **magento-audit** + `audit-report-template.md`.

---

## Quick checklist

```
[ ] Four skills installed (.agents/skills/magento-module/, admin-ui, audit, browser-testing)
[ ] Test A: module routing
[ ] Test B: static-analysis routing
[ ] Test C: admin-ui routing
[ ] Test D: browser boundary
[ ] Test E: audit routing
```

See [example-prompts.md](example-prompts.md) for copy-paste prompts per skill.
