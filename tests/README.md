# Tests (countdown)

POSIX `/bin/sh` CI suite for the Type 0 + domain ship unit `./countdown`.

Bootstrap architecture matches the timer Type 0 harness; this suite is specialized for `APP_NAME=countdown` and adds **countdown domain** coverage (duration + remaining time).

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `date`.

Optional override:

```sh
APP_NAME=countdown ./tests/run.sh
```

## What is covered

| Suite | File | Focus |
|-------|------|--------|
| CLI surface | `test_cli.sh` | `sh -n`, companion digest, `version` / `help` / `about` (human + JSON), domain verbs in help, unknown command, quiet, `CHECKSUM` not on help/about, `env -u HOME`, zero-arg install failure exit, uninstall fail-closed JSON |
| Install lifecycle | `test_install_lifecycle.sh` | Isolated `HOME`/`USER_BIN`, local channel install, idempotent re-install, **Type O** zero-arg already-installed (local + global, not help), version-check JSON keys, self-update already-latest, human integrity transparency, uninstall refuse / `--force`, `CHECKSUM` pin match/mismatch, downgrade refuse / `--force` |
| Countdown domain | `test_countdown_domain.sh` | `start` with duration / `stop` / `status` / `list`, `--json`, `--persist`, `kill` / `reset`, missing/invalid duration, invalid name, already-running, `no_countdown` |

## Mapping (product law)

Type 0 cases map to live `docs/requirements/requirement-shell-*.md` (CLI interface, zero-arguments, output, interactive, idempotency, self-management, automatic-checksum). Domain cases cover specialized countdown commands on top of that architecture.

## Mapping (public reviews)

Review-driven cases and open TODOs live under [`../reviews/test-plan.md`](../reviews/test-plan.md) (TP-* rows). Prior failure modes that tests should lock: [`../reviews/lessons.md`](../reviews/lessons.md).

## Network / safety

- No secrets and no root.
- Install lifecycle serves the checkout over `127.0.0.1` (does not require public raw GitHub).
- Domain tests use isolated `HOME` for persistent storage and clean volatile countdown files for the current user after the suite.
