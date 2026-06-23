# Magento Agent Skills

**RaveDigital** agent skills for **Magento 2**, **Mage-OS**, and **Adobe Commerce** development.
Compatible with any AI coding agent that supports the open [Agent Skills](https://github.com/vercel-labs/skills) format — **Cursor**, Claude Code, Codex, Windsurf, and others.

These skills encode RaveDigital's Magento engineering standards: declarative schema, constructor
injection, ui_component patterns, and compile-safe module structure. The goal is generated code that
passes `bin/magento setup:di:compile` and `phpcs --standard=Magento2` without rework.

> **Repository:** [github.com/harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills)

## Skills included

| Skill | Purpose |
|---|---|
| [magento-module](skills/magento-module/) | Module scaffolding, plugins, schema, DI, APIs, CLI/cron, debugging |
| [magento-admin-ui](skills/magento-admin-ui/) | Admin grids/forms, ui_component, data providers, extending core listings |
| [magento-testing](skills/magento-testing/) | PHPUnit tests, PHPCS/PHPStan, upgrade regression, module-scoped test runs |
| [magento-browser-testing](skills/magento-browser-testing/) | Playwright MCP in Cursor: login, checkout, admin UI (local specs optional for CI) |
| [magento-audit](skills/magento-audit/) | Project audits: version/security, database, code review, UI/UX reports |

## Quick install

Install **all skills** in one command:

```bash
git clone https://github.com/harishrave/magento-agent-skills.git

# From your Magento project root
./magento-agent-skills/install.sh cursor
```

One-liner (no clone — downloads and **copies** skills into your project):

```bash
curl -fsSL https://raw.githubusercontent.com/harishrave/magento-agent-skills/main/install.sh | sh -s cursor
```

For symlink installs (live updates via `git pull`), clone the repo first — see [docs/install.md](docs/install.md).

**Alternative** (requires Node.js): `npx skills add harishrave/magento-agent-skills -a cursor -y`

See [docs/quick-start.md](docs/quick-start.md), [docs/example-prompts.md](docs/example-prompts.md), and [docs/install.md](docs/install.md).

## Usage

Skills load automatically when your prompts match their descriptions. Examples:

- *"Ship RaveDigital_StoreLocator: schema, admin grid, unit tests — compile and phpunit must pass"*
- *"Empty admin grid — dataProvider ravedigital_store_location_listing_data_source. Diagnose and fix"*
- *"Post-upgrade gate: setup:di:compile + PHPCS + PHPStan on all app/code modules"*
- *"Playwright MCP: validate guest checkout through shipping — report pass/fail with screenshots"*
- *"Client audit: version, database, app/code review, UX — audit-report-template.md, findings only"*

Natural language is enough — no agent-specific slash commands required.

## Repository structure

```
magento-agent-skills/
├── install.sh                     # Install all skills (recommended)
├── magento-skills.json            # Skill manifest
├── skills/
│   ├── magento-module/references/     # Module development guides
│   ├── magento-admin-ui/references/   # Admin ui_component guides
│   ├── magento-testing/references/    # PHPUnit unit & integration tests
│   ├── magento-browser-testing/references/  # Playwright E2E & UI validation
│   └── magento-audit/references/      # Project audit pillars & report template
├── docs/
│   ├── quick-start.md       # 5-minute onboarding
│   ├── example-prompts.md   # Copy-paste prompts per skill
│   ├── skills-map.md        # Which skill when
│   ├── testing-skills.md    # Verify skills in a Magento project
│   ├── install.md
│   └── contributing.md
├── AGENTS.md                # Agent entry point (Cursor / compatible tools)
├── README.md
├── CHANGELOG.md
└── NOTICE.md
```

### Reference file index

| Skill | Reference | Topic |
|---|---|---|
| **magento-module** | `module-scaffold.md` | New module boilerplate (prompt workflow) |
| | `plugins-and-observers.md` | Plugins, observers, preferences |
| | `database-and-schema.md` | `db_schema.xml`, data patches |
| | `dependency-injection.md` | DI, factories, proxies, virtual types |
| | `admin-configuration.md` | system.xml, ACL, menus |
| | `storefront-layout.md` | Layout XML, view models, templates |
| | `web-apis.md` | REST, GraphQL, service contracts |
| | `background-jobs.md` | CLI, cron, message queues |
| | `module-troubleshooting.md` | Compile, layout, plugin debug playbooks |
| | `review-checklist.md` | Pre-merge checklist |
| | `composer-packaging.md` | composer.json, versioning, Mage-OS deps |
| **magento-testing** | `unit-test-generation.md` | Write unit tests for a specific module |
| | `module-testing.md` | Run all tests for Vendor_Module |
| | `version-upgrade-testing.md` | Regression test after patch upgrade |
| | `static-analysis.md` | PHPCS + PHPStan on app/code module |
| | `unit-testing.md` | Mocked PHPUnit unit tests |
| | `integration-testing.md` | DB isolation, fixtures, Bootstrap |
| | `test-troubleshooting.md` | Common PHPUnit/integration failures |
| | `test-checklist.md` | Pre-merge test checklist |
| **magento-browser-testing** | `playwright-mcp.md` | Playwright MCP + Cursor (default) |
| | `playwright-setup.md` | Optional local Playwright for CI |
| | `selectors-and-pom.md` | getByRole, page objects, assertions |
| | `storefront-flows.md` | Login, search, cart, checkout |
| | `b2b-flows.md` | Company, quotes, B2B approval |
| | `admin-browser-tests.md` | Admin grid/form validation |
| | `browser-troubleshooting.md` | Flaky tests, traces, debug |
| | `browser-test-checklist.md` | Pre-merge browser test checklist |
| **magento-admin-ui** | `admin-grid.md` | Custom admin listings |
| | `admin-form.md` | Entity edit forms |
| | `grid-data-providers.md` | CollectionFactory wiring |
| | `extend-core-grids.md` | Extend product_listing, etc. |
| | `ui-component-structure.md` | XML anatomy and naming |
| | `admin-ui-troubleshooting.md` | Empty grids, AJAX errors |
| **magento-audit** | `version-and-security.md` | Patch level, upgrade path, security |
| | `database-optimization.md` | Indexes, bloat, indexer health |
| | `code-review.md` | Deprecated code, standards, red flags |
| | `ui-ux-review.md` | Admin and storefront UX findings |
| | `audit-report-template.md` | Client deliverable structure |

## Team rollout (RaveDigital)

1. Clone or install from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
2. Each developer runs `./magento-agent-skills/install.sh cursor` from the Magento root, **or**
3. Commit symlinks in `.cursor/skills/` for zero-setup onboarding.

Pin a release tag in internal docs:

```bash
npx skills add harishrave/magento-agent-skills@v1.0.0 -a cursor -y
```

## Requirements

- Magento 2.4.x or Mage-OS codebase (for verification commands)
- PHP 8.1+ for generated code
- Git (recommended for symlink install)
- Node.js (optional — only for `npx skills` alternative)

## Optional: pair with MCP

Skills carry **procedures and conventions**. For live merged config and store data, pair with:

- [elgentos/magento2-dev-mcp](https://github.com/elgentos/magento2-dev-mcp)
- [mage-os-lab/magento2-lsp](https://github.com/mage-os-lab/magento2-lsp)

## Contributing

See [docs/contributing.md](docs/contributing.md). Skill changes should be reviewed like library code —
they affect what every developer's agent generates.

## Copyright

Copyright (c) 2026 RaveDigital. All rights reserved. See [NOTICE.md](NOTICE.md).
