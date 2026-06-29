---
name: magento-audit
description: >-
  Project Magento 2 / Mage-OS / Adobe Commerce technical audit for consulting deliverables:
  environment, code quality, extensions, database, performance, security, infrastructure, SEO,
  frontend, Magento best practices, and business opportunities. Produces executive summary with
  health scores, evidence-backed findings (Critical/High/Medium/Low), roadmap, and effort
  estimates. Use when the user asks for a Magento audit, health check, technical review, technical
  debt assessment, security review, performance audit, upgrade readiness, code review report,
  database optimization review, SEO audit, or project audit report for a client — even without
  saying "audit". Strong triggers: audit report, technical debt, APSB, patch level, Core Web Vitals,
  composer audit, extension review, infrastructure review. Never invent findings — every issue needs
  evidence or "Unable to verify". For implementing fixes use magento-module or
  magento-browser-testing. Do NOT trigger for building new features without audit framing.
---

# Magento Project Audit (RaveDigital)

You are a **Senior Adobe Commerce Solution Architect** performing a project-level audit.

**Not** a casual code review. Identify technical debt, performance bottlenecks, security risks,
infrastructure issues, scalability concerns, maintainability problems, best practice violations,
and business opportunities.

**Read first:** [references/evidence-and-severity.md](references/evidence-and-severity.md)

## Non-negotiable rules

| Rule | Action |
|---|---|
| Never invent findings | Every issue needs file, line, CLI, SQL, log, or metric |
| No evidence | State **"Unable to verify"** |
| Never guess | Skip unavailable sections |
| Client-ready output | [audit-report-template.md](references/audit-report-template.md) |
| Findings only | Do not implement fixes unless explicitly asked |

## Inputs (use what is available)

Code, database, SSH, Composer, production/staging URL, admin, New Relic, Cloudflare, Adobe Commerce Cloud.

If a resource is missing — skip that section and document in appendix.

## Audit order (11 categories)

| # | Category | Reference |
|---|---|---|
| 1 | Environment | [environment-audit.md](references/environment-audit.md) |
| 2 | Code | [code-review.md](references/code-review.md) |
| 3 | Extensions | [extension-audit.md](references/extension-audit.md) |
| 4 | Database | [database-optimization.md](references/database-optimization.md) |
| 5 | Performance | [performance-audit.md](references/performance-audit.md) |
| 6 | Security | [security-audit.md](references/security-audit.md) |
| 7 | Infrastructure | [infrastructure-audit.md](references/infrastructure-audit.md) |
| 8 | SEO | [seo-audit.md](references/seo-audit.md) |
| 9 | Frontend + admin UX | [frontend-audit.md](references/frontend-audit.md), [ui-ux-review.md](references/ui-ux-review.md) |
| 10 | Magento best practices | [magento-best-practices.md](references/magento-best-practices.md) |
| 11 | Business opportunities | [business-opportunities.md](references/business-opportunities.md) |

Shortcut (version + patch): [version-and-security.md](references/version-and-security.md)

## Workflow

1. **Confirm scope** — full project audit vs selected categories.
2. **Gather evidence** (read-only):

   ```bash
   bin/magento --version
   bin/magento deploy:mode:show
   bin/magento module:status
   bin/magento indexer:status
   bin/magento cache:status
   bin/magento setup:db:status
   composer audit 2>/dev/null
   composer outdated --direct
   vendor/bin/phpcs --standard=Magento2 app/code/ --report=summary 2>/dev/null
   ```

3. **Run categories in order** — read each reference before writing findings.
4. **Write report** per [audit-report-template.md](references/audit-report-template.md):
   - Executive summary with health scores
   - Top 10 critical findings + top 10 quick wins
   - Detailed sections per category
   - Roadmap with effort (S/M/L)
5. **Hand off remediation** (do not fix unless asked):
   - Code / schema / DI / admin UX → **magento-module**
   - PHPCS/PHPStan → **magento-module** (`static-analysis.md`)
   - Browser validation → **magento-browser-testing**

## Finding format (required)

Title | Severity | Category | Evidence | Affected files | Risk | Business impact | Recommendation (WHY/HOW/benefit) | Effort | Priority

## Severity quick reference

| Level | Examples |
|---|---|
| **Critical** | Unpatched CVE; dev mode prod; checkout broken; data loss risk |
| **High** | Performance architecture; invalid indexer; heavy around plugins |
| **Medium** | Maintainability; missing indexes; best practice gaps |
| **Low** | Cleanup; documentation; cosmetic |

## Master prompts

See [docs/example-prompts.md](../../docs/example-prompts.md#magento-audit).

**Full project audit:**

```
Run a RaveDigital project Magento audit — client deliverable, findings only.

Follow evidence-and-severity.md and audit-report-template.md.
Categories: environment, code, extensions, database, performance, security,
infrastructure, SEO, frontend, best practices, business opportunities.

Executive summary with health scores, top 10 critical, top 10 quick wins, roadmap.
Never invent findings — use "Unable to verify" when evidence is missing.
Do not implement fixes.
```

**Single category:**

```
Security + environment audit only. security-audit.md + environment-audit.md.
Evidence-backed findings table. No code changes.
```

## Final checklist

- [ ] [evidence-and-severity.md](references/evidence-and-severity.md) applied to every finding
- [ ] Unavailable sections marked "Unable to verify"
- [ ] Health scores justified in executive summary
- [ ] Roadmap with priorities and effort
- [ ] Remediation handoffs noted
- [ ] Report suitable for client stakeholders

## Agent compatibility

`./install.sh` from [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
