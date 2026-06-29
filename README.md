# Magento Agent Skills

Pre-configured AI skills that guide your agent to work with Magento 2, Mage-OS, and Adobe Commerce. Use them in Cursor, Claude Code, Codex, Windsurf, and similar tools.

Stop re-explaining Magento conventions in every chat. Install once; your agent follows the same patterns your senior developers would — `db_schema.xml`, constructor injection, ui_component grids, compile gates, and evidence-backed audits.

> **Repository:** [github.com/harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills)

## Features

- **Module development** — scaffolding, plugins, observers, `db_schema.xml`, DI, APIs, storefront layout, cron/CLI
- **Admin UI** — ui_component grids and forms, data providers, extend core listings, empty-grid troubleshooting
- **Quality gates** — PHPCS (Magento2), PHPStan on `app/code`
- **Browser testing** — Cursor built-in browser for login, checkout, and admin smoke tests (no extra MCP setup)
- **Playwright (optional)** — MCP for generated specs; local `@playwright/test` for CI pipelines
- **Project audits** — 11 categories, evidence rules, health scores, roadmap-ready client reports
- **Ready-made prompts** — [example-prompts.md](docs/example-prompts.md) with context and done criteria
- **Agent-agnostic** — Cursor, Claude Code, Codex, Windsurf; installs to `.cursor/skills/` or `.agents/skills/`

No Composer package required — point skills at your existing Magento project.

## Skills included

| Skill | Purpose |
|---|---|
| [magento-module](skills/magento-module/) | Module scaffolding, plugins, schema, DI, APIs, admin grids/forms (ui_component), PHPCS, PHPStan |
| [magento-browser-testing](skills/magento-browser-testing/) | **Cursor browser** for interactive UI/E2E smoke tests; **optional Playwright** (MCP + generated specs, local `@playwright/test` for CI) — login, checkout, admin, B2B |
| [magento-audit](skills/magento-audit/) | Project audit: environment, code, extensions, database, performance, security, SEO, roadmap |

## Quick install

From your **Magento project root**:

```bash
git clone https://github.com/harishrave/magento-agent-skills.git
./magento-agent-skills/install.sh cursor
```

One-liner (no clone — copies skills into your project):

```bash
curl -fsSL https://raw.githubusercontent.com/harishrave/magento-agent-skills/main/install.sh | sh -s cursor
```

Symlink installs (live updates via `git pull`) — see [docs/install.md](docs/install.md).

**Alternative:** `npx skills add harishrave/magento-agent-skills -a cursor -y`

**Next:** [quick-start.md](docs/quick-start.md) · [example-prompts.md](docs/example-prompts.md) · [skills-map.md](docs/skills-map.md)

## Example prompts

Skills route automatically from natural language:

| You say… | Skill |
|---|---|
| *"Create RaveDigital_StoreLocator — schema, admin grid, compile must pass"* | **magento-module** |
| *"Empty admin grid — dataProvider ravedigital_store_location_listing_data_source"* | **magento-module** |
| *"PHPCS + PHPStan on app/code/RaveDigital/StoreLocator"* | **magento-module** |
| *"Smoke-test guest checkout with Cursor browser — screenshots on failure"* | **magento-browser-testing** |
| *"Generate Playwright specs for customer login — getByRole only"* | **magento-browser-testing** |
| *"Project audit with health scores — findings only, evidence required"* | **magento-audit** |

## Repository structure

```
magento-agent-skills/
├── install.sh
├── magento-skills.json
├── skills/
│   ├── magento-module/references/          # Module + admin UI + static analysis
│   ├── magento-browser-testing/references/ # Cursor browser + Playwright (optional)
│   └── magento-audit/references/           # Project audit playbooks
├── docs/
│   ├── quick-start.md
│   ├── example-prompts.md
│   ├── skills-map.md
│   ├── testing-skills.md
│   └── install.md
└── AGENTS.md
```

### Reference highlights

<details>
<summary><strong>magento-module</strong> — 18 references</summary>

`module-scaffold.md` · `plugins-and-observers.md` · `database-and-schema.md` · `admin-grid.md` · `admin-form.md` · `grid-data-providers.md` · `extend-core-grids.md` · `static-analysis.md` · `module-troubleshooting.md` · …

</details>

<details>
<summary><strong>magento-browser-testing</strong> — Cursor + Playwright</summary>

| Reference | Use |
|---|---|
| `cursor-browser.md` | Default — interactive smoke & E2E in Cursor (no npm) |
| `playwright-mcp-optional.md` | Playwright MCP when user asks for Playwright / generated specs |
| `playwright-setup.md` | Local `@playwright/test` for CI pipelines |
| `storefront-flows.md` | Login, cart, checkout |
| `admin-browser-tests.md` | Admin grid validation |

</details>

<details>
<summary><strong>magento-audit</strong> — 11 audit categories</summary>

`evidence-and-severity.md` · `audit-report-template.md` · `environment-audit.md` · `code-review.md` · `security-audit.md` · `performance-audit.md` · `database-optimization.md` · `seo-audit.md` · …

</details>

Full index: see previous releases or browse `skills/*/references/`.

## Requirements

- Magento 2.4.x or Mage-OS codebase (`bin/magento`)
- PHP 8.1+
- Git (recommended for symlink install)
- Node.js (optional — `npx skills` or local Playwright CI only)

## Contributing

See [docs/contributing.md](docs/contributing.md). Skill changes are reviewed like library code — they shape what every developer's agent generates.

## Copyright

Copyright (c) 2026 RaveDigital. All rights reserved. See [NOTICE.md](NOTICE.md).
