# RaveDigital Magento — Agent Guidelines

**Guidelines** (this file) load upfront — team defaults and skill routing.  
**Skills** load on-demand — detailed workflows in `SKILL.md` + `references/`.

## Install all skills

```bash
git clone https://github.com/harishrave/magento-agent-skills.git
./magento-agent-skills/install.sh cursor
```

Installs: **magento-module**, **magento-admin-ui**, **magento-audit**, **magento-browser-testing**.

See [docs/install.md](docs/install.md).

## Which skill to use

| You are working on… | Skill |
|---|---|
| Custom modules, plugins, observers, schema, DI, APIs, CLI/cron, PHPCS, PHPStan | **magento-module** |
| Admin grids, forms, ui_component, data providers | **magento-admin-ui** |
| Cursor browser tests, E2E, checkout/login UI validation | **magento-browser-testing** |
| **Project audit**, version upgrade, DB optimization, code review, UI/UX report | **magento-audit** |

## RaveDigital defaults (always)

- Constructor injection only — no `ObjectManager::getInstance()` in module code
- `db_schema.xml` for DDL — no InstallSchema/UpgradeSchema
- Plugins over preferences unless no alternative exists
- View models for template logic — avoid custom Block classes
- Escape all `.phtml` output
- Run `bin/magento setup:di:compile` before declaring module work done

## Example prompts

See [docs/example-prompts.md](docs/example-prompts.md) and [docs/testing-skills.md](docs/testing-skills.md).
