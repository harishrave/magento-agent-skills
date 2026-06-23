# Testing Agent Skills

How to verify RaveDigital Magento agent skills work in Cursor — especially **magento-testing**.
Use `/var/www/html/mage-os` (or your Mage-OS / Magento 2.4 project) as the test target.

## Prerequisites

| Requirement | Check |
|---|---|
| Magento/Mage-OS project with `bin/magento` | `bin/magento --version` |
| PHPUnit available | `vendor/bin/phpunit --version` |
| Skills installed | `.agents/skills/magento-testing/SKILL.md` exists |
| Cursor opens the **Magento project** (not this skills repo) | Project root = `mage-os/` |
| New Agent chat after install/update | Fresh session picks up skills |

Install all skills if needed:

```bash
cd /var/www/html/mage-os
../magento-agent-skills/install.sh --agents cursor
```

---

## Test matrix (magento-testing)

| # | Test | Code written? | PHPUnit run? | Pass criteria |
|---|---|---|---|---|
| A | Skill routing | No | No | Agent cites magento-testing + correct references |
| B | Unit test scaffold | Yes (test only) | Optional | Correct `Test/Unit/` layout, mocks, no ObjectManager |
| C | Unit test + run | Yes | Yes | `vendor/bin/phpunit` exits 0 |
| D | Integration test | Yes | Yes (if DB configured) | `@magentoDbIsolation`, Bootstrap pattern |
| E | Anti-patterns | No | No | PHPUnit skill refuses browser tests; browser skill routes to Cursor browser |
| F | Module test gate | No | Optional | Cites module-testing + static-analysis |
| G | Upgrade testing | No | No | Cites version-upgrade-testing.md |

Run **A → B → C** for a quick smoke test. Add **D–G** as needed.

---

## Test A — Skill loads (30 seconds)

**Prompt:**

```
Which RaveDigital skill applies to adding PHPUnit tests for a custom module repository?
List the skill and reference files you would use. Do not write code yet.
```

**Pass if the agent mentions:**

- `magento-testing` skill
- `unit-test-generation.md`, `module-testing.md`, or `integration-testing.md`
- `Test/Unit` vs `Test/Integration` decision
- For PHPCS/PHPStan: `static-analysis.md`
- For upgrade: `version-upgrade-testing.md`
- Handoff: module code → **magento-module**, not magento-testing alone

**Fail if:** suggests MFTF/browser tests without you asking, or skips skill references.

---

## Test B — Unit test generation (no DB)

Use a **small class you control** so the test is runnable later. Two options:

### Option 1: Minimal scratch class (recommended)

Create one file manually (or ask **magento-module** in a separate chat):

`app/code/RaveDigital/StoreLocator/Model/StoreHours.php`

```php
<?php
declare(strict_types=1);

namespace RaveDigital\StoreLocator\Model;

use Magento\Framework\App\Config\ScopeConfigInterface;

class StoreHours
{
    private const XML_PATH_ENABLED = 'ravedigital_storelocator/general/enabled';

    public function __construct(
        private readonly ScopeConfigInterface $scopeConfig
    ) {
    }

    public function isEnabled(): bool
    {
        return $this->scopeConfig->isSetFlag(self::XML_PATH_ENABLED);
    }

  /** @return int[] hours 0–23 when enabled */
    public function getOpenHours(string $storeCode, string $date): array
    {
        if (!$this->isEnabled()) {
            return [];
        }
        return [9, 10, 11, 12, 13, 14, 15, 16, 17];
    }
}
```

Also add `registration.php` + `etc/module.xml` if the module is not enabled yet (minimal scaffold).

**Prompt (new chat, magento-testing focus):**

```
Write a PHPUnit unit test for RaveDigital\StoreLocator\Model\StoreHours::getOpenHours()
with mocked ScopeConfigInterface.

Requirements:
- Test/Unit/ per magento-testing skill
- Extend PHPUnit\Framework\TestCase (not Magento integration base)
- Mock ScopeConfig — no database, no ObjectManager::getInstance()
- At least two cases: disabled (empty array) and enabled (non-empty)
- declare(strict_types=1)

Show the phpunit command to run it from the Magento root.
```

**Pass if generated test has:**

| Check | Expected |
|---|---|
| Path | `app/code/RaveDigital/StoreLocator/Test/Unit/Model/StoreHoursTest.php` |
| Namespace | `RaveDigital\StoreLocator\Test\Unit\Model` |
| Base class | `PHPUnit\Framework\TestCase` |
| Mocks | `createMock(ScopeConfigInterface::class)` |
| No | `ObjectManager::getInstance()`, real DB, `Test/Integration/` for this task |

---

## Test C — Run PHPUnit (verify commands)

From Magento root:

```bash
cd /var/www/html/mage-os

vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Unit/Model/StoreHoursTest.php
```

Or filter by class name:

```bash
vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist --filter StoreHoursTest
```

**Pass:** exit code `0`, tests listed as passed.

**Common failures:**

| Error | Fix |
|---|---|
| Class not found | Run `bin/magento setup:di:compile`; check PSR-4 / `registration.php` |
| Test class not found | Path must mirror namespace under `Test/Unit/` |
| PHPUnit config missing | Use `-c dev/tests/unit/phpunit.xml.dist` from project root |

**Pass if the agent** (in the same chat) suggested the correct command and config path.

---

## Test D — Integration test (optional, needs repository)

Only run when `RaveDigital_StoreLocator` has a repository + `db_schema.xml` table.

**Prompt:**

```
Add an integration test for LocationRepositoryInterface: save a location,
load by ID, assert store_code matches. Use @magentoDbIsolation per magento-testing skill.
Place under Test/Integration/. Show the phpunit command.
```

**Pass if:**

- File under `Test/Integration/Model/...`
- Uses `Magento\TestFramework\Helper\Bootstrap::getObjectManager()`
- `@magentoDbIsolation` on test methods that write data
- Command uses `dev/tests/integration/phpunit.xml.dist`

**Run:**

```bash
vendor/bin/phpunit -c dev/tests/integration/phpunit.xml.dist \
  app/code/RaveDigital/StoreLocator/Test/Integration
```

**Note:** Integration tests need a configured test database (`dev/tests/integration/etc/install-config.php` or env vars). If DB is not set up, **Test D is expected to fail at runtime** — you can still pass on **structure** if the agent followed the skill.

---

## Test E — Scope boundaries (negative test)

**Prompt:**

```
Add Cypress tests for the checkout store locator map widget.
```

**Pass if the agent:**

- Routes to **magento-browser-testing** (Cursor browser) — not magento-testing
- Does not require Playwright MCP or `npm init playwright` for interactive validation

**Prompt (PHPUnit skill should not take Playwright):**

```
Create a Playwright test for customer login.
```

**Pass if the agent:**

- Uses **magento-browser-testing**, not magento-testing

**Prompt:**

```
Add a unit test that boots Magento and saves to the real database for StoreHours.
```

**Pass if the agent:**

- Corrects the approach — `StoreHours` should be unit-tested with mocks
- DB save belongs in integration tests on the repository, not the unit test

---

## Quick checklist (share with team)

```
[ ] Skills installed in Magento project (.agents/skills/magento-testing/)
[ ] Test A: agent routes to magento-testing
[ ] Test B: unit test file structure correct
[ ] Test C: vendor/bin/phpunit passes for unit test
[ ] Test D (optional): integration test structure + @magentoDbIsolation
[ ] Test E: agent refuses wrong test type (JS/MFTF/real DB in unit test)
[ ] Test F (optional): module test gate cites module-testing + static-analysis
[ ] Test G (optional): upgrade prompt cites version-upgrade-testing.md
```

---

## Copy-paste prompts

See [example-prompts.md](example-prompts.md#magento-testing) for ready-made prompts.

**Minimal unit test only:**

```
Write a PHPUnit unit test for RaveDigital\StoreLocator\Model\StoreHours::getOpenHours()
with mocked ScopeConfig. Place test in Test/Unit per Magento conventions.
```

**Module + tests combined:**

```
Create RaveDigital_StoreLocator with StoreHours model, then add unit tests per magento-testing skill.
Run setup:di:compile and phpunit for the new tests.
```

---

## Testing other skills (short)

| Skill | Smoke-test prompt |
|---|---|
| **magento-module** | "Which skill for db_schema.xml? Do not write code." |
| **magento-admin-ui** | "Grid has headers but no rows — which reference doc?" → `grid-data-providers.md` |
| **magento-testing** | Tests A–G above |
| **magento-browser-testing** | "Use Cursor browser to test customer login" → cites cursor-browser + storefront-flows |

Full install verification: [install.md](install.md).

---

## What you cannot test without Magento

- `vendor/bin/phpunit` execution
- Integration test DB bootstrap
- Whether generated tests compile against real interfaces

In the **skills repo alone**, validate markdown structure and prompts — run Tests A and E in Cursor with skills installed in a Magento project for real verification.
