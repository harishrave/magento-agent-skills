# SEO Audit

**Category 8** — discoverability, metadata, technical SEO, Core Web Vitals tie-in.

## Evidence sources

| Source | Data |
|---|---|
| Storefront HTML (curl or browser) | title, meta, canonical, robots |
| `robots.txt`, `sitemap.xml` | Crawl rules |
| Code / theme | structured data modules, hreflang |
| Lighthouse SEO audit (user) | Score, issues |
| Search console (user) | Coverage, CWV — **Unable to verify** without export |

## Checklist

| Check | How | Severity |
|---|---|---|
| Unique title tags | Sample PDP, PLP, CMS | **Medium** if duplicate/missing |
| Meta descriptions | View source | **Low**–**Medium** |
| Canonical URLs | `<link rel="canonical">` | **High** if wrong or missing on PDP |
| robots.txt | `curl /robots.txt` | **High** if blocks important paths |
| XML sitemap | `/sitemap.xml` or config | **Medium** if missing |
| Structured data | JSON-LD Product/BreadcrumbList | **Medium** for rich results |
| Image ALT | Sample PDP images | **Medium** accessibility + SEO |
| Duplicate content | faceted URLs, HTTP/HTTPS | **High** |
| Broken links | Crawler export or spot check | **Medium** |
| 404 handling | CMS no-route | **Medium** |
| Redirects | 301 chains | **Medium** |
| Core Web Vitals | [performance-audit.md](performance-audit.md) | **High** if poor |

## Magento-specific

- SEO extensions vs native (`Magento_Catalog` meta templates)
- Category layered navigation indexation (`rel="nofollow"` on filters)
- Store code in URL multi-store
- `Magento_Sitemap` cron enabled

## Report rule

Cite **URL + HTML snippet or config path** as evidence. No invented Search Console metrics.
