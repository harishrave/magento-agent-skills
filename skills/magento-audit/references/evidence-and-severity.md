# Evidence and Severity Rules

**Mandatory for every magento-audit finding.** Read this before writing any audit report.

## Architect mindset

Think like a **Senior Adobe Commerce Solution Architect** preparing a paid enterprise deliverable.

Your job is **not** to review code for its own sake. Identify:

- Technical debt
- Performance bottlenecks
- Security risks
- Infrastructure issues
- Scalability concerns
- Maintainability problems
- Magento best practice violations
- Business improvement opportunities

## Evidence rules (never guess)

| Rule | Requirement |
|---|---|
| **Never invent findings** | Every issue must be backed by evidence |
| **No evidence** | State **"Unable to verify"** — do not fabricate |
| **Valid evidence** | File + line, CLI output, SQL result, log excerpt, screenshot ref, performance metric |
| **Unavailable input** | Skip that section; note in report appendix |

### Evidence types

```
File:     app/code/Vendor/Module/Plugin/ProductPlugin.php:42
CLI:      bin/magento --version → Magento 2.4.7-p7
SQL:      SHOW TABLE STATUS → report_viewed_product_index 12 GB
Metric:   Lighthouse LCP 4.2s on homepage (user-provided)
Log:      var/log/exception.log — SQLSTATE[HY000] …
```

## Severity definitions

| Level | When to use | Examples |
|---|---|---|
| **Critical** | Store may break; security; data loss; checkout blocked | Unpatched CVE; dev mode in prod; vendor/ edits |
| **High** | Performance; architecture; large technical debt | Around plugin loading collections on every PDP; invalid indexer |
| **Medium** | Maintainability; best practice; minor performance | Missing `@inheritdoc`; oversized log tables with rotation |
| **Low** | Cosmetic; cleanup; documentation | Inconsistent naming; missing docblocks |
| **Info** | Opportunity; observation | A/B test idea; feature not enabled |

## Required fields per finding

Every issue in the detailed audit **must** include:

| Field | Description |
|---|---|
| **Title** | Short, specific |
| **Severity** | Critical / High / Medium / Low / Info |
| **Category** | Environment, Code, Extension, Database, Performance, Security, Infrastructure, SEO, Frontend, Best Practices, Business |
| **Evidence** | File, line, command output, SQL, metric, or "Unable to verify" |
| **Affected files** | Paths or tables |
| **Risk** | Technical risk statement |
| **Business impact** | Plain language for stakeholders |
| **Recommendation** | **WHY** + **HOW** + **expected benefit** |
| **Estimated effort** | S / M / L or hours range |
| **Priority** | Immediate / High / Medium / Low |

### Example finding

> **Title:** Heavy around plugin on product repository  
> **Severity:** High  
> **Category:** Code  
> **Evidence:** `Vendor_Module/Plugin/ProductPlugin.php:28` — `aroundGetById()` calls `$collection->load()` twice  
> **Risk:** Extra DB queries on every product view  
> **Business impact:** Slower PDP and category pages; higher infrastructure cost at scale  
> **Recommendation:** Replace with `after` plugin; cache result per request — reduces queries per PDP load  
> **Effort:** M | **Priority:** High

## Recommendation rules

Every recommendation must include:

1. **WHY** — root cause or risk
2. **HOW** — concrete next step (command, pattern, file to change)
3. **Expected benefit** — performance, security, maintainability, revenue
4. **Priority** — when to schedule

## Out of scope (state explicitly)

- Penetration testing (unless engagement includes it)
- Load testing at scale (unless data provided)
- Full line-by-line `vendor/` review
- Legal / license audit of proprietary extensions
- Fabricating Lighthouse scores, New Relic data, or cloud metrics

## Handoff after audit

| Finding type | Skill |
|---|---|
| Code / schema / DI fixes | **magento-module** |
| Admin grid/form UX | **magento-module** (`admin-grid.md`, `admin-form.md`) |
| PHPCS/PHPStan remediation | **magento-module** (`static-analysis.md`) |
| Browser validation after fix | **magento-browser-testing** |
