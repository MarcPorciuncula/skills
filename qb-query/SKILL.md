---
name: qb-query
description: Use when the user asks to inspect, query, or debug database state with the installed qb CLI. Skip when the task does not require database reads or asks to modify data.
---

# Query with qb

Run read-only SQL with `qb`. Report the returned data or broker error.

Every query requires a concise audit intent:

```sh
qb query --intent 'inspect recent jobs' \
  'SELECT id, state FROM jobs ORDER BY created_at DESC LIMIT 20'
```

Pass multiple statements as separate arguments:

```sh
qb query --intent 'compare queued and failed jobs' \
  "SELECT count(*) FROM jobs WHERE state = 'queued'" \
  "SELECT count(*) FROM jobs WHERE state = 'failed'"
```

Read one statement from a file or standard input:

```sh
qb query --intent 'inspect queued jobs' --file queries/queued.sql

printf '%s\n' 'SELECT current_date AS report_date' |
  qb query --intent 'confirm reporting date'
```

Use table output by default. Request structured output when it helps analysis:

```sh
qb query --intent 'inspect job states' --format=json \
  'SELECT state, count(*) FROM jobs GROUP BY state ORDER BY state'
```

Use built-in help for more:

```sh
qb --help
qb query --help
```
