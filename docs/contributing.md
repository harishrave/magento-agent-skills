# Contributing

Thank you for improving **magento-agent-skills** for RaveDigital. Changes here affect how AI agents write
Magento code across the team — treat skill edits with the same care as library code.

## What belongs in this repo

| ✅ Include | ❌ Exclude |
|---|---|
| Magento/Mage-OS development conventions | Project-specific secrets or env config |
| Reusable workflows and reference docs | Customer-specific business logic |
| Prompt-based agent workflows in references/ | Agent-specific plugin configs (`.claude-plugin/`) |
| | Full Magento modules (belong in app/code) |

## Skill structure

Each skill is a directory under `skills/`:

```
skills/my-skill/
├── SKILL.md              # Required — workflow + triggers (keep under 500 lines)
└── references/           # Optional — detailed docs (loaded on demand)
    └── topic-name.md     # Use clear, self-describing kebab-case names
```

### SKILL.md frontmatter

```yaml
---
name: my-skill
description: >-
  What it does and when to use it. Write in third person. Include trigger terms.
  Mention related skills to avoid (e.g. "use magento-module instead for ...").
requires: magento-module   # optional — installer pulls dependencies automatically
---
```

**Description is critical** — agents use it to decide when to load the skill. Include both
WHAT and WHEN.

**`requires:`** — documents skill relationships for agents (e.g. admin-ui references module conventions). All skills are installed together by `install.sh`.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` (copy from `skills/_template/` if helpful)
2. Add reference docs in `skills/<skill-name>/references/`
3. Register in `magento-skills.json` under `install.skills`
4. Update `README.md`, `docs/skills-map.md`, `CHANGELOG.md`
5. Open a PR — `install.sh` will include any skill with a `SKILL.md` (except `_template`)

## Improving existing skills

1. **Prefer references over bloating SKILL.md** — keep main file under 500 lines
2. **Verify against a real Mage-OS install** when changing module conventions
3. **Cross-link references** — e.g. admin grids in `admin-grid.md` under magento-module

## Pull request checklist

- [ ] `SKILL.md` has valid YAML frontmatter (`name`, `description`)
- [ ] Description includes trigger terms in third person
- [ ] No agent-specific instructions (Claude-only slash commands, etc.)
- [ ] No secrets, URLs, or org-specific paths hardcoded
- [ ] `CHANGELOG.md` updated under `[Unreleased]`
- [ ] README skills table updated if adding/removing skills

## Versioning

We use [Semantic Versioning](https://semver.org/) via git tags:

| Change | Version bump |
|---|---|
| New skill or major reference rewrite | MINOR (1.1.0) |
| Typo fixes, small clarifications | PATCH (1.0.1) |
| Breaking skill rename or removed skill | MAJOR (2.0.0) |

Tag releases:

```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

## Testing skills

See [testing-skills.md](testing-skills.md) for a shareable verification plan.

Quick smoke test:

1. Install: `./install.sh cursor` from a Magento project
2. Open that project in Cursor
3. Ask realistic module tasks (scaffold a module, debug layout, choose plugin vs observer)
4. Confirm the agent runs verification commands and follows conventions

## Code of conduct

Be constructive in review. Skills encode team standards — disagreements about conventions
should be resolved in PR discussion before merging.

## Questions

Open a GitHub issue in [harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills) or contact the internal devtools lead.
