# Database Optimization

Database-level audit recommendations — analysis and suggestions only unless the user authorizes changes.

## Evidence to collect

```bash
bin/magento setup:db:status
bin/magento indexer:status
mysql -e "SHOW TABLE STATUS" <database> | sort -k7 -n -r | head -20   # Data_length
mysql -e "SHOW PROCESSLIST"
```

On production, use read replicas or DBA-exported reports — never run heavy scans on live primary without approval.

## Common findings

| Area | Symptom | Recommendation |
|---|---|---|
| **Report tables** | Huge `report_viewed_product_*`, `report_event` | Enable aggregation / clean cron; truncate stale data per retention policy |
| **Sessions** | Large `session` table | Move to Redis; shorten session lifetime |
| **Logs** | `exception`, `cron_schedule` bloat | Log rotation; `cron_schedule` cleanup; Monolog to external sink |
| **Search** | Catalogsearch on MySQL | Migrate to Elasticsearch/OpenSearch if not already |
| **Indexers** | Invalid / backlog | Identify indexer; schedule off-peak; check `mview` state |
| **Custom tables** | Missing indexes on FK/filter columns | Add indexes in `db_schema.xml`; document in report |
| **Dead tuples** | InnoDB bloat | `OPTIMIZE TABLE` in maintenance window (with DBA) |

## Custom module schema review

For each `app/code/*/etc/db_schema.xml`:

- Primary keys and indexes on columns used in WHERE/JOIN
- Foreign keys with appropriate `onDelete`
- No redundant varchar(255) on every column
- Whitelist file committed (`db_schema_whitelist.json`)

Cross-reference **magento-module** [database-and-schema.md](../../magento-module/references/database-and-schema.md) for fix patterns.

## Query optimization (sampling)

When slow query log or APM data is available:

1. Identify top 5 queries by total time
2. Note missing indexes (`EXPLAIN` on staging copy)
3. Flag N+1 patterns in custom repositories (loops calling `load()`)

Without slow query data, state: *"Recommend enabling slow query log on staging and re-auditing."*

## Archival and retention

Suggest policies, not arbitrary deletes:

- Orders older than X years → archive tables or cold storage
- Quote cleanup (`sales_clean_quotes` cron)
- GDPR: anonymization vs hard delete

## Report example

> **Database:** `report_viewed_product_index` is 12 GB — enable report aggregation and truncate historical data older than 90 days. Custom table `vendor_promo_log` lacks index on `store_id` + `created_at` — add composite index for admin grid filters.

## Severity guide

| Severity | Example |
|---|---|
| **Critical** | Primary DB disk >90%; replication lag breaking checkout |
| **High** | Invalid inventory indexer; session table locking site |
| **Medium** | Missing index on custom entity admin grid |
| **Low** | Slightly oversized log tables with working rotation |
| **Info** | Opportunity to move cache to Redis |

## Out of scope

- Full query rewrite implementation (hand off to **magento-module**)
- Hardware sizing / RDS instance class (note as recommendation only)
- Sharding / split database
