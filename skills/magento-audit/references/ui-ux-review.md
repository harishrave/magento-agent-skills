# UI/UX Review

Admin and storefront **usability narrative** for project audits. Pair with [frontend-audit.md](frontend-audit.md) for measurable front-end checks.

All findings must follow [evidence-and-severity.md](evidence-and-severity.md).

## Admin UX

Review areas accessible from code/config (or user-provided screenshots):

| Area | Look for | Suggestion format |
|---|---|---|
| **Navigation** | Custom menus buried; duplicate entries | Re-group ACL/menu.xml; clearer labels |
| **Grids** | Missing filters, no default sort, 20+ columns | ui_component: key columns, saved filters |
| **Forms** | Required fields unclear; validation errors generic | Field tooltips, inline validation messages |
| **Config** | Critical settings scattered in multiple tabs | `system.xml` grouping; default values documented |
| **Errors** | Raw exceptions shown to admin users | Friendly messages; log detail server-side |

Cross-reference **magento-module** for implementation patterns after audit.

## Storefront UX

| Area | Signals | Common recommendations |
|---|---|---|
| **Checkout** | Step count, guest checkout, address validation | Reduce steps; inline errors; autofill support |
| **PLP/PDP** | Filters, image gallery, add-to-cart feedback | Sticky filters mobile; swatches; AJAX cart confirmation |
| **Mobile** | Tap targets, horizontal scroll, font size | 44px min touch; responsive breakpoints |
| **Search** | Empty results, typo tolerance | Live Search / better no-results CMS block |
| **Accessibility** | Missing alt text, contrast, keyboard nav | Alt on product images; focus states; form labels |

## Performance UX (when Lighthouse/CWV data provided)

| Metric | Poor threshold | UX tie-in |
|---|---|---|
| LCP | > 2.5s | Hero image, font load, blocking JS |
| INP | > 200ms | Heavy JS on PLP filters |
| CLS | > 0.1 | Image dimensions, late-injected banners |

If no performance data: recommend Lighthouse run on home, PLP, PDP, checkout — do not invent scores.

## Theme-specific notes

| Theme | Review focus |
|---|---|
| Luma / Blank | Legacy patterns; consider Hyvä/PWA discussion separately |
| Hyvä | Alpine components, Tailwind consistency, CSP — pair with [hyva-ai-tools](https://github.com/hyva-themes/hyva-ai-tools) for fixes |
| Custom PWA | API coverage, loading states, offline behavior |

## Report format

Use **problem → user impact → recommendation → priority**:

> **Checkout — shipping step:** Phone number is required but error appears only after submit. **Impact:** Mobile abandonment. **Recommendation:** Inline validation on blur; mark field required with asterisk. **Priority:** High.

Group findings:

1. **Quick wins** (config/CMS, copy, CSS)
2. **Medium** (layout XML, ui_component tweaks)
3. **Strategic** (theme refactor, checkout replacement)

## Severity for UX

| Level | Example |
|---|---|
| **Critical** | Checkout cannot complete on mobile Safari |
| **High** | No guest checkout; forced registration |
| **Medium** | Confusing admin product attribute workflow |
| **Low** | Inconsistent button styles |
| **Info** | A/B test idea for PLP layout |

## Out of scope

- Brand redesign / Figma mockups
- Content strategy / SEO copywriting
- A/B test execution and analytics setup
- Full WCAG 2.2 certification (note gaps only)

## Handoff

| Recommendation | Skill |
|---|---|
| Admin grid/form improvements | **magento-module** |
| New module behavior / checkout plugin | **magento-module** |
| Hyvä theme changes | Hyvä AI Tools + **magento-module** |
