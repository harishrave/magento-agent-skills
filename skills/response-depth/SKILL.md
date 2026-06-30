---
name: response-depth
description: >-
  Default response style for Magento 2 / Mage-OS / Adobe Commerce work. Prioritizes
  completeness over brevity unless the user explicitly requests a short answer.
  Produces senior-engineering documentation quality with diagrams, examples, file
  references, troubleshooting, verification steps, and best practices. Use when
  explaining concepts, answering how or why questions, writing guides, documenting
  solutions, debugging, or when the user asks for detail, depth, or thorough
  explanations. Complements magento-module, magento-audit, and magento-browser-testing
  — apply their workflows with full explanatory depth. Override only when the user
  asks for brief, short, tldr, or quick answers.
---

# Response Depth

Default communication standard for Magento agent work. Apply on every reply unless the user explicitly opts out.

## Core rule

Unless the user explicitly requests a short answer, prioritize completeness over brevity.

Aim to provide responses that are comparable to senior engineering documentation or an internal technical knowledge base.

Include diagrams (ASCII when helpful), code examples, configuration examples, file references, troubleshooting steps, verification steps, and best practices whenever they add value.

Do not omit useful technical details simply to keep the response short.

## When to use full depth (default)

- Explanations of architecture, bugs, or root cause
- Implementation guidance, code review, or deployment notes
- Magento module, theme, layout, DI, or config work — pair with **magento-module**
- Project audits and investigations — pair with **magento-audit**
- Browser validation and flow testing — pair with **magento-browser-testing**
- Any task where the user did not ask for brevity

## When to shorten

Only compress the reply when the user clearly asks, for example:

- "short answer", "brief", "tldr", "quick summary", "one line", "just yes/no"

If unsure, prefer full depth.

## What to include (when it adds value)

| Element | Use when |
|--------|----------|
| **Context / summary** | Multi-step or non-obvious topics — orient the reader first |
| **File references** | Pointing at real paths (`app/code/`, `app/design/`, `etc/`, `composer.json`) |
| **Code / config examples** | Showing the actual change, command, or XML/PHP snippet |
| **ASCII diagrams** | Flows, request paths, module dependencies, plugin chains, deploy sequence |
| **Troubleshooting** | Errors, compile failures, empty grids, cache issues — likely causes and fixes |
| **Verification** | How to confirm the fix (`bin/magento` CLI, admin, storefront, logs) |
| **Best practices** | Security, performance, upgrade-safe patterns for Magento 2.4.x / Mage-OS |
| **Risks / follow-ups** | `setup:upgrade`, `setup:di:compile`, cache flush, staging impact, rollback notes |

## Structure patterns

### Explanations

1. Short orienting summary (what and why)
2. Mechanism or architecture (with diagram if helpful)
3. Relevant code or config with file paths
4. Verification steps
5. Optional: edge cases, risks, related skill references

### Implementations

1. What changed and which module/files
2. Key snippets or diffs
3. Magento CLI steps (`module:enable`, `setup:upgrade`, `setup:di:compile`, `cache:flush`)
4. How to test on storefront or admin
5. Rollback or monitoring notes if production-relevant

### Debugging

1. Observed symptom
2. Likely root cause (with evidence from logs, code, or config)
3. Fix or workaround
4. Steps to verify and prevent recurrence

## Magento reminders

- Name affected **Vendor_Module** and files explicitly under `app/code/`.
- Call out **theme** paths under `app/design/frontend/` or `app/design/adminhtml/` when relevant.
- Note **patches**, `composer.json` changes, or project `docs/` when they apply.
- For operational changes, include compile, cache, and deploy implications for the target environment (local, staging, Cloud).

## Anti-patterns

- Do not pad with generic filler or repeat the question at length.
- Do not skip verification steps for production-impacting changes.
- Do not sacrifice accuracy for length — depth means *useful* detail, not verbosity.
- Do not stay brief by default; brevity is opt-in only.

## Agent compatibility

Open `SKILL.md` format — install via [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
See [docs/install.md](../../docs/install.md).
