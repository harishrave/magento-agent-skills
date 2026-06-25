# Installation Guide

Install **all** RaveDigital Magento agent skills in one step — `magento-module`,
`magento-audit`, and `magento-browser-testing`.

> **Repository:** [github.com/harishrave/magento-agent-skills](https://github.com/harishrave/magento-agent-skills)

## Prerequisites

- A Magento 2.4.x or Mage-OS project (`app/etc/env.php` or `bin/magento`)
- Git (recommended — clone the skills repo once, symlink for instant updates)
- An AI agent that supports `SKILL.md` skills (Cursor, Claude Code, Codex, Windsurf, etc.)

---

## Method 1: Install script (recommended)

### Clone + install (symlink — updates on `git pull`)

```bash
git clone https://github.com/harishrave/magento-agent-skills.git

# From your Magento project root (e.g. /var/www/html/mage-os)
./magento-agent-skills/install.sh cursor
```

### One-liner (no clone — copies skills)

```bash
curl -fsSL https://raw.githubusercontent.com/harishrave/magento-agent-skills/main/install.sh | sh -s cursor
```

### Options

| Flag | Purpose |
|---|---|
| `--copy` | Copy instead of symlink (Docker / host vs container) |
| `--agents` | Install to `.agents/skills/` (Cursor Skills CLI layout) |

```bash
./magento-agent-skills/install.sh --agents cursor
./magento-agent-skills/install.sh --copy cursor
```

### Environment variable

```bash
export RAVEDIGITAL_SKILLS_AGENT=cursor
./magento-agent-skills/install.sh
```

If no agent is passed, the script auto-detects an existing agent skills directory in the project.

### Supported agents

`cursor`, `claude`, `codex`, `copilot`, `gemini`, `junie`, `opencode`, `windsurf`

| Agent | Default skills path |
|---|---|
| Cursor | `.cursor/skills/` |
| Cursor (Skills CLI) | `.agents/skills/` with `--agents` |
| Claude Code | `.claude/skills/` |
| Codex | `.codex/skills/` |
| Windsurf | `.windsurf/skills/` |

### What gets created

**Clone + install (symlink):**

```
your-magento-project/
└── .cursor/skills/
    ├── magento-module -> /path/to/magento-agent-skills/skills/magento-module
    └── ...
```

**One-liner (copy):**

```
your-magento-project/
└── .cursor/skills/
    ├── magento-module/    # full copy with SKILL.md + references/
    └── ...
```

All three skills are always installed together.

### Update skills

| Install method | How to update |
|---|---|
| Clone + symlink | `git pull` in the cloned `magento-agent-skills` repo |
| One-liner or `--copy` | Re-run the one-liner or `./install.sh --copy` |

Start a **new Agent chat** after updating skills.

---

## Method 2: Vercel Skills CLI (alternative)

Installs all skills via npm (requires Node.js):

```bash
npx skills add harishrave/magento-agent-skills -a cursor -y
```

---

## Method 3: Manual copy

```bash
git clone https://github.com/harishrave/magento-agent-skills.git
mkdir -p .cursor/skills
cp -r magento-agent-skills/skills/magento-module .cursor/skills/
cp -r magento-agent-skills/skills/magento-audit .cursor/skills/
cp -r magento-agent-skills/skills/magento-browser-testing .cursor/skills/
```

---

## Verify installation

```bash
ls .cursor/skills/magento-module/SKILL.md
ls .cursor/skills/magento-audit/SKILL.md
ls .cursor/skills/magento-browser-testing/SKILL.md
```

1. Open your Magento project in Cursor
2. Start a **new Agent chat**
3. Ask: *"Which skills apply to admin grid work? Do not write code yet."*
4. Expect: **magento-module** (includes admin grid references)

See [testing-skills.md](testing-skills.md) for full test plans.

---

## Cursor browser testing

Browser testing uses **Cursor's built-in browser tools** — no `npm init playwright` and **no Playwright MCP** required for Cursor-only teams.

1. Open your **Magento project** in Cursor (not the skills repo)
2. Install skills: `./install.sh --agents cursor`
3. Start a **new Agent chat**

```
Use Cursor browser tools to smoke-test the storefront: homepage loads, then customer login shows Sign In.
Screenshot any failure. Base URL: https://magento.test
```

Full guide: `skills/magento-browser-testing/references/cursor-browser.md`.

**Optional:** Playwright MCP when user explicitly asks for Playwright or generated specs — `playwright-mcp-optional.md`.  
**CI regression:** local `@playwright/test` — `playwright-setup.md`.

---

## Co-install with Hyvä AI Tools

RaveDigital skills (backend) and [Hyvä AI Tools](https://github.com/hyva-themes/hyva-ai-tools) (storefront) work side by side:

```bash
./magento-agent-skills/install.sh cursor
./hyva-ai-tools/install.sh cursor
```

---

## Troubleshooting

| Problem | Solution |
|---|---|
| Agent ignores skills | New Agent chat; confirm all three `SKILL.md` files exist under `.cursor/skills/` |
| One-liner left broken symlinks (red paths, no `SKILL.md`) | Remove broken links: `rm -rf .cursor/skills/magento-*` then re-run the one-liner (script now **copies** files for remote install) |
| Symlinks broken on Windows | Re-run with `--copy` |
| Wrong directory | Use `--agents` for `.agents/skills/` |
| Old content (copy install) | Re-run one-liner or `./install.sh --copy` |
| Old content (symlink install) | `git pull` in cloned skills repo; new Agent session |

---

## Team rollout

```bash
git clone https://github.com/harishrave/magento-agent-skills.git
cd /var/www/html/mage-os
../magento-agent-skills/install.sh --agents cursor
```

Commit symlinks in the Magento repo for zero-setup onboarding, or document the install command in your internal wiki.
