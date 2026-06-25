# Frontend Audit

**Category 9** — storefront UX, accessibility, front-end performance signals.

Complements [ui-ux-review.md](ui-ux-review.md) (admin + UX narrative) with measurable front-end checks.

## Evidence

| Source | Checks |
|---|---|
| Lighthouse (user) | Accessibility score, unused JS/CSS, DOM size |
| Browser DevTools | Console errors, network waterfall |
| HTML/CSS review | Responsive meta, font loading |
| **magento-browser-testing** | Smoke navigation only — not full a11y audit |

## Checklist

| Area | Look for | Severity |
|---|---|---|
| Accessibility | Missing labels, contrast, keyboard focus | **Medium**–**High** |
| Responsive design | Horizontal scroll mobile, tap targets | **High** if checkout broken |
| Unused JS/CSS | Lighthouse coverage | **Medium** |
| Fonts | FOIT/FOUT, too many families | **Low**–**Medium** |
| Images | Oversized, no dimensions (CLS) | **High** for CLS |
| Layout shift | Late banners, embeds | **High** |
| Large DOM | >1500 nodes PLP | **Medium** |
| Console errors | JS exceptions on PDP/checkout | **High** |
| Network requests | Third-party script count | **Medium** |

## Theme notes

| Theme | Focus |
|---|---|
| Luma | Legacy RequireJS, Knockout checkout |
| Hyvä | Alpine, Tailwind, CSP |
| PWA | API errors, loading states |

## Unable to verify

Full WCAG 2.2 certification — note gaps only; recommend formal audit if required.

## Handoff

Theme code → **magento-module** / Hyvä AI Tools. Admin UX → **ui-ux-review.md** + **magento-module** (`admin-grid.md`).
