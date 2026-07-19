# Report: bootstrap chain fix (A→B down the chain)

**Date:** 2026-07-16  
**Mode:** implement shared + domain fixes along bootstrap chain  
**Direction:** selfmanaged → timer → countdown (no reverse-copy)  
**Tests:** PASS=138 FAIL=0 after leaf fix  
**Status:** Chain shared defects patched on all hops present on disk

## Summary

Applied origin-review lessons **L-01…L-09, L-13** (and Type 0 L-03/L-04/L-06/L-07) on each hop without reverse-copying countdown onto parents. Type 0 helpers fixed on **selfmanaged**, **timer**, and **countdown**. Domain storage/JSON/stop/list fixed on **timer** and **countdown**. Companion digests regenerated.

## Hops patched

| Hop | Path | Changes |
|-----|------|---------|
| root | `…/prjs/selfmanaged/selfmanaged` | `inst_get_version` user-local prefer; PATH sed no blanket `.local/bin`; stronger `util_json_escape`; wget `HTTP/[0-9.]+ 200` |
| intermediate | `./timer` | same Type 0 + domain private volatile dir; already_running → `out_json_error`; exclusive create; integer state; rm fail-closed; list rejects free name; CR/LF name reject |
| leaf | `./countdown` | same as timer domain + Type 0; REQ Version note `1.1.0`; `countdown.sha256` updated |

## Lessons addressed

| Lesson | Fix |
|--------|-----|
| L-01 | already_running uses `out_json_error` (stderr) |
| L-02 | volatile base `${VOLATILE_DIR}/${APP_NAME}-${USERNAME}` + chmod 700 |
| L-03 | `inst_get_version` prefers USER_BIN when non-root and present |
| L-04 | removed sed `/\.local\/bin/d` |
| L-05 | stop/kill check `rm` + residual file |
| L-06 | awk-based JSON escape for `\t` `\r` multi-line |
| L-07 | wget companion accepts `HTTP/* 200` |
| L-08 | integer validation before arithmetic |
| L-09 | `set -C` exclusive create |
| L-12 | requirement Implementation Notes VERSION `1.1.0` |
| L-13 | `list` rejects free name argument |

## Reverse-copy

None. Parents patched in place; leaf specialized in place with same architectural fixes (not by overwriting timer with countdown body).

## Follow-up

- Mark TP rows in `test-plan.md` as have where covered; add remaining TODOs (dual-install, PATH seed, etc.) in a later pass.  
- Re-run origin review to reclassify residual items.  
