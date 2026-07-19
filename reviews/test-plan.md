# Review-driven test plan (countdown)

Maps **open review findings** and **prior-report lessons** to automated cases under [`tests/`](../tests/).  
Status: **have** = covered by suite today · **TODO** = required to lock the finding · **n/a** = not automatable as unit CI (note manual).

Runner: `./tests/run.sh`

---

## 1. Existing coverage (baseline)

| Area | Suite | Status |
|------|-------|--------|
| Syntax + companion hash | `test_cli.sh` | have |
| version / help / about human+JSON | `test_cli.sh` | have |
| CHECKSUM not on help/about | `test_cli.sh` | have |
| Unknown command + JSON error type | `test_cli.sh` | have |
| Type O zero-arg / uninstall fail-closed | `test_cli.sh` + `test_install_lifecycle.sh` | have |
| Install lifecycle, pin match/mismatch, downgrade | `test_install_lifecycle.sh` | have |
| Domain start/stop/status/list/persist/json | `test_countdown_domain.sh` | have |
| Domain invalid name / missing duration / already-running exit | `test_countdown_domain.sh` | have |

---

## 2. Required cases from prior reports (lock-in)

Source reports: `reports/2026-07-15-full-product.md`, `reports/2026-07-15-bootstrap-origin.md`, `lessons.md`.

| ID | Finding (short) | Desired automated check | Suite target | Status |
|----|-----------------|-------------------------|--------------|--------|
| TP-01 | already_running JSON on **stderr** not stdout | `--json start` twice; assert stdout empty or non-error; stderr has `"type":"error"` + `already_running` | `test_countdown_domain.sh` | **TODO** (code fixed 2026-07-16; assert still thin) |
| TP-02 | Dual install: version prefers user-local for non-root | Populate fake GLOBAL_BIN + USER_BIN with different VERSION; `version-check` / `inst_get_version` path reports USER | `test_install_lifecycle.sh` | **TODO** (code fixed 2026-07-16) |
| TP-03 | Uninstall PATH cleanup does not strip unrelated `.local/bin` | Seed bashrc with cargo-like PATH line + installer block; uninstall empty USER_BIN; cargo line remains | `test_install_lifecycle.sh` | **TODO** (code fixed 2026-07-16) |
| TP-04 | stop/kill fail when `rm` fails | Create state file not owned / chmod a-w dir if portable; expect non-zero + error code (skip if cannot simulate) | `test_countdown_domain.sh` | **TODO** (code fixed 2026-07-16) |
| TP-05 | JSON escape / name with newline rejected or escaped | Start with name containing newline (if argv allows) or message path; JSON remains single-line valid | `test_countdown_domain.sh` | **TODO** (code fixed 2026-07-16) |
| TP-06 | Corrupted state file → clean error | Write non-numeric state; status/stop → non-zero + stable code | `test_countdown_domain.sh` | **TODO** (code fixed 2026-07-16) |
| TP-07 | Volatile private directory | After start, state file lives under per-user private dir (not only flat `/dev/shm/countdown_user_name` if policy requires private dir) | `test_countdown_domain.sh` | **TODO** (code fixed 2026-07-16) |
| TP-08 | list extra operand | `list work` either filters or rejects; documented | `test_countdown_domain.sh` | **TODO** (code rejects free name 2026-07-16) |
| TP-09 | Companion wget HTTP/2 (optional) | Hard to unit without mock; document manual / integration | — | n/a manual |
| TP-10 | README pin not primary | Doc review only (or grep README order in commit-check) | manual / commit-check | n/a doc |

---

## 3. Bootstrap origin regression (when timer in tree)

When `./timer` is available for local origin work (may be gitignored on this product repo):

| ID | Check | Status |
|----|-------|--------|
| TP-A1 | Same TP-01 pattern on `timer` already_running JSON channel | TODO on timer suite |
| TP-A2 | Type 0 TP-02/TP-03 on timer or selfmanaged before re-specialize | TODO on origin product |

Do **not** reverse-copy countdown tests onto timer as a substitute for fixing timer then re-specializing.

---

## 4. Definition of done for “review item closed”

A finding is **closed** only when:

1. Code/docs fixed (or explicitly deferred with rationale in `index.md`).  
2. Matching **TP-** row is **have** (or n/a with justification).  
3. `./tests/run.sh` passes.  
4. `lessons.md` updated if the failure mode is new.  
