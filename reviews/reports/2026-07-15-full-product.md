# Report: full product review — countdown v1.1.0

**Date:** 2026-07-15  
**Mode:** full product (working tree clean on main)  
**Target:** `./countdown` v1.1.0  
**Tests at review time:** PASS=138 FAIL=0  
**Companion:** hash matched `./countdown` (bare hex)  
**Scratch source:** session `grok-review-0449d13f` (ephemeral; durable copy is this file)  
**Status:** Open items remain (see below)

## Summary

Countdown is a solid Type 0 + domain CLI with careful install/checksum/uninstall behavior and a strong test suite. Dominant risks: multi-user volatile state placement, one JSON error path on stdout, dual-install version resolution, aggressive PATH cleanup on uninstall, weak JSON escape, and stop/kill success when `rm` fails.

## Issues (open)

### Issue 1 -- Severity: bug
- File: countdown:2391
- Description: already_running uses `out_json "error"` (stdout) instead of `out_json_error` (stderr).
- Suggestion: Use `out_json_error` + domain test (TP-01).
- Lesson: L-01 · Test: TP-01
- Status: open

### Issue 2 -- Severity: bug
- File: countdown:2255
- Description: Volatile files in shared `/dev/shm` or `/tmp` with name prefix only; not private per-user dir.
- Suggestion: Private dir + chmod 700 (align with util_resolve_storage pattern).
- Lesson: L-02 · Test: TP-07
- Status: open

### Issue 3 -- Severity: bug
- File: countdown:1400
- Description: `inst_get_version` prefers global over user-local for non-root.
- Suggestion: Share SSOT with install path selection.
- Lesson: L-03 · Test: TP-02
- Status: open

### Issue 4 -- Severity: bug
- File: countdown:1300
- Description: Uninstall sed deletes any `.local/bin` line.
- Suggestion: Remove blanket expression; only installer lines.
- Lesson: L-04 · Test: TP-03
- Status: open

### Issue 5 -- Severity: bug
- File: countdown:2449
- Description: stop/kill report success even when `rm` fails.
- Suggestion: Check `rm`; fail with io/permission code.
- Lesson: L-05 · Test: TP-04
- Status: open

### Issue 6 -- Severity: bug
- File: countdown:400
- Description: Weak `util_json_escape`; name denylist allows control characters.
- Suggestion: Escape controls; strict name allowlist.
- Lesson: L-06 · Test: TP-05
- Status: open

### Issue 7 -- Severity: suggestion
- File: countdown:814
- Description: wget companion only accepts `HTTP/1.1 200`.
- Lesson: L-07 · Test: TP-09
- Status: open

### Issue 8 -- Severity: suggestion
- File: countdown:2434
- Description: Non-numeric state trusted for arithmetic.
- Lesson: L-08 · Test: TP-06
- Status: open

### Issue 9 -- Severity: suggestion
- File: countdown:2389
- Description: start check-then-create race.
- Lesson: L-09
- Status: open

### Issue 10 -- Severity: suggestion
- File: countdown:2597
- Description: `timers` JSON is a string-encoded array.
- Lesson: L-10
- Status: open

### Issue 11 -- Severity: suggestion
- File: README.md:49
- Description: README presents CHECKSUM pin as Recommended above automatic companion.
- Lesson: L-11 · Test: TP-10
- Status: open

### Issue 12 -- Severity: suggestion
- File: docs/requirements/requirement-shell-cli-interface.md (Implementation Notes)
- Description: Stale VERSION note `2.9.0` vs product `1.1.0`.
- Lesson: L-12
- Status: open

### Issue 13 -- Severity: suggestion
- File: tests/test_countdown_domain.sh
- Description: Missing edge coverage for issues 1,3,4,5,8.
- Lesson: see test-plan TP-01..06
- Status: open

### Issue 14 -- Severity: nit
- File: countdown:2968
- Description: `list <name>` ignores free token.
- Lesson: L-13 · Test: TP-08
- Status: open

## Follow-up

- Update `test-plan.md` statuses as TP-* implemented.  
- Origin classification: see `2026-07-15-bootstrap-origin.md`.  
