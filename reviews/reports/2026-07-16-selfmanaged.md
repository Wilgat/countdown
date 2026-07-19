# Report: selfmanaged (bootstrap root) — post chain-fix

**Date:** 2026-07-16  
**Mode:** product / origin hop review (root of bootstrap chain)  
**Ship unit:** `/var/www/grok.dr-sense.com/prjs/selfmanaged/selfmanaged`  
**VERSION:** `1.1.0`  
**Role on chain:** **Root bootstrap origin** (A0) for timer → countdown  
**Direction:** A → B only (this report does not authorize reverse-copy)  
**Lessons re-checked:** L-03, L-04, L-06, L-07 (Type 0); L-B1–L-B3  
**Prior inputs:** `2026-07-15-bootstrap-origin.md`, `2026-07-16-bootstrap-chain-fix.md`  
**Status:** **Revise** (code closed for known Type 0 bugs; automated TP lock-in still open on leaf suite)

## Summary

Selfmanaged is the domain-thin Type 0 baseline (install, version-check, self-update, self-uninstall, about/help, automatic companion checksum). After the 2026-07-16 chain fix, the shared Type 0 defects flagged from the countdown leaf report are **closed in code** on this hop: version path SSOT, PATH uninstall cleanup, JSON escape, wget companion HTTP match. No domain timer/countdown surface exists here by design. Residual work is mostly **test lock-in** (TP-02/03/05/09) and keeping this hop as the preferred place for future shared Type 0 fixes before re-specializing descendants.

## Scope

| Field | Value |
|-------|--------|
| Product type | Type 0 self-managed POSIX `/bin/sh` CLI |
| Domain surface | None (lifecycle only) |
| Chain position | Root |
| Descendants | timer (immediate child), countdown (leaf via timer) |
| Suite in this repo | N/A (selfmanaged lives in sibling project); leaf suite does not replace selfmanaged CI |

## Lessons re-check (this hop)

| ID | Topic | Evidence / result |
|----|-------|-------------------|
| L-03 | `inst_get_version` prefer user-local non-root | **Pass** — body prefers `USER_BIN` when executable before `GLOBAL_BIN` |
| L-04 | No blanket `/\.local\/bin/d` | **Pass** — expression absent; installer marker + exact bin path only |
| L-06 | `util_json_escape` controls | **Pass** — awk-based escape for `\`, `"`, `\t`, `\r`, multi-line `\n` |
| L-07 | wget companion HTTP | **Pass** — `grep -qE "HTTP/[0-9.]+ 200"` |
| L-01/L-02/L-05/L-08/L-09/L-13 | Domain | **N/A** — no domain surface |

## Issues

### Closed on this hop (were open pre-2026-07-16)

| Former | Severity | Topic | Status |
|--------|----------|-------|--------|
| Leaf #3 / origin | bug | `inst_get_version` global preference | **closed** on selfmanaged |
| Leaf #4 / origin | bug | PATH sed over-delete | **closed** on selfmanaged |
| Leaf #6 / origin | bug | weak JSON escape | **closed** on selfmanaged |
| Leaf #7 / origin | suggestion | wget HTTP/1.1 only | **closed** on selfmanaged |

### Still open / residual (selfmanaged)

### Issue 1 -- Severity: suggestion
- File: selfmanaged (sibling project tests, if any)
- Description: No automated dual-install version-preference or PATH-cleanup regression suite was verified in the countdown workspace for this hop. Code fix is present; CI lock-in may live in selfmanaged’s own tests.
- Suggestion: Add or confirm selfmanaged lifecycle tests for L-03/L-04; keep leaf TP-02/TP-03 as integration coverage when applicable.
- Lesson: L-03, L-04 · Test: TP-02, TP-03
- Status: open

### Issue 2 -- Severity: nit
- File: selfmanaged ship unit / publish process
- Description: Ensure companion `selfmanaged.sha256` is regenerated whenever the ship unit is published after Type 0 edits.
- Suggestion: Same bare-hex companion discipline as countdown.
- Status: open (process)

### Issue 3 -- Severity: suggestion
- File: README / SECURITY (selfmanaged product docs, when reviewed in that repo)
- Description: Not fully re-audited in this countdown workspace run; automatic vs pin messaging should stay aligned with automatic-checksum law if that product claims Shape A.
- Suggestion: Doc pass in selfmanaged repo on next commit-check.
- Lesson: L-11
- Status: open

## Verdict

**Revise** — Known inherited Type 0 **bugs** from the leaf origin review are fixed on selfmanaged. No domain work required. Remaining items are test/process/docs residuals, not reverse-copy.

## Chain note

Future shared Type 0 fixes should land here first, then re-specialize **timer → countdown** (requirement-bootstrap-chain / L-B2).
