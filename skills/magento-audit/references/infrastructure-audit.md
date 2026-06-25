# Infrastructure Audit

**Category 7** — server resources, PHP-FPM, services, limits.

Most infrastructure evidence **requires SSH, hosting panel, or monitoring** — not visible from codebase alone.

## When code/repo only

State for each item:

> **Unable to verify:** CPU, RAM, disk, swap, PHP-FPM workers, MySQL buffer pool — recommend New Relic / hosting metrics export or SSH `top`, `free -h`, `df -h`.

## Evidence (when available)

| Resource | Commands / source |
|---|---|
| CPU / RAM | `top`, `htop`, cloud monitoring |
| Disk | `df -h`, database size |
| Swap | `free -h` |
| PHP-FPM | Pool config: `pm.max_children`, `memory_limit` |
| MySQL | `SHOW VARIABLES LIKE 'innodb_buffer_pool_size'` |
| Redis | `INFO memory`, maxmemory policy |
| OpenSearch | Cluster health API |
| RabbitMQ | Queue depth |
| NGINX / Apache | Worker count, timeouts |
| Workers | Consumer processes running |

## Magento tie-ins

| Infra issue | Business impact |
|---|---|
| Disk >90% | Checkout failures, cron stops |
| PHP memory too low | 500 errors on large carts |
| MySQL buffer pool small | Slow queries site-wide |
| Too few FPM workers | Timeouts at peak traffic |

## Adobe Commerce Cloud

If `.magento/` or `app.yaml` present in repo, review:

- Service relationships (Redis, DB, OpenSearch)
- Build/deploy hooks
- `ece-tools` version

Otherwise: **Unable to verify** cloud infrastructure from application repo.
