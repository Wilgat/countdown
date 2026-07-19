# Reviews (countdown)

Public, **git-tracked** product surface for **what must be reviewed**, **test plans that prove review closures**, and **lessons from prior review reports** so the same defects do not recur.

This directory is the **project review folder** (`{{REVIEWS_DIR}}`).  
Glossary (local harness when present): `project-reviews`, `project-review-folder`, `bootstrap-review-folder`, `review-plan`, `review-skill`.

Peer product surface: [`tests/`](../tests/) (automated CI).  
Product law: [`docs/requirements/`](../docs/requirements/) (tracked requirements only under default docs policy).

## Layout

| Path | Role |
|------|------|
| [`index.md`](./index.md) | Registry of review plans, runs, and open item counts |
| [`what-to-review.md`](./what-to-review.md) | Living checklist of surfaces and checks for this product |
| [`test-plan.md`](./test-plan.md) | Tests required to lock review findings (maps to `tests/`) |
| [`lessons.md`](./lessons.md) | Regression points extracted from prior reports (prevent reintroduction) |
| [`reports/`](./reports/) | Committed review run summaries (public; no secrets) |

## How agents use this folder

1. **Before / during product review** — load `what-to-review.md` + `lessons.md` (mandatory regression pass).  
2. **When findings need automation** — update `test-plan.md` and implement cases under `tests/`.  
3. **After a review run** — write `reports/YYYY-MM-DD-<scope>.md`, update `index.md`, fold durable points into `lessons.md` / `what-to-review.md`.  
4. **Bootstrap origin review** — same folder; scope the report under `reports/` and mark hop (timer / selfmanaged) in the summary.  
5. **Do not** put scratch-only files here (`/tmp/grok-*` stays ephemeral). Promote durable outcomes into this tree so they can be committed.

## Rules

- **Commit-eligible** — this directory is product surface (like `tests/`), not agent harness.  
- **No secrets** — no tokens, private keys, or personal absolute home paths required for CI.  
- **No harness inventory dumps** — do not paste full `docs/skills/**` catalogs; cite live `requirement-*.md` and product paths.  
- **Stay honest** — open items stay open until fixed or explicitly deferred with owner.  
- **Direction** — bootstrap chain is selfmanaged → timer → countdown; never reverse-copy fixes onto ancestors from this leaf without an authorized origin patch plan (see `docs/requirements/requirement-bootstrap-chain.md`).

## Run tests after review closures

```sh
./tests/run.sh
```

See [`test-plan.md`](./test-plan.md) for cases that must exist or be added when closing review items.
