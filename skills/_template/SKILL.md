---
name: {{skill-name}}
description: >-
  TODO: Third-person description of WHAT this skill does and WHEN to trigger it.
  Include strong keywords agents will match (e.g. package names, file paths, task verbs).
  Mention related skills to avoid overlap (e.g. "use magento-module for ...").
---

# {{Skill Title}}

One-paragraph overview. Keep SKILL.md under 500 lines — put deep dives in `references/`.

## RaveDigital conventions

- List hard rules specific to this domain
- Cross-link shared rules in AGENTS.md when they apply everywhere

## Workflow

1. **Identify the task** and read the matching reference:

   | Task | Read first |
   |---|---|
   | TODO task type | [references/topic.md](references/topic.md) |

2. **Implement** following patterns in references.

3. **Verify before declaring done:**

   ```bash
   bin/magento setup:di:compile
   # Add domain-specific verification commands
   ```

## Decision shortcuts

- "TODO trigger phrase" → recommended approach + reference link

## Final checklist

- [ ] TODO pre-merge checks

## Agent compatibility

Open `SKILL.md` format — install via [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills).
See [docs/install.md](../../docs/install.md).
