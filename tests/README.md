# Tests (countdown)

POSIX `/bin/sh` CI suite for the Type 0 + domain ship unit `./countdown`.

Bootstrap architecture matches the timer Type 0 harness; this suite is specialized for `APP_NAME=countdown` and adds **countdown domain** coverage (duration + remaining time).

**Proof molds → product map:** `reviews/test-plan.md`  
**Requirement ↔ test matrix:** `reviews/requirement-test-matrix.md`  
**Umbrella mold:** `PM-SHELL-CLI-SUITE-TEST-PLAN`

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `date`.

Optional override:

```sh
APP_NAME=countdown ./tests/run.sh
```

Optional public online curl smoke:

```sh
RUN_ONLINE_CURL_TESTS=1 ./tests/run.sh
```

## What is covered

| Suite | File | TP families | Focus |
|-------|------|-------------|--------|
| CLI surface | `test_cli.sh` | **TP-CLI**, **TP-CSUM-01/05**, **TP-U-01/02** | `sh -n`, companion digest, version/help/about (cache + persistence folders), unknown command, quiet, zero-arg fail, uninstall refuse, `out_json` string keys |
| Install lifecycle | `test_install_lifecycle.sh` | **TP-LC**, **TP-CSUM-02..04** | isolated channel install, Type O zero-arg, version-check, self-update, uninstall, pin match/mismatch, downgrade |
| Online curl\|sh | `test_online_curl_install.sh` | **TP-CURL** | local-channel pipe install, second pipe, unreachable URL, hostile HOME |
| Countdown domain | `test_countdown_domain.sh` | **TP-COUNTDOWN-01..07**, **TP-STORAGE-01..03** | duration start, remaining status/stop, already-running, JSON, persist, private-dir storage, corrupted state |

## Mapping (product law)

| Requirement-ID | Primary TP families |
|----------------|---------------------|
| `RQ-SHELL-CLI-INTERFACE` | TP-CLI-* |
| `RQ-SHELL-CLI-STORAGE` | TP-CLI-05, TP-STORAGE-02 |
| `RQ-SHELL-CLI-ZERO-ARGUMENTS` | TP-CLI-09, TP-LC-01, TP-CURL-02/03/08 |
| `RQ-SHELL-OUTPUT-REQUIREMENTS` | TP-CLI-02/04/06/07/12, TP-COUNTDOWN-04 |
| `RQ-SHELL-AUTOMATIC-CHECKSUM` | TP-CSUM-* |
| `RQ-SHELL-SELF-MANAGEMENT` | TP-LC-*, TP-CLI-11 |
| `RQ-SHELL-IDEMPOTENCY` | TP-LC-01/05/10, TP-CURL-03 |
| `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` | TP-CLI-07/11, TP-CURL-02/03 |
| `RQ-DOMAIN-COUNTDOWN` | **TP-COUNTDOWN-01..07**, **TP-STORAGE-01..03** |
| `RQ-SHELL-SCRIPT-CODING` | TP-CLI-01 |
| `RQ-CLASS-SOFTWARE-DEV` | TP-CLASS-01 + suite green |

Primary citation: **TP-*** / **RQ-*** (policy-harness-id-notation). Paths secondary.

## Network / safety

- No secrets and no root.
- Install lifecycle and curl suites serve the checkout over `127.0.0.1` (does not require public raw GitHub).
- Domain tests use isolated `HOME` for the **persistence folder** (`~/.local/countdown`) and clean private volatile countdown dirs for the current user after the suite. Type 0 **TP-CLI-05** proves `about` names cache folder **and** persistence folder.
