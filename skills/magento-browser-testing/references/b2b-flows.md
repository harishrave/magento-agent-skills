# B2B Flows (Adobe Commerce B2B)

Requires **Adobe Commerce B2B** modules enabled. Skip this reference on Open Source / Mage-OS without B2B.

## Company account registration

```typescript
test.describe('B2B company registration', () => {
  test('registrant can request company account', async ({ page }) => {
    await page.goto('/company/account/create/');
    await page.getByLabel('Company Name').fill('Acme Wholesale');
    await page.getByLabel('Legal Name').fill('Acme Wholesale LLC');
    await page.getByLabel('Company Email').fill('buyer@acme.test');
    // Complete remaining required fields per your form config
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText(/thank you|pending/i)).toBeVisible();
  });
});
```

```
Generate regression tests for company account registration.
```

## Company user login

Company users often share customer login:

```typescript
await page.goto('/customer/account/login/');
await page.getByLabel('Email').fill(process.env.B2B_USER_EMAIL!);
await page.getByLabel('Password').fill(process.env.B2B_USER_PASSWORD!);
await page.getByRole('button', { name: 'Sign In' }).click();
await expect(page.getByRole('link', { name: 'Company Structure' })).toBeVisible();
```

## Quote / RFQ workflows

Negotiable quote flow varies by configuration:

1. Add products to cart as company user
2. Request quote instead of checkout
3. Admin approves in backend
4. Customer accepts quote

Test in slices:

| Spec | Asserts |
|---|---|
| `quote-request.spec.ts` | Quote submitted message |
| `quote-accept.spec.ts` | Requires admin fixture or API seed |

Prefer **API-assisted setup** for admin approval steps — see [selectors-and-pom.md](selectors-and-pom.md).

## Approval workflows

Purchase order / approval rules:

- Document required approvers in test plan
- Use dedicated B2B test users per role (buyer, approver, admin)
- Never hard-code production credentials

## Environment

```bash
B2B_BUYER_EMAIL=buyer@company.test
B2B_APPROVER_EMAIL=approver@company.test
B2B_ADMIN_EMAIL=admin@company.test
```

## Handoff

B2B PHP customization → **magento-module**. Admin quote grids → **magento-module** + [admin-browser-tests.md](admin-browser-tests.md).
