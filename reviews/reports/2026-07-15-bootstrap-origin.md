# Report: bootstrap origin review — timer (immediate) + selfmanaged notes

**Date:** 2026-07-15  
**Mode:** bootstrap origin review (A from B report)  
**B:** countdown v1.1.0  
**A (primary):** timer `./timer` (immediate origin)  
**A (root notes):** selfmanaged sibling ship unit  
**Leaf report:** `2026-07-15-full-product.md`  
**Scratch source:** `grok-bootstrap-origin-review-f5f7de5e`  
**Direction:** A → B only  
**Verdict:** **Block** (inherited bugs on timer)

## Summary

Most countdown full-product findings are **inherited on timer**. Type 0 install/lifecycle subset also exists on **selfmanaged**. Domain storage/JSON/stop issues are timer+countdown, not selfmanaged. No reverse-copy recommended.

## Classification counts (timer as A)

| Class | Count |
|-------|------:|
| inherited_on_A | 11 |
| specialized_only_B | 2 |
| domain_only_B | 1 |
| reverse_copy_risk | 0 |

## Inherited on timer (fix origin, then re-specialize down)

| Leaf # | Sev | Class | Timer evidence | Lesson |
|--------|-----|-------|----------------|--------|
| 1 | bug | inherited_on_A | timer:2337 already_running `out_json "error"` | L-01 |
| 2 | bug | inherited_on_A | timer:2250 shared volatile base | L-02 |
| 3 | bug | inherited_on_A | timer:1396 inst_get_version (+ selfmanaged) | L-03 |
| 4 | bug | inherited_on_A | timer:1300 PATH sed (+ selfmanaged) | L-04 |
| 5 | bug | inherited_on_A | timer:2373 rm unchecked | L-05 |
| 6 | bug | inherited_on_A | timer:397 escape; sanitize denylist | L-06 |
| 7 | suggestion | inherited_on_A | timer:811 wget HTTP/1.1 (+ selfmanaged) | L-07 |
| 8–10,14 | suggestion/nit | inherited_on_A | state trust, TOCTOU, list JSON, list name | L-08..13 |

## Not origin work on timer

| Leaf # | Class | Note |
|--------|-------|------|
| 11 | specialized_only_B | countdown README pin framing |
| 12 | specialized_only_B | countdown REQ VERSION drift (timer VERSION 2.9.0 is legitimate on timer) |
| 13 | domain_only_B | countdown test suite gaps |

## Recommended fix order

1. selfmanaged — L-03, L-04, L-06, L-07 (Type 0)  
2. timer — L-01, L-02, L-05, domain lessons + absorb Type 0  
3. countdown — re-specialize / port; B-only docs/tests  

## Reverse-copy

**None.** Do not copy `./countdown` over `./timer` or selfmanaged.
