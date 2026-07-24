**file**: docs/requirements/requirement-domain-countdown.md  
**Requirement-ID**: `RQ-DOMAIN-COUNTDOWN`  
**Status**: Active (Version 1.0.0 – CIAO v2.10.2 Principles 1/2/5/6/9/20)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **Single Source of Truth (SSOT)** for the product’s **domain law** on the specialized shell CLI: specialized subcommands, specialized features, specialized help items, and specialized about items—beyond Type 0 install/self-management.

**SSOT rule:** For a specialized product that has a domain surface, **exactly one** Active domain-requirements file is the **current** domain SSOT (this file, for this project). Additional domain files **MUST NOT** be invented in parallel without superseding this one and updating `docs/requirements/index.md`. **Exception:** [genesis template](../terminologies/genesis-template.md) state — no specialized domain law is required (registry may be empty).

**Scope:** Domain CLI verbs, duration/remaining-time semantics, names, storage modes, domain JSON/human contracts, domain rows in `help` / `about`.  
**Out of scope (peer shell law):** Install, version-check, self-update, self-uninstall, empty-argv Type O, automatic checksum, output SSOT mechanics (`out_*` still used), modular prefix table ownership.

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Domain SSOT (portable)

| Rule | MUST |
|------|------|
| **One current SSOT** | At most one Active `requirement-*-domain*` (or project-designated domain basename) is the **current** domain law |
| **Registry** | That file has exactly one row in `docs/requirements/index.md` with Status Active while it is current |
| **Supersede** | Replacing domain law → new Status (superseded) + new Active SSOT row in the same change |
| **Genesis exception** | At genesis template: **no** domain SSOT required; empty domain is honest |
| **Post-specialize** | After bootstrap specialize adds domain on B: create/update **this** SSOT (four pillars) — term `domain-requirements` |
| **Not shell Type 0** | Domain behavior **MUST NOT** be claimed “owned” only by Type 0 lifecycle requirements |

### 2.2 Specialized CLI subcommands (portable)

Domain verbs **MUST**:

1. Be routed through the single dispatcher (`app_main` or project equivalent).  
2. Use a **domain function prefix** (not `inst_*` for product resources; not bare names).  
3. Fail closed on invalid operands with stable machine codes under `--json`.  
4. Preserve Type 0 routes (install/update/uninstall/version/about/help).  
5. Appear in help (see §2.4).

### 2.3 Specialized features (portable)

Domain law **MUST** define (when claimed):

| Topic | Requirement |
|-------|-------------|
| Resource identity | Default name; path-safe / forbidden character policy; stable `invalid_name` (or peer code) |
| Primary semantics | What the domain measures (e.g. remaining time vs elapsed); start requirements (e.g. duration) |
| Storage modes | Volatile vs persistent when both exist; isolation expectations |
| Concurrency / already active | Behavior when resource already exists (`already_running` or peer) |
| Stop / status / list / discard | Success and missing-resource codes |
| Corruption | Non-numeric or unreadable state → fail closed, not silent wrong arithmetic |
| Output | Domain messages via product output SSOT; JSON errors on stderr when product uses `out_json_error` |

### 2.4 Specialized project help items (portable)

`help` **MUST**:

1. List every domain subcommand with a one-line purpose.  
2. Document domain-only flags (e.g. persist) alongside global flags.  
3. Document domain input formats that users must know (e.g. duration grammar).  
4. Keep Type 0 self-management commands listed and accurate.  
5. Not list install integrity pin env as a public help setting when automatic-checksum law forbids it.

### 2.5 Specialized project about items (portable)

`about` **MUST**:

1. Retain Type 0 diagnostics (install presence, paths, user, shell, TTY) per self-management / CLI law.  
2. Either document **domain-specific** about fields/messages **or** state explicitly: **about domain extras: none** (Type 0 only).  
3. **MUST NOT** expose `CHECKSUM` / pin secrets in about JSON or human about.

### 2.6 Implementation Notes (this project — countdown)

| Item | Value |
|------|--------|
| **Domain SSOT file** | This file: `docs/requirements/requirement-domain-countdown.md` |
| **Product / APP_NAME** | `countdown` |
| **Ship unit** | `./countdown` |
| **Domain prefix** | `countdown_*` |
| **Bootstrap** | Specialized from timer; root origin selfmanaged — domain law applies to **leaf only** |

#### Specialized CLI subcommands (countdown)

| Command | Handler | Required behavior |
|---------|---------|-------------------|
| `start [--persist] [name] <duration>` | `countdown_start` | Start named countdown; duration **required**; default name `default`; reject invalid name/duration; `already_running` if file exists / exclusive create fails |
| `stop [name]` | `countdown_stop` | Stop and report **remaining** time; `no_countdown` if missing; fail closed on corrupt state / failed remove |
| `status [name]` | `countdown_status` | Remaining time without stopping; `no_countdown` if missing |
| `list [--persist]` | `countdown_list` | List running countdowns for mode; **no** free name operand (reject extra name) |
| `kill [name]` | `countdown_kill_or_reset kill` | Discard without remaining report |
| `reset [name]` | `countdown_kill_or_reset reset` | Discard / reset |

**Domain error codes (JSON `--json`):** include at least `invalid_name`, `missing_duration`, `invalid_duration`, `already_running`, `no_countdown`, `corrupted_data`, `io_error` as implemented. Errors use `out_json_error` (stderr).

**Global domain flag:** `--persist` → persistent storage for domain ops.

#### Specialized features (countdown)

| Feature | Law |
|---------|-----|
| **Semantics** | **Remaining time** from start+duration target (not count-up elapsed like timer) |
| **Duration grammar** | Forms such as `25m`, `90s`, `1h`, `1h30m`, `2h15m45s`, or plain seconds number; invalid/zero → `invalid_duration`; missing → `missing_duration` |
| **Names** | Default `default`; path-safe denylist (path seps, shell metachar, space/tab); CR/LF rejected; `invalid_name` |
| **Volatile storage** | Private per-user dir under volatile root (e.g. `/dev/shm/${APP_NAME}-${USERNAME}`) with restrictive mode when possible |
| **Persistent storage** | Under cache dir (e.g. XDG cache / `${HOME}/.cache/${APP_NAME}`) or private `/tmp` fallback |
| **Isolation** | Per-user; not shared flat world-writable name-only files as sole isolation |
| **vs timer** | Separate product; help may note timer is count-up, countdown is remaining-time |

#### Specialized project help items (countdown)

`help` **MUST** include (human mode):

- Section **Countdown commands** with all domain verbs above  
- **Duration formats** lines  
- Type 0 **Self-Management** block (install, version, about, version-check, self-update, self-uninstall, help)  
- Global options including `--persist`, `--quiet`, `--json`, `--force`, `--debug`  
- Environment: channel vars only (`REPO_USER`, `REPO_NAME`, `SCRIPT_URL`) — **not** `CHECKSUM`  
- Optional note that timer is a separate tool  

JSON help: short structured note (no full human dump) per CLI interface law.

#### Specialized project about items (countdown)

| Field | Law |
|-------|-----|
| Type 0 diagnostics | Install global/local, user, shell, TTY — required |
| Domain extras | **Human:** useful-commands lines for start/stop/status/list are allowed as navigation hints |
| Domain JSON fields | **No** mandatory domain-only about keys beyond Type 0 about shape unless added later in this SSOT |
| CHECKSUM | **MUST NOT** appear in about |

#### Tests / DoD (countdown)

Domain suite `tests/test_countdown_domain.sh` (via `tests/run.sh`) **MUST** cover start/stop/status/list, JSON codes for missing/invalid duration and invalid name, already-running, persist mode, kill/reset. Changes to domain behavior update this SSOT and tests in the same work item.

### 2.7 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution:** Fail closed on bad names, durations, and corrupt state.  
- **CIAO Principle 2 – Intentional:** One SSOT for domain law (not scattered shell REQs).  
- **CIAO Principle 5 – SSOT of output:** Domain messages only via `out_*`.  
- **CIAO Principle 6 – Single entry:** Domain verbs through `app_main`.  
- **CIAO Principle 9 – Command types:** Domain remains Type 0 invoker-scoped resource ops.  
- **CIAO Principle 4 / 20 – Over-protect:** Four pillars + genesis exception documented.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Validate before I/O; exclusive create for start.  
- **Intentional:** Remaining-time product story explicit vs timer.  
- **Anti-fragile:** Private storage dirs; non-interactive safe.  
- **Over-protect:** SSOT file + registry; no parallel silent domain law.  
- **SSOT:** This file is current domain law for countdown after specialize.  
- **Genesis:** At genesis, this file **MUST NOT** exist as claimed product law (wipe with specialized requirements).

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Create a second Active parallel domain requirement without superseding this SSOT and updating `index.md`.  
2. Claim Type 0 shell requirements alone own domain start/stop/duration/remaining-time law.  
3. Drop domain verbs from help while still routing them.  
4. Put domain feature law into bootstrap origin `timer` / `selfmanaged` by reverse-copy.  
5. Add `CHECKSUM` to help/about domain or Type 0 about.  
6. Leave domain SSOT hollow (`TODO` pillars) while Status Active.  
7. At **genesis template**, invent a filled domain SSOT as if a product were specialized.

**Violating this rule is a critical domain-law / SSOT regression.**

---

## 5. Definition of done (domain)

A domain change for countdown is **not done** if any fail:

1. This SSOT updated when behavior/help/about/subcommand catalog changes.  
2. `index.md` still points here as Active domain SSOT.  
3. Help lists all domain verbs; about respects §2.5.  
4. Domain tests pass (`tests/run.sh` domain section).  
5. No reverse-copy of domain law onto bootstrap A.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry; this file = current domain SSOT |
| `docs/requirements/requirement-shell-cli-interface.md` | Type 0 command surface; domain catalog owned **here** |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefix table; domain prefix `countdown_*` |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` channels |
| `docs/requirements/requirement-bootstrap-chain.md` | Leaf owns domain defects |
| `./countdown` | Implementation |
| `tests/test_countdown_domain.sh` | Domain suite |

---

## Design-time verification

**Requirement-ID:** `RQ-DOMAIN-COUNTDOWN`  
**Specialized from:** `product domain SSOT (no portable domain law mold); design aid **`PM-DOMAIN-TEST-PLAN`** → family **`TP-COUNTDOWN`** (not `TP-DOM`)`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-COUNTDOWN-01** help domain verbs/flags | `tests/test_countdown_domain.sh` | have |
| **TP-COUNTDOWN-02** start/status/list/stop + duration gates | `tests/test_countdown_domain.sh` | have |
| **TP-COUNTDOWN-03** already-running | `tests/test_countdown_domain.sh` | have |
| **TP-COUNTDOWN-04** JSON remaining | `tests/test_countdown_domain.sh` | have |
| **TP-COUNTDOWN-05** `no_countdown` | `tests/test_countdown_domain.sh` | have |
| **TP-COUNTDOWN-06** kill / reset | `tests/test_countdown_domain.sh` | have |
| **TP-COUNTDOWN-07** `invalid_name` | `tests/test_countdown_domain.sh` | have |
| **TP-STORAGE-02** `--persist` (shared dual-storage) | `tests/test_countdown_domain.sh` | have |
| **TP-STORAGE-01** volatile private-dir path (shared) | `tests/test_countdown_domain.sh` | have |
| **TP-STORAGE-03** corrupted state (shared) | `tests/test_countdown_domain.sh` | have |
| **TP-PAYLOAD-*** Type O-P scaffold | n/a — not Type O-P payload product | n/a |


**Last Updated**: 2026-07-16  
**Owner**: countdown project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer shell requirements in §6; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
