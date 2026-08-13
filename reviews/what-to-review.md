# What to review (countdown)

Living checklist for product and bootstrap-origin reviews.  
**Always** re-check items in [`lessons.md`](./lessons.md) (prior report regressions).

**Ship unit:** `./countdown`  
**Immediate bootstrap (local reference, may be gitignored):** `./timer` when present  
**Root origin (external sibling):** selfmanaged Type 0 baseline when available  
**Tests:** `./tests/run.sh`  
**Law:** `docs/requirements/index.md` + live `requirement-*.md`

---

## 0. Pre-flight (every review)

- [ ] Working tree / scope named (full product / local diff / origin hop / PR)  
- [ ] Version SSOTs consistent (script `VERSION`, README badge, CHANGELOG)  
- [ ] `countdown.sha256` matches `./countdown` bytes (bare hex companion)  
- [ ] `./tests/run.sh` baseline known (or run before claiming clean)  
- [ ] Load **lessons.md** and re-verify each **Must re-check** item  
- [ ] Bootstrap direction: A→B only (`requirement-bootstrap-chain`)  

---

## 1. Product law and surfaces

| Surface | Review focus | Requirement keys (when Active) |
|---------|--------------|--------------------------------|
| CLI dispatch / flags | Commands, `--json` / `--quiet` / `--force` / `--persist`, unknown cmd | `requirement-shell-cli-interface` |
| Type O empty argv | Install-ensure not help; local/global already-installed | `requirement-shell-cli-zero-arguments` |
| Output SSOT | All messages via `out_*`; errors not on success stdout JSON | `requirement-shell-output-requirements` |
| Self-management | version-check, self-update, self-uninstall, about | `requirement-shell-self-management` |
| Integrity | Automatic companion + optional pin; human link/value/result | `requirement-shell-automatic-checksum` |
| Interactive vs non-interactive | No hang; fail-closed uninstall without force | `requirement-shell-interactive-vs-noninteractive` |
| Idempotency | Re-install / already-latest / uninstall no-op | `requirement-shell-idempotency` |
| Modular design | Prefixes, Protection Zones, no bare helpers | `requirement-shell-modular-function-design` |
| Bootstrap chain | Hop table honesty; no reverse-copy | `requirement-bootstrap-chain` |
| Domain | start/stop/status/list/kill/reset, duration, storage modes | `requirement-domain-countdown` |
| README / SECURITY | Install one-liner truth; pin secondary to automatic | product docs |
| Tests | Suite maps to law + domain edges | `tests/` + this folder’s test-plan |

---

## 2. High-risk code paths (Type 0)

- [ ] `inst_get_version` vs install/uninstall path SSOT (user-local vs global)  
- [ ] `inst_self_uninstall_cleanup_path` does **not** blanket-delete `.local/bin` lines  
- [ ] `util_json_escape` escapes controls (`\n` `\r` `\t`) not only `\` `"`  
- [ ] Companion fetch: curl `%{http_code}` and wget not limited to `HTTP/1.1 200` only  
- [ ] CHECKSUM mismatch fail-closed; missing sidecar policy honest  
- [ ] Non-interactive self-uninstall without `--force` does not fake success  

---

## 3. High-risk code paths (domain)

- [ ] already_running / domain errors use `out_json_error` (stderr), not `out_json "error"` (stdout)  
- [ ] Volatile storage under private per-user dir (`chmod 700`), not shared `/dev/shm` flat files only  
- [ ] `stop` / `kill` / `reset` check `rm` status before success  
- [ ] State fields validated as integers before arithmetic  
- [ ] Name allowlist/denylist blocks control characters and path metacharacters  
- [ ] start uses exclusive create or equivalent (no silent last-writer-wins)  
- [ ] `list` JSON contract documented or true array; free token after `list` defined  

---

## 4. Bootstrap origin (when reviewing A)

- [ ] Name hop: immediate (`timer`) vs root (`selfmanaged`)  
- [ ] Use latest leaf report + this folder’s lessons  
- [ ] Classify each leaf finding: inherited / fixed on A / domain-only B / reverse-copy risk  
- [ ] Evidence on A path:line for every `inherited_on_A`  
- [ ] No reverse-copy plan  

---

## 5. Test plan gate

- [ ] Every **bug** in open reports has a row in [`test-plan.md`](./test-plan.md)  
- [ ] Implemented cases exist under `tests/` or are explicitly **TODO** with owner  
- [ ] Closing a review item updates test-plan status and preferably adds CI coverage  

---

## 6. Publish run

- [ ] Write `reports/YYYY-MM-DD-<scope>.md`  
- [ ] Update `index.md`  
- [ ] Fold new durable modes into `lessons.md`  
- [ ] Keep scratch `/tmp/grok-*` out of git  
