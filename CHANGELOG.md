# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [1.1.5] - 2026-09-06

### Changed
- Human `help` names empty-argv install-ensure and privilege in people words (you run these as yourself)
- JSON `help` note lists domain verbs that accept `--json` (`start`/`stop`/`status`/`list`/`kill`/`reset`), not only lifecycle verbs
- `list` help line: no name operand; use `status <name>`
- `about` useful-commands include kill/reset/install; `--json` is a flag, not a command row

### Fixed
- Help DESCRIPTION omitted kill/reset and empty-argv meaning

---

## [1.1.4] - 2026-09-06

### Changed
- README Usage lists `countdown install`; elevated one-liner is `sudo curl … | sudo sh` (help parity)
- CLI interface global flags name `--persist` (domain-owned; dual mention)

### Fixed
- **TP-STORAGE-01** fails when the private-dir file is missing (no soft-pass)
- **TP-STORAGE-03** fails closed; asserts `corrupted_data` on status **and** stop
- Domain suite covers `25m` duration, `list` extra-name reject, kill-without-remaining, Duration formats in help

---

## [1.1.3] - 2026-09-06

### Changed
- Type 0 storage is **cache folder and persistence folder** (`requirement-shell-cli-storage` / **`RQ-SHELL-CLI-STORAGE`**)
- `about` human/JSON names **Cache folder (preferred)/(fallback)** and **Persistence storage** (`${HOME}/.local/countdown`)
- Domain `--persist` writes `${HOME}/.local/countdown` (no longer `${HOME}/.cache/countdown`)
- Preferred cache leaf is `/dev/shm/cache/cache-countdown` (not `/dev/shm/countdown-<user>`)
- **TP-CLI-05** is **have** (was n/a)
- README H1 is `countdown - Lightweight per-user named countdown timers`; section order matches install/usage kit (Quick Installation includes automatic companion integrity)
- Help/about people-facing lines lead with **you run this as yourself**, not catalog codes as the only words
- `prompt_yes_no` / `prompt_ask` consume `TTY` measured at script top (no live `[ -t` policy gate inside the helpers)
- Housekeeping 2026-08: portable harness from genesis RAM; class residual records no dest approver/fences; L-10 still open

### Added
- **`RQ-SHELL-SCRIPT-CODING`** — POSIX `/bin/sh` coding-style specialize-in home (without it, portable lessons arrive raw)
- **§1.1 Human-facing** on every Active requirement
- **Under command line for normal user only** on related shell requirements
- Dual mention: domain verbs named on `RQ-SHELL-CLI-INTERFACE` and `RQ-DOMAIN-COUNTDOWN` with invocation samples

### Fixed
- Requirement law no longer described durable persist as a cache-only path

### Security
- Regenerated `countdown.sha256` for **1.1.3**

---

## [1.1.2] - 2026-07-24

### Fixed
- `countdown_status` validates numeric state fields before arithmetic (corrupted state → `corrupted_data`, no dash "Illegal number")

### Changed
- Aligned product Requirement-IDs (`RQ-*`) and suite TP-IDs with harness ID notation; each live requirement has Design-time verification
- Domain SSOT renamed to `requirement-domain-countdown` / **`RQ-DOMAIN-COUNTDOWN`**; product domain family **`TP-COUNTDOWN-01..10`**
- Expanded CI suite: TP-labeled CLI/lifecycle parity, local-channel TP-CURL suite, domain TP-COUNTDOWN coverage (198 PASS / 0 FAIL / 1 SKIP optional online)
- Product maps: `reviews/test-plan.md`, `reviews/requirement-test-matrix.md`
- Registered class law `requirement-class-software-dev` / **`RQ-CLASS-SOFTWARE-DEV`**
- Harness H2 from genesis: law/proof molds under `docs/templates/requirements/` and `docs/templates/tests/` (local); ID-notation policies/skills/terms

### Security
- Regenerated `countdown.sha256` for **1.1.2**

---

## [1.1.1] - 2026-07-19

### Fixed
- JSON `already_running` and related domain errors emit on stderr via `out_json_error` (stdout stays clean for pipelines)
- Per-user private volatile/persist storage under `/dev/shm` and `/tmp` (no flat world-writable files)
- `inst_get_version` prefers user-local install when present (non-root)
- PATH cleanup no longer blanket-deletes unrelated `.local/bin` lines
- Exclusive countdown create (`set -C`) and fail-closed remove on stop/kill
- Stronger JSON escape (controls/newlines); reject CR/LF in countdown names
- wget companion-digest HTTP status match accepts HTTP/1.x family
- `list` rejects free name tokens (use `status <name>`)
- Non-numeric countdown state fails closed as corrupted data

### Changed
- Documented **domain SSOT** (`requirement-shell-domain`) and **bootstrap chain** product law
- README integrity section leads with **automatic** companion verification; explicit `CHECKSUM` pin is Advanced/CI
- Author-email SSOT aligned to `wilgat.wong@gmail.com` (LICENSE / SECURITY / README / ship unit)
- Public `reviews/` surface (plans, lessons, hop reports) for product and bootstrap chain

### Security
- Regenerated `countdown.sha256` for **1.1.1**

---

## [1.1.0] - 2026-07-14

### Added
- Full Type 0 self-management surface from the **timer** bootstrap architecture: `install`, `version-check`, `self-update`, `self-uninstall`, `about`, empty-argv install-ensure
- Automatic companion-digest verification (`countdown.sha256` / `${SCRIPT_URL}.sha256`) aligned with timer Type 0 pattern
- Domain duration helpers (`countdown_parse_duration`, `countdown_looks_like_duration`) under `countdown_*` prefix
- Local test suite (`tests/`) specialized for countdown

### Changed
- Ship unit rebuilt as bootstrap specialize **timer (A) → countdown (B)** — same `out_*` / `inst_*` / `app_*` structure as timer, while keeping countdown domain CLI
- Product identity SSOT: `APP_NAME=countdown`, `REPO_NAME=countdown`, channel `https://raw.githubusercontent.com/Wilgat/countdown/main/countdown`
- Version **1.1.0** (minor line after 1.0.4: architecture bootstrap refresh + preserved countdown domain semantics)
- README / requirements Implementation Notes retargeted to countdown

### Preserved (domain oracle: classic countdown 1.0.4)
- Named countdowns with required human duration on `start`
- Remaining-time `status` / `stop` (not count-up elapsed)
- Volatile + `--persist` storage with fallbacks
- JSON codes such as `missing_duration`, `invalid_duration`, `no_countdown`, `already_running`

### Security
- Regenerated `countdown.sha256` for the refreshed ship unit

---

## [1.0.4] - 2026-04-22

### Added
- 

### Changed
- Update prompt_yes_no

### Fixed
- 

---

## [1.0.3] - 2026-04-20

### Added
- **Cryptographic verification** for downloads in `perform_self_install_v2()`
  - Support for explicit `CHECKSUM=...` environment variable (recommended for CI/CD)
  - Automatic verification using `countdown.sha256` sidecar file when available
  - Loud failure with clear security message on checksum mismatch
- New security section in README.md documenting verified installation
- Updated badges in README.md (CIAO philosophy, Grok Reviewed, etc.)

### Changed
- Improved `perform_self_install_v2()` with layered checksum protection while maintaining full backward compatibility
- Updated version to 1.0.3
- Enhanced documentation for security-conscious users

### Security
- Significantly reduced supply-chain risk for the `curl | sh` installation method

---

## [1.0.2] - 2026-04

### Added
- Full Grok security review section in README.md
- Improved shell detection in `show_about_pomo()`
- Better JSON output consistency
- Enhanced defensive comments and protection zones

### Changed
- Refined output functions and error handling
- Updated installation and self-update logic
- Improved fallback handling for storage directories

---

## [1.0.1] - 2026-04

### Initial Release
- First public version of `countdown`
- Core features: named countdown timers (volatile + persistent)
- Per-user isolation with smart storage fallbacks
- Support for `--persist`, `--quiet`, `--json`
- Self-install, self-update, and diagnostics (`about`)
- Full POSIX compatibility (`sh`, `dash`, `ash`, Git Bash)
- Strong defensive design following CIAO principles

---

## Philosophy

This project follows **CIAO** principles:
- **C**aution
- **I**ntentional
- **A**nti-fragile
- **O**ver-protect

Changes are kept surgical and minimal. Protection zones are respected to maintain robustness in harsh environments.

---

## Links

- Repository: https://github.com/Wilgat/countdown
- Related project: [ciao](https://github.com/cloudgen/ciao)

*Made with care and a healthy dose of paranoia.*