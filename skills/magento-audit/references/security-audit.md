# Security Audit

**Category 6** — patches, dependencies, access, secrets, exposure.

Extends [version-and-security.md](version-and-security.md) with security-focused checks.

## Evidence to collect

```bash
bin/magento --version
bin/magento deploy:mode:show
composer audit 2>/dev/null
composer outdated --direct
grep -r "password\|secret\|api_key" app/etc/ --include='*.php' 2>/dev/null | head -5
ls -la pub/ 2>/dev/null
bin/magento config:show admin/url/use_custom
bin/magento config:show twofactorauth/general/enable
```

## Checklist

| Check | Severity if failed |
|---|---|
| Magento security patch current | **Critical** if known APSB unpatched |
| `composer audit` vulnerabilities | **Critical** / **High** per CVE |
| Developer mode in production | **Critical** |
| Debug / display errors enabled | **Critical** |
| Secrets in git (`env.php`, `.env`) | **Critical** |
| Weak file permissions (`pub/`, `var/`) | **High** |
| Admin on default `/admin` | **Medium** |
| 2FA disabled for admin | **High** |
| Public writable directories | **High** |
| Outdated `composer.lock` packages | **High** per CVE |
| Raw SQL / `eval` in `app/code` | **Critical** |

## Adobe security bulletins

Cross-check patch level against [Adobe Magento security bulletins](https://helpx.adobe.com/security/products/magento.html). Cite APSB ID when applicable.

## Unable to verify

| Item | Note |
|---|---|
| WAF / Cloudflare rules | Require dashboard export |
| SSL/TLS grade | Require SSL Labs or hosting report |
| Penetration test | Out of scope unless engagement includes |

## Report example

> **Critical:** Magento **2.4.6-p3** — APSB24-XX applies to 2.4.6 line; recommend **2.4.6-p8** minimum. **Evidence:** `bin/magento --version`.
