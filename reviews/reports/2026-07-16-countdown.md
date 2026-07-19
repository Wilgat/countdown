# Report: countdown (leaf product) — post chain-fix

**Date:** 2026-07-16  
**Mode:** full product review (leaf)  
**Ship unit:** `./countdown`  
**VERSION:** `1.1.1` (post-fix release line)  
**Companion:** `countdown.sha256` matches ship unit (bare hex)  
**Role on chain:** **Leaf** specialized from timer (root selfmanaged)  
**Tests this run:** `PASS=138 FAIL=0` (`./tests/run.sh`)  
**Lessons re-checked:** L-01…L-13, L-B1…L-B3  
**Prior inputs:** `2026-07-15-full-product.md`, origin + chain-fix reports  
**Status:** **Revise** (prior bugs closed in code; residual docs/JSON shape + TP automation)

## Summary

Countdown remains a solid Type 0 + remaining-time domain CLI. The 2026-07-15 full-product review found six bugs; the 2026-07-16 chain fix closed those bugs on the leaf **and** matching parents without reverse-copy. Local CI is fully green (138). Residual items: list JSON string encoding (L-10), README pin-vs-automatic framing (L-11), and automated TP rows that still need stronger asserts even where code is fixed.

## Scope

| Field | Value |
|-------|--------|
| Product type | Type 0 + domain (duration start, remaining time) |
| Domain verbs | start / stop / status / list / kill / reset (+ `--persist`) |
| Chain | selfmanaged → timer → **countdown** |
| Law | `docs/requirements/` including `requirement-bootstrap-chain` |
| Public reviews | this file under `reviews/reports/` |

## Lessons re-check (this hop)

| ID | Result | Notes |
|----|--------|-------|
| L-01 | **Pass** | already_running → stderr `out_json_error` (manual check: stdout empty) |
| L-02 | **Pass** | private volatile/persist fallback dirs + chmod 700 |
| L-03 | **Pass** | `inst_get_version` user-local prefer |
| L-04 | **Pass** | no blanket PATH `.local/bin` delete |
| L-05 | **Pass** | stop/kill rm fail-closed |
| L-06 | **Pass** | escape helper + CR/LF name reject via wc/tr |
| L-07 | **Pass** | wget HTTP family 200 |
| L-08 | **Pass** | integer validation on state |
| L-09 | **Pass** | exclusive create `set -C` |
| L-10 | **Open** | `timers` JSON still string-encoded |
| L-11 | **Pass** (closed 2026-07-19) | README leads with automatic one-liner; pin under Advanced/CI |
| L-12 | **Pass** | REQ Implementation Notes VERSION `1.1.0` aligned |
| L-13 | **Pass** | `list` rejects free name |

## Issues

### Closed on this hop (were open in 2026-07-15 full product)

| # | Severity | Topic | Status |
|---|----------|-------|--------|
| 1 | bug | already_running JSON stdout | **closed** |
| 2 | bug | shared volatile storage | **closed** |
| 3 | bug | inst_get_version | **closed** |
| 4 | bug | PATH sed | **closed** |
| 5 | bug | rm success without check | **closed** |
| 6 | bug | JSON escape / name | **closed** |
| 7 | suggestion | wget HTTP/1.1 | **closed** |
| 8 | suggestion | non-numeric state | **closed** |
| 9 | suggestion | start TOCTOU | **closed** |
| 12 | suggestion | VERSION note drift | **closed** |
| 14 | nit | list free token | **closed** (reject) |

### Still open / residual (countdown)

### Issue 1 -- Severity: suggestion
- File: countdown (list JSON) / tests
- Description: `countdown_list` still emits `timers` as a JSON-encoded **string** via string-only `out_json` (L-10).
- Suggestion: Document second-parse contract or extend emitter; add test for parse expectations.
- Lesson: L-10 · Test: (extend domain JSON list cases)
- Status: open

### Issue 2 -- Severity: suggestion
- File: README.md (install integrity section)
- Description: Pre-fix review flagged pin one-liner as “Recommended” above automatic companion (L-11).
- Suggestion: Lead with automatic one-liner; pin under Advanced/CI.
- Lesson: L-11 · Test: TP-10
- Status: **closed** (2026-07-19 README reorder + current pin digest)

### Issue 3 -- Severity: suggestion
- File: tests/ + reviews/test-plan.md
- Description: TP-01…TP-08 remain **TODO** for strict automation even though code fixes landed (baseline suite green but does not assert stderr channel, dual-install, PATH seed, private dir path, etc.).
- Suggestion: Implement TP rows; flip to **have** when asserts land.
- Lesson: L-01…L-06, L-13 · Test: TP-01…TP-08
- Status: open

### Issue 4 -- Severity: nit
- File: help text
- Description: After rejecting free tokens on `list`, help should state that list shows all and status filters by name (if not already clear).
- Suggestion: One help line for list operands.
- Status: **closed** (2026-07-19 help: list has no name; filter with status)

## Test evidence

```text
./tests/run.sh → PASS=138 FAIL=0 SKIP=0 RESULT: OK
countdown.sha256 matches ./countdown
```

## Verdict

**Revise** — No open **bugs** from the 2026-07-15 set remain in code. Product is shippable for prior Block items; residual suggestions are list JSON contract (L-10) and automated TP lock-in. L-11 README + help list wording closed in 1.1.1.

## Chain note

Leaf is healthy relative to prior Block. When fixing L-10-style emitter design that is shared, prefer Type 0 / shared helper changes on ancestors first if the change is architectural, then re-specialize down (L-B2).
