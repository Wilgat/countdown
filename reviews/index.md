# Reviews index

**Product:** countdown  
**Updated:** 2026-09-27  
**Policy:** Public git surface under `reviews/` (peer of `tests/`).  
**Chain:** selfmanaged (root) → timer (immediate) → countdown (leaf)

| ID | Kind | Title | Status | Path | Updated |
|----|------|-------|--------|------|---------|
| plan-what-to-review | plan | Living product review checklist | Active | `what-to-review.md` | 2026-09-27 |
| plan-tests | test-plan | Portable TP families + domain TP-COUNTDOWN | Active | `test-plan.md` | 2026-09-27 |
| rtm-main | matrix | Requirement ↔ test matrix | Active | `requirement-test-matrix.md` | 2026-09-27 |
| lessons-main | lessons | Prior-report regression points | Active | `lessons.md` | 2026-09-27 |
| report-2026-07-15-full | report | Full product review (v1.1.0) pre-fix | Historical / open at time | `reports/2026-07-15-full-product.md` | 2026-07-15 |
| report-2026-07-15-origin | report | Bootstrap origin review (timer + selfmanaged notes) | Historical / Block at time | `reports/2026-07-15-bootstrap-origin.md` | 2026-07-15 |
| report-2026-07-16-chain-fix | report | Bootstrap chain fix (Type 0 + domain on all hops) | Closed (code) | `reports/2026-07-16-bootstrap-chain-fix.md` | 2026-07-16 |
| report-2026-07-16-selfmanaged | report | **selfmanaged** hop review (post-fix) | Revise | `reports/2026-07-16-selfmanaged.md` | 2026-07-16 |
| report-2026-07-16-timer | report | **timer** hop review (post-fix) | Revise | `reports/2026-07-16-timer.md` | 2026-07-16 |
| report-2026-07-16-countdown | report | **countdown** leaf review (post-fix) | Revise | `reports/2026-07-16-countdown.md` | 2026-07-16 |
| report-2026-09-23-cache-read | report | Cache folder design + do-not-capture-read | Fixed in 1.1.6 | `reports/2026-09-23-cache-and-capture-read.md` | 2026-09-23 |
| report-2026-09-27-cache-folder | report | Per-login per-process cache folder (CL-TEMP-FILE-SYSTEM) | Fixed in 1.1.7 | `reports/2026-09-27-checklist-temp-file-system-cache-folder.md` | 2026-09-27 |

## Open item summary (latest per-hop runs 2026-07-16)

| Hop | Verdict | Open bugs | Residual (suggestion/nit) | Notes |
|-----|---------|----------:|---------------------------:|-------|
| selfmanaged | Revise | 0 | test/process/docs | Type 0 L-03/04/06/07 closed in code |
| timer | Revise | 0 | L-10 list JSON; suite ownership | Domain + Type 0 bugs closed |
| countdown | Revise | 0 | L-10 list JSON | 1.1.7 cache leaf is per login and per process; L-14 mode 700 and L-15 stay closed; L-10 still open |

See `lessons.md` for durable regression checks; `test-plan.md` + `requirement-test-matrix.md` for CI lock-in (portable TP families **have**). 2026-09-27: cache leaf is `cache-${APP_NAME}-${login}-$$` on volatile tiers; home tiers omit the login; a skipped tier is silent (`reports/2026-09-27-checklist-temp-file-system-cache-folder.md`). **L-14** and **L-15** stay closed. **L-10** still open (`list --json` `timers` is a string-encoded array).

## How to add a run

1. Add `reports/YYYY-MM-DD-<scope>.md` (Summary + Issues or origin classification table).  
2. Append a row here.  
3. Merge new durable failure modes into `lessons.md` and `what-to-review.md`.  
4. Update `test-plan.md` for any new required automated cases.  
