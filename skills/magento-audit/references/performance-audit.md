# Performance Audit

**Category 5** — storefront speed, Core Web Vitals, Magento caching, indexers.

## Evidence sources

| Source | Provides |
|---|---|
| Lighthouse / PageSpeed (user) | LCP, CLS, INP, TTFB, JS/CSS weight |
| New Relic / APM (user) | Slow transactions, DB time |
| `bin/magento indexer:status` | Invalid/backlog indexers |
| `bin/magento cache:status` | Disabled caches |
| Code review | `cacheable="false"` blocks, heavy plugins |
| Browser (optional) | **magento-browser-testing** for smoke only |

**Never invent metrics.** No Lighthouse data → state **Unable to verify** for CWV scores.

## Pages to review (when URL access available)

| Page | Checks |
|---|---|
| Homepage | LCP hero, TTFB, JS payload |
| Category | Filter AJAX, product count, INP |
| Product (PDP) | Gallery, related products, around plugins |
| Cart | Section load, mini-cart |
| Checkout | Step count, payment/shipping AJAX |

## Magento-specific

```bash
bin/magento indexer:status
bin/magento cache:status
bin/magento config:show catalog/search/engine
bin/magento config:show system/full_page_cache/caching_application
```

| Check | Finding example |
|---|---|
| Invalid indexers | **High** — `catalog_product_price` invalid |
| Full page cache off | **High** — Varnish/FPC not enabled |
| MySQL catalog search | **Medium**–**High** on large catalogs |
| Cron backlog | `cron_schedule` — see [database-optimization.md](database-optimization.md) |
| Consumers stopped | Message queue not processing |

## Front-end assets (when measurable)

- JS bundle size (Lighthouse/network)
- CSS size
- Image format (WebP/AVIF)
- Lazy loading on PLP images
- Compression (gzip/brotli) — **Unable to verify** without HTTP headers
- CDN — config or Cloudflare user input
- HTTP/2 or HTTP/3 — **Unable to verify** without curl -I

## Report format

| Metric | Value | Threshold | Severity |
|---|---|---|---|
| LCP | 4.2s | < 2.5s | High |
| TTFB | 800ms | < 600ms | Medium |

Tie each finding to **business impact** (bounce rate, conversion, ad quality score).

## Handoff

Code-level fixes → **magento-module**. Theme/Hyvä → note Hyvä AI Tools if applicable.
