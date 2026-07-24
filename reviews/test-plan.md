# Review-driven test plan (countdown)

Maps **portable TP families** (proof molds) to product-root `tests/`.  
Status: **have** = covered by suite today · **n/a** = not applicable · **optional** = behind flag.

Runner: `./tests/run.sh`  
**RTM:** `reviews/requirement-test-matrix.md`

**Proof molds (cite by PM-ID):**

| Family | Proof mold-ID | Suite file |
|--------|---------------|------------|
| **TP-CLI** | `PM-SHELL-CLI-TEST-PLAN` | `tests/test_cli.sh` |
| **TP-LC** | `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `tests/test_install_lifecycle.sh` |
| **TP-CSUM** | `PM-CHECKSUM-TEST-PLAN` | CLI + lifecycle |
| **TP-U** | `PM-SET-U-TEST-PLAN` | CLI + curl (partial) |
| **TP-CURL** | `PM-ONLINE-CURL-INSTALL-TEST-PLAN` | `tests/test_online_curl_install.sh` |
| **TP-COUNTDOWN** | `PM-DOMAIN-TEST-PLAN` (specialize) | `tests/test_countdown_domain.sh` |
| Umbrella | `PM-SHELL-CLI-SUITE-TEST-PLAN` | `tests/run.sh` |
| RTM mold | `PM-REQUIREMENT-TEST-TRACEABILITY` | `reviews/requirement-test-matrix.md` |

---

## TP-CLI — CLI surface (`PM-SHELL-CLI-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CLI-01** | `sh -n` + companion digest | **have** | `test_cli.sh` |
| **TP-CLI-02** | version human + JSON | **have** | `test_cli.sh` |
| **TP-CLI-03** | help Type 0 + domain rows; no CHECKSUM | **have** | `test_cli.sh` |
| **TP-CLI-04** | help/about JSON purity | **have** | `test_cli.sh` |
| **TP-CLI-05** | shell storage about fields | **n/a** | domain owns storage (**TP-COUNTDOWN-09**) |
| **TP-CLI-06** | unknown command + JSON error | **have** | `test_cli.sh` |
| **TP-CLI-07** | quiet / `-q` | **have** | `test_cli.sh` |
| **TP-CLI-08** | `env -u HOME` under set -u | **have** | with **TP-U-01** |
| **TP-CLI-09** | zero-arg bad channel | **have** | with **TP-LC-09** / **TP-U-02** |
| **TP-CLI-10** | bashrc+sdkman | **n/a** | no sdkman source path |
| **TP-CLI-11** | self-uninstall refuse JSON | **have** | `test_cli.sh` |
| **TP-CLI-12** | `out_json` string keys | **have** | string-escape contract; `@` raw n/a |

---

## TP-LC — Install lifecycle (`PM-INSTALL-LIFECYCLE-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-LC-01** | zero-arg ensure first + already local/global | **have** | `test_install_lifecycle.sh` |
| **TP-LC-04** | about + version-check JSON keys | **have** | lifecycle |
| **TP-LC-05** | self-update already-latest | **have** | lifecycle |
| **TP-LC-05b** | self-update when remote newer | **have** | lifecycle |
| **TP-LC-06** | force reinstall companion transparency | **have** | with **TP-CSUM-02** |
| **TP-LC-07** | uninstall refuse / force + PATH cleanup | **have** | lifecycle |
| **TP-LC-08** | downgrade refuse / force | **have** | lifecycle |
| **TP-LC-09** | zero-arg fail loud | **have** | CLI suite |
| **TP-LC-10** | idempotent re-install | **have** | lifecycle |
| **TP-LC-11** | version-check network failure | **have** | lifecycle |
| **TP-LC-12** | explicit `install --json` | **have** | lifecycle |

---

## TP-CSUM — Checksum (`PM-CHECKSUM-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CSUM-01** | companion matches ship unit | **have** | CLI |
| **TP-CSUM-02** | human force reinstall transparency | **have** | lifecycle |
| **TP-CSUM-03** | pin mismatch aborts | **have** | lifecycle |
| **TP-CSUM-04** | pin match installs | **have** | lifecycle |
| **TP-CSUM-05** | help/about hide CHECKSUM | **have** | CLI |

---

## TP-U — set -u (`PM-SET-U-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-U-01** | HOME unset | **have** | TP-CLI-08 |
| **TP-U-02** | Defaults on zero-arg fail path | **have** | TP-CLI-09 |
| **TP-U-03** | HOME with bashrc stub | **have** | TP-CURL-04 |
| **TP-U-04** | bashrc via pipe | **n/a** / partial | product does not source bashrc on pipe |
| **TP-U-05** | Safe external source helper | **n/a** | no bare product sdkman source path |

---

## TP-CURL — curl\|sh (`PM-ONLINE-CURL-INSTALL-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CURL-01** | Channel probe | **have** | local HTTP ship + companion |
| **TP-CURL-02** | First `curl \| sh` | **have** | binary at USER_BIN; not silent |
| **TP-CURL-03** | Second pipe | **have** | already-installed messaging |
| **TP-CURL-04** | Hostile HOME / bashrc | **have** | version under stub bashrc |
| **TP-CURL-05** | Bad URL curl | **have** | not silent |
| **TP-CURL-06** | curl\|sh when bash required | **n/a** | product supports `/bin/sh` |
| **TP-CURL-07** | `sh -s -- version` | **have** | pipe version |
| **TP-CURL-08** | Unreachable SCRIPT_URL | **have** | non-zero; no binary |
| **TP-CURL-09** | Public online channel | **optional** | `RUN_ONLINE_CURL_TESTS=1` |

---

## TP-COUNTDOWN — Domain-subject family (`RQ-DOMAIN-COUNTDOWN`)

Domain product cases use **`TP-COUNTDOWN-*`** (subject = `countdown`), **not** portable **`TP-DOM-*`**.  
Proof mold **`PM-DOMAIN-TEST-PLAN`** is a design aid only.  
Policy: `policy-harness-id-notation` §5.

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-COUNTDOWN-01** | Help lists domain verbs/flags | **have** | start/stop/status/list/kill/reset/--persist |
| **TP-COUNTDOWN-02** | start / status / list / stop + duration gates | **have** | missing/invalid duration |
| **TP-COUNTDOWN-03** | already-running (+ JSON channel) | **have** | domain suite |
| **TP-COUNTDOWN-04** | JSON start/status/list/stop remaining | **have** | domain suite |
| **TP-COUNTDOWN-05** | `no_countdown` error code | **have** | domain suite |
| **TP-COUNTDOWN-06** | kill / reset | **have** | domain suite |
| **TP-COUNTDOWN-07** | `invalid_name` | **have** | domain suite |
| **TP-COUNTDOWN-08** | `--persist` start/list/stop | **have** | domain suite |
| **TP-COUNTDOWN-09** | Volatile **private dir** storage | **have** | `/dev/shm|tmp/${APP}-${USER}/…` |
| **TP-COUNTDOWN-10** | Corrupted state → `corrupted_data` | **have** | domain suite |
| **TP-PAYLOAD-*** | Type O-P payload scaffold (mold) | **n/a** | not a Type O-P payload product |

**Legacy map (retired):** review-local `TP-01..10` → portable families above; product domain family is **`TP-COUNTDOWN-*`** only.

---

## Static proof (finding lock-in)

| TP-ID | Intent | Status | Notes |
|-------|--------|--------|-------|
| **TP-CLASS-01** | Active class REQ registered | **have** | `RQ-CLASS-SOFTWARE-DEV` |
| **TP-CITE-01** | Ship unit ALIGNMENT cites live REQs | **have** | header comments |
| **TP-ID-01** | `APP_NAME` hard-assign / Config SSOT | **have** | ship unit |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have** (or supersedes with a new test).  
2. Do not mark TP **have** without a suite assertion (or documented static fix).  
3. Domain product: keep domain suite green.  
4. Primary citation uses **TP-IDs** / **RQ-***; suite path secondary (policy-harness-id-notation).  
5. Versioned requirements list TP + `tests/*` + `reviews/*` only — never `docs/templates/**`.  
