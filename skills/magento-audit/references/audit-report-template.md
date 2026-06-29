# Project Audit Report Template

Client-ready structure for RaveDigital Magento project audits.  
**Every finding** must follow [evidence-and-severity.md](evidence-and-severity.md).

---

# Magento Project Audit — [Client Name]

**Project:** [store URL]  
**Audit date:** [YYYY-MM-DD]  
**Auditor:** RaveDigital  
**Edition:** [Open Source / Adobe Commerce / Mage-OS]  
**Scope:** [Full | Environment + Code | etc.]  
**Resources available:** [code / DB / SSH / staging URL / admin / APM — list or "code only"]

---

## Executive summary

### Health scores (1–10 or letter grade — justify each)

| Dimension | Score | Summary |
|---|---|---|
| Overall health | | |
| Performance | | |
| Security | | |
| Code quality | | |
| Infrastructure | | |
| SEO | | |
| Maintainability | | |

### Finding counts

| Severity | Count |
|---|---|
| Critical | |
| High | |
| Medium | |
| Low | |

### Top 10 critical findings

| # | Title | Category | Priority |
|---|---|---|---|
| 1 | | | |

### Top 10 quick wins

| # | Title | Effort | Expected benefit |
|---|---|---|---|
| 1 | | S | |

### Top recommendations (roadmap headline)

1. 
2. 
3. 

---

## 1. Environment audit

Reference: [environment-audit.md](environment-audit.md)

| Component | Current | Status | Notes |
|---|---|---|---|
| Magento version | | | |
| PHP | | | |
| Database | | | |
| Redis / Valkey | | | |
| OpenSearch | | | |
| Deployment mode | | | |
| Theme | | | |

**Findings:** [table or "Unable to verify — no env.php access"]

---

## 2. Code audit

Reference: [code-review.md](code-review.md)

| # | Title | Severity | Evidence | Affected files | Business impact | Recommendation | Effort | Priority |
|---|---|---|---|---|---|---|---|---|
| 2.1 | | | | | | | | |

---

## 3. Extension audit

Reference: [extension-audit.md](extension-audit.md)

| Module | Vendor | Version | Purpose | Upgrade risk | Recommendation |
|---|---|---|---|---|---|
| | | | | | |

---

## 4. Database audit

Reference: [database-optimization.md](database-optimization.md)

| # | Title | Severity | Evidence | Recommendation | Effort |
|---|---|---|---|---|---|
| 4.1 | | | | | |

---

## 5. Performance audit

Reference: [performance-audit.md](performance-audit.md)

| Page / area | Metric | Value | Threshold | Severity | Recommendation |
|---|---|---|---|---|---|
| Homepage | LCP | | < 2.5s | | |

**Unable to verify:** [list metrics not measured]

---

## 6. Security audit

Reference: [security-audit.md](security-audit.md)

| # | Title | Severity | Evidence | Recommendation | Effort |
|---|---|---|---|---|---|
| 6.1 | | | | | |

---

## 7. Infrastructure audit

Reference: [infrastructure-audit.md](infrastructure-audit.md)

| Resource | Status | Finding |
|---|---|---|
| CPU / RAM | Unable to verify / [value] | |

---

## 8. SEO audit

Reference: [seo-audit.md](seo-audit.md)

| # | Title | Severity | Evidence | Recommendation |
|---|---|---|---|---|
| 8.1 | | | | |

---

## 9. Frontend audit

Reference: [frontend-audit.md](frontend-audit.md), [ui-ux-review.md](ui-ux-review.md)

### Storefront

| # | Title | Severity | Evidence | Recommendation |
|---|---|---|---|---|

### Admin UX

| # | Title | Severity | Recommendation |
|---|---|---|---|

---

## 10. Magento best practices

Reference: [magento-best-practices.md](magento-best-practices.md)

| Area | Status | Finding |
|---|---|---|
| Cron | | |
| Indexers | | |
| Cache | | |

---

## 11. Business opportunities

Reference: [business-opportunities.md](business-opportunities.md)

| Opportunity | Evidence | Expected benefit | Effort | Priority |
|---|---|---|---|---|
| | | | | |

---

## Recommended roadmap

| Phase | Timeline | Items |
|---|---|---|
| **Immediate** | 0–2 weeks | Critical security, checkout blockers |
| **Short term** | 1–2 months | High performance, code debt |
| **Medium term** | 3–6 months | SEO, UX, opportunities |
| **Long term** | 6+ months | Platform upgrade, architecture |

---

## Appendix

- **Commands run:** [list]
- **Files / URLs sampled:** [paths]
- **Sections skipped:** [reason — no access]
- **Unable to verify:** [bulleted list]
- **Out of scope:** [pen test, load test, full vendor review]
- **Remediation skills:** **magento-module**, **magento-browser-testing**

---

*Recommendations only. Production changes require staging validation and change management.*
