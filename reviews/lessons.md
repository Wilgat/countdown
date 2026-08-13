# Lessons from prior review reports (regression prevention)

Durable failure modes extracted from committed runs under [`reports/`](./reports/).  
Agents doing any product or origin review **MUST** re-check these points even if the current diff looks unrelated.

**Sources:**

- `reports/2026-07-15-full-product.md` (countdown leaf, pre-fix)  
- `reports/2026-07-15-bootstrap-origin.md` (timer immediate + selfmanaged Type 0 notes)  
- `reports/2026-07-16-bootstrap-chain-fix.md` (chain implement)  
- `reports/2026-07-16-selfmanaged.md` · `reports/2026-07-16-timer.md` · `reports/2026-07-16-countdown.md` (per-hop post-fix)  

---

## Must re-check (bugs)

| ID | Lesson | Why it returns | Re-check |
|----|--------|----------------|----------|
| L-01 | Domain/install **errors in JSON mode must use stderr** (`out_json_error`), never `out_json "error"` on stdout | Easy to copy a “rich” success emitter for errors | already_running / invalid_* / no_* paths |
| L-02 | **Per-user isolation** for volatile state requires a **private directory** (`chmod 700`), not only a username prefix in a world-writable `/dev/shm` or `/tmp` | Prefix-only feels isolated; sticky-bit + umask still leak/squat | domain resolve base dir vs `util_resolve_storage` |
| L-03 | **`inst_get_version` must share SSOT** with install/uninstall path selection (non-root: prefer user-local when present) | Global-first “works” on single-install machines; dual-install skews update | version-check / self-update path |
| L-04 | Uninstall PATH cleanup must **not** `sed` delete every line matching `.local/bin` | Over-broad cleanup “helps” empty USER_BIN but wrecks cargo/pipx/nvm | `inst_self_uninstall_cleanup_path` |
| L-05 | **`rm` failure is not success** for stop/kill/reset | Ignoring `rm` status looks green while state remains | domain stop/kill |
| L-06 | **`util_json_escape` must handle controls** (`\n` `\r` `\t` at minimum); name policy must not allow raw newlines | Escaping only `\` `"` is a common incomplete helper | escape helper + sanitize name |

---

## Must re-check (suggestions / quality)

| ID | Lesson | Re-check |
|----|--------|----------|
| L-07 | wget companion success must not require only the string `HTTP/1.1 200` | HTTP/2 / 1.0 CDNs |
| L-08 | State file integers must be validated before `$((…))` | corrupt / hostile content — **status** path closed 2026-07-24 (TP-COUNTDOWN-10); keep stop/list parity |
| L-09 | Domain start should use exclusive create (avoid TOCTOU last-writer-wins) | concurrent start |
| L-10 | Nested JSON list fields: document string-encoded array or emit real arrays | `list --json` |
| L-11 | README: automatic companion one-liner is default; `CHECKSUM=` pin is advanced/CI | install docs order — **closed** 2026-07-16; pin value re-aligned to current companion on 2026-08-13 |
| L-12 | Requirement Implementation Notes VERSION must match ship unit VERSION | registry drift |
| L-13 | Free tokens after `list` must filter or be rejected | CLI UX honesty |

---

## Bootstrap chain lessons

| ID | Lesson |
|----|--------|
| L-B1 | Many leaf findings are **inherited** on immediate origin (`timer`) and Type 0 subset on **selfmanaged** — classify before fixing only the leaf |
| L-B2 | Fix order: responsible **ancestor first**, then re-specialize **down** the chain — never reverse-copy countdown onto timer/selfmanaged |
| L-B3 | Default origin-review hop for countdown reports: **timer**; optional second hop: **selfmanaged** |

---

## How to add a lesson

1. After a new `reports/*.md` run, extract failure modes that could recur.  
2. Add a row with stable **L-** id.  
3. Link a **TP-** row in `test-plan.md` when automation is possible.  
4. Mention the lesson id in the report’s summary if it motivated the run.  
