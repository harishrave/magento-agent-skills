# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- **`install.sh` one-liner** — remote install copies skills instead of broken symlinks to deleted temp dirs

### Changed

- **Terminology** — "Enterprise audit" renamed to "project audit" across docs and magento-audit skill (Magento product package names unchanged)
- **docs/example-prompts.md** — richer prompts with context, done criteria, and multi-skill workflows
- **SKILL.md master prompts** — magento-module, magento-admin-ui, magento-audit aligned with example-prompts library
- **magento-browser-testing** — Cursor browser default; optional Playwright MCP when user asks for Playwright or generated specs
- **Removed magento-testing** — `static-analysis.md` moved to **magento-module**; PHPUnit workflows removed (4 skills total)
- **Removed magento-admin-ui** — admin ui_component references merged into **magento-module** (3 skills total)
- **magento-audit** — enterprise audit framework: 11 categories, evidence rules, health scores, executive summary template

## [1.0.0] - 2026-06-18

Initial release — RaveDigital Magento agent skills for Magento 2, Mage-OS, and Adobe Commerce.

### Added

- **magento-module** — module scaffolding, plugins, declarative schema, DI, APIs, CLI/cron, troubleshooting
- **magento-admin-ui** — admin grids/forms, ui_component, data providers, extending core listings
- **magento-testing** — PHPUnit unit/integration tests, module-scoped runs, unit test generation,
  PHPCS (Magento2) and PHPStan on `app/code`, version upgrade regression testing
  ([ProcessEight gist](https://gist.github.com/ProcessEight/fb7141d120ce05fa837ff4457ca6a747))
- **magento-audit** — project audits: version/security, database optimization, code review, UI/UX reports
- **`install.sh`** — installs all skills at once; symlink default, `--copy`, `--agents` flags
- **`magento-skills.json`** — skill manifest
- **`AGENTS.md`** — agent entry point with skill routing and RaveDigital defaults
- **docs/** — quick-start, install, example-prompts, skills-map, testing-skills, contributing
- **NOTICE.md** — RaveDigital copyright (proprietary; no separate LICENSE file)
- **Example module** — `RaveDigital_StoreLocator` used consistently across skills and docs

[Unreleased]: https://github.com/harishrave/magento-agent-skills/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/harishrave/magento-agent-skills/releases/tag/v1.0.0
