# Debugging Admin UI Components

## Symptom → cause

| What you see | Likely issue |
|---|---|
| Blank content area | Invalid ui_component XML — `var/log/exception.log` |
| Spinner never stops | Provider / deps / dataSource name mismatch; JS console errors |
| Column headers, no rows | `CollectionFactory` `collections` key wrong or missing |
| Cells show `undefined` | `prepareDataSource()` missing field; wrong `indexField` |
| Filter breaks grid | Collection lacks field; SQL error in exception.log |
| Empty AJAX / 401 | ACL `aclResource` or controller `ADMIN_RESOURCE` |
| Changes ignored | Stale layout cache — `cache:clean layout block_html` + hard refresh |

## CLI helpers

```bash
bin/magento cache:clean layout block_html full_page
bin/magento setup:di:compile
bin/magento dev:query-log:enable   # disable after debugging SQL
```

## Browser workflow

1. DevTools → Network → load grid
2. Find `mui/index/render` — inspect `items`, `totalRecords`, error payload
3. Console → RequireJS / Knockout errors

Template hints show PHP blocks, not Knockout templates — read XML + `component="..."` for JS structure.

## Merge pitfalls

When extending core listings, duplicate sibling `name` attributes fight unpredictably. Add
uniquely named children under the correct parent (`columns`, `listingToolbar`).

## Frequent XML mistakes

- Wrong XSD `xsi:noNamespaceSchemaLocation`
- Missing `xsi:type` on `<item>` elements
- `primaryFieldName` does not match database column
- Filter `dataScope` ≠ collection field name
