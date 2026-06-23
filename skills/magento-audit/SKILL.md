---
name: magento-audit
description: >-
  Magento 2 / Mage-OS / Adobe Commerce project audits for RaveDigital consulting deliverables:
  version and security patch assessment (e.g. upgrade 2.4.7-p7 to 2.4.8-p4), composer dependency
  review, database optimization (indexes, slow queries, bloat, archival), custom code review
  (deprecated APIs, ObjectManager, preferences, InstallSchema, di.xml conflicts), and UI/UX
  review with actionable suggestions for admin and storefront. Use when the user asks for a Magento
  audit, health check, technical review, upgrade assessment, security review, code optimization
  recommendations, database tuning suggestions, or UX improvement report for a client project —
  even if they do not say "audit" explicitly. Strong triggers: audit report, before/after upgrade,
  technical debt review, deprecated code, patch level, performance baseline, admin usability,
  checkout UX. For implementing fixes after the audit use magento-module, magento-admin-ui, or
  magento-testing. Do NOT trigger for writing new features from scratch without an audit/review
  framing, or for non-Magento platforms.
---

# Magento Project Audit (RaveDigital)

Structured technical and UX audits for client Magento projects. Output is a **prioritized
findings report with recommendations** — not implementation unless the user explicitly asks to fix issues.

## Audit pillars

| Pillar | Reference | Delivers |
|---|---|---|
| Version & security | [version-and-security.md](references/version-and-security.md) | Current vs target version, patch gap, EOL risk |
| Database | [database-optimization.md](references/database-optimization.md) | Index, query, bloat, archival recommendations |
| Code quality | [code-review.md](references/code-review.md) | Deprecated patterns, DI, module conflicts, standards |
| UI/UX | [ui-ux-review.md](references/ui-ux-review.md) | Admin and storefront usability findings |
| Report format | [audit-report-template.md](references/audit-report-template.md) | Client-ready deliverable structure |

## Workflow

1. **Confirm scope** — full audit vs single pillar (version only, code only, etc.).
2. **Gather evidence** from the project (read-only unless user authorizes changes):

   ```bash
   bin/magento --version
   composer show magento/product-community-edition 2>/dev/null || composer show mage-os/product-community-edition
   composer outdated --direct
   bin/magento setup:db:status
   bin/magento indexer:status
   bin/magento module:status
   vendor/bin/phpcs --standard=Magento2 app/code/ 2>/dev/null | head -50
   ```

3. **Read the matching reference** for each pillar before writing findings.
4. **Produce the report** using [audit-report-template.md](references/audit-report-template.md):
   - Severity: **Critical** / **High** / **Medium** / **Low** / **Info**
   - Finding → Impact → Recommendation → Effort (S/M/L)
5. **Do not implement fixes** unless asked — hand off remediation:
   - Code/schema/DI fixes → **magento-module**
   - Admin grid/form UX → **magento-admin-ui**
   - Test gaps → **magento-testing**

## RaveDigital audit standards

- **Evidence-based** — cite file paths, versions, or command output; no generic Magento blog advice.
- **Prioritized** — security and upgrade gaps before cosmetic UX.
- **Actionable** — every finding has a concrete next step (not "consider improving performance").
- **Honest scope** — state what was not reviewed (load test, penetration test, full DB EXPLAIN on production).
- **No fear-mongering** — distinguish must-fix (unpatched CVE) from should-fix (deprecated helper).

## Version audit shortcut

When the user provides or you detect a version like `2.4.7-p7`:

1. Identify latest secure patch in the same minor line and recommended target (e.g. `2.4.8-p4`).
2. List composer packages lagging behind core.
3. Note custom modules that may block upgrade (PHP version, deprecated APIs).

See [version-and-security.md](references/version-and-security.md).

## Code review shortcut

Scan `app/code/` and `app/design/` for:

- `ObjectManager::getInstance()` in module code
- `InstallSchema` / `UpgradeSchema` (should be `db_schema.xml`)
- Class preferences where plugins suffice
- Unescaped `.phtml` output
- Core overrides in `vendor/` (never acceptable)

See [code-review.md](references/code-review.md).

## Database shortcut

Review without destructive changes:

- `SHOW TABLE STATUS` / size outliers (`report_*`, `session`, `log_*`)
- Missing indexes on custom tables (`db_schema.xml`)
- Indexer invalid state, backlog
- Async/batch vs synchronous reindex on production

See [database-optimization.md](references/database-optimization.md).

## UI/UX shortcut

Split **admin** vs **storefront**:

- Admin: grid usability, ACL clarity, config discoverability, error messages
- Storefront: checkout steps, mobile layout, LCP/CWV signals if Lighthouse data provided, accessibility basics

See [ui-ux-review.md](references/ui-ux-review.md).

## Master prompts (copy-paste)

Full library: [docs/example-prompts.md](../../docs/example-prompts.md#magento-audit).

**Full client audit:**

```
Run a RaveDigital Magento project audit — client deliverable, findings only.

Pillars: version/security, database optimization, app/code review, admin + storefront UX.
Format: audit-report-template.md. Severity: Critical / High / Medium / Low.
Do not implement fixes in this pass.
```

**Upgrade readiness:**

```
Upgrade assessment: bin/magento --version is 2.4.7-p7.
Recommend target patch, security gaps, and blockers before 2.4.8.x.
version-and-security.md. Prioritized findings table.
```

**Pre-release code gate:**

```
Pre-release code review of app/code: ObjectManager, InstallSchema, preferences,
unescaped .phtml, risky plugins. Prioritized table per code-review.md — no code changes yet.
```

**Phased audit → fix:**

```
Phase 1: Full magento-audit (audit-report-template.md).
Phase 2: Implement top 3 Critical/High code findings only (hand off to magento-module).
Do not start Phase 2 until I approve the audit summary.
```

## Final checklist

- [ ] All requested pillars covered or explicitly excluded
- [ ] Version numbers verified from `composer.lock` or `bin/magento --version`
- [ ] Findings prioritized by severity
- [ ] Remediation handoffs noted (which skill for fixes)
- [ ] Report suitable to share with client stakeholders

## Mage-OS notes

For Mage-OS projects, compare against [Mage-OS release notes](https://github.com/mage-os/mageos-release) and
`mage-os/product-community-edition` constraints — not only Adobe Commerce versioning.

## Agent compatibility

Install with `./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
See [docs/install.md](../../docs/install.md).
