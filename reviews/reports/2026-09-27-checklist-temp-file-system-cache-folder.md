# Filled run: CL-TEMP-FILE-SYSTEM — countdown 1.1.7 cache folder

**Date:** 2026-09-27  
**Blank form:** `docs/templates/checklists/checklist-temp-file-system.md`  
**Product:** countdown (`./countdown`)  
**Change type:** fix  
**Related law:** `requirement-shell-cli-storage` **1.2.0**  
**Proof:** **TP-CLI-05** · **TP-STORAGE-04** · **TP-STORAGE-05** (`tests/test_cli.sh`, `tests/test_countdown_domain.sh`)

## Verdict

- [x] **Pass** — per-login per-process cache directory; mktemp files; silent tier miss; cleanup
- [ ] **Revise**
- [ ] **Block**

Reviewer / role: Implement + Review (this change)  
Date: 2026-09-27

## 1. Leaves (blocking)

- [x] Scratch created with `mktemp` under `${TMPDIR}` (after storage resolve)
- [x] `mkdir` of one cache tier is fail-soft and silent (**TP-CLI-05** skip of preferred: no `fallback` text, no `Cannot create cache`, live path is the 1st fallback)
- [x] Linux: `/dev/shm/cache/cache-${APP_NAME}-${login}-$$`, then `/tmp/cache/...`, then `${HOME}/.cache/cache-${APP_NAME}-$$` (**TP-CLI-05**)
- [x] Git Bash: `/tmp/cache/cache-${APP_NAME}-${login}-$$`, then `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$`. No 2nd fallback line (**TP-CLI-05**)
- [x] Mac: `/tmp/cache/...`, then `${HOME}/Library/Caches/cache-${APP_NAME}-$$`, then `${HOME}/cache/cache-${APP_NAME}-$$` (**TP-CLI-05**)
- [x] Cache directory may end in `-$$`. Scratch files stay `mktemp` (`mktemp -t` uses `XXXXXX`, not `${APP_NAME}.$$`)
- [x] `ps -p $$` is a shell-name probe, not a cache path
- [x] `mktemp` failure stays fail-closed (install returns an error; the resolver dies only when no tier can be claimed)
- [x] Chosen leaf mode **0700** (**TP-STORAGE-04**). Live path is not `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${login}`

## 2. Cleanup

- [x] Success path removes install scratch after the atomic move
- [x] Fatal helpers still `exit 1` only when every cache tier failed
- [x] Re-run does not reuse another process’s leaf (`$$` is this process)

## 3. Root vs leaf

- [x] Root still from `util_resolve_storage`. No second chain
- [x] `TMPDIR` exported to the chosen cache directory (`app_main`)

## 4. Proof

- [x] **TP-CLI-05** human labels: Cache folder used, preferred, 1st fallback, 2nd fallback, Persistence storage
- [x] **TP-CLI-05** Linux, Git Bash, and Mac chains; silent skip
- [x] **TP-STORAGE-04** mode 0700; persistence `${HOME}/.local/${APP_NAME}`
- [x] **TP-STORAGE-05** `--persist` state is not under a cache tree

## Scope

| Field | Value |
|-------|--------|
| Script / ship unit | `./countdown` 1.1.7 |
| Related requirement | `requirement-shell-cli-storage` 1.2.0 |
| Change type | fix |
