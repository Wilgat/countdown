**file**: docs/requirements/requirement-shell-cli-storage.md  
**Requirement-ID**: `RQ-SHELL-CLI-STORAGE`  
**Status**: Active (Version 1.0.0 – cache folder **and** persistence folder)  
**Area**: shell  
**Key**: `requirement-shell-cli-storage`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **Single Source of Truth** for Type 0 shell CLI **storage** on countdown. **Storage** means **two** classes, not one:

| Class | Role | Product path |
|-------|------|--------------|
| **Cache folder** | Volatile scratch / temps / staging | Preferred `/dev/shm/cache/cache-countdown`; fallback `${XDG_CACHE_HOME}/cache-countdown` |
| **Persistence folder** | Durable per-user app data | `${HOME}/.local/countdown` |

It owns path **shapes**, central resolvers, `app_main` wire, and `about` diagnostics for both classes.

**Scope:** Cache resolve, persistence resolve, isolation, create-before-return, about labels.  
**Out of scope:** Install binary placement (`${HOME}/.local/bin` / `USER_BIN`); Type 1 `/var/…` deposit; domain remaining-time verbs (peer `requirement-domain-countdown`); full `mktemp` leaf policy.

### 1.1 Human-facing

**In one sentence:** You run `countdown about` to see this login’s **cache folder** (scratch that can go away) **and** **persistence folder** (durable files that survive reboot).

| You | The other role | Not this |
|-----|----------------|----------|
| A normal login who installs and runs `countdown` | Maintainers who keep both folder classes honest | A dest approval machine or inbound request queue |

**Includes:** preferred cache under `/dev/shm/cache/`, fallback cache under XDG, persistence under `${HOME}/.local/countdown`.  
**Excludes:** treating `${HOME}/.local/bin` as persistence; storing `--persist` countdown state in the cache folder; inventing a second scratch dump beside the resolver.

| Surface | What you open | What for |
|---------|---------------|----------|
| `./countdown` | program file people install | live resolve + `about` |
| `countdown about` | command | cache folder + persistence folder lines |
| `countdown --json about` | command | `cache_preferred` / `cache_fallback` / `persistence_storage` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| See both folders | About must name **cache folder** and **persistence folder**. Cache is scratch. Persistence is durable. Missing the persistence line is incomplete. | `countdown about` |
| Keep a countdown across reboot | Domain `--persist` writes into the **persistence folder**, not the cache folder. | `countdown start --persist pomodoro 25m` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Two storage classes

1. Shell CLI **storage** **MUST** mean **cache folder and persistence folder**. Naming only a cache path is incomplete.  
2. Callers that need a scratch/cache root **MUST** use the central cache resolver (or `mktemp` under a root it returned).  
3. Durable per-user app data **MUST** use the persistence folder.  
4. The resolver **MUST** return a path via **stdout for capture** (`$(util_resolve_storage)` / `$(util_resolve_persistent_storage)`) — that write is a **data return**, not product UI.  
5. User-visible storage warnings/errors **MUST** go through the product **output SSOT** (`out_*`).

### 2.2 Cache folder (portable shape; product values in §2.6)

Portable family (first match that exists **and** is writable):

```text
1. RAM cache (preferred)   /dev/shm/cache/cache-<APP_NAME>
2. System temp cache       /tmp/cache/cache-<APP_NAME>
3. User cache fallback     ${XDG_CACHE_HOME}/cache-<APP_NAME>
else fail loud via output SSOT — do not invent world-writable shared dumps
```

**MUST NOT** use `/dev/shm/<APP_NAME>` or `/dev/shm/<APP_NAME>-<USERNAME>` as the **cache** folder — those look like ram-drive project folders (domain volatile may use a private per-user dir; that is **not** the Type 0 cache folder).

Create `/dev/shm/cache` (prefer mode **1777**) so other logins can add sibling `cache-<app>` leaves. If the preferred leaf exists but is **not writable**, fall through.

### 2.3 Persistence folder (normative)

1. Persistence **MUST** be **`${HOME}/.local/<APP_NAME>`**.  
2. Helper **`util_persistent_storage_dir`** **MUST** print that path. **`util_resolve_persistent_storage`** **MUST** `mkdir -p` it, confirm it is writable, then print it (fail closed).  
3. **MUST NOT** use `${HOME}/.local/bin` as persistence (that is `USER_BIN`).  
4. **MUST NOT** use a Type 1 `/var/…` deposit as Type 0 persistence.  
5. **MUST NOT** use `${HOME}/.local/share/<APP_NAME>` as this product’s persistence shape.  
6. **MUST NOT** store scratch/temps in persistence when a cache root is available.  
7. **MUST NOT** store durable `--persist` countdown state in the **cache folder**.

### 2.4 Creation, isolation, wire, about

1. For the **chosen** cache tier, the resolver **MUST** `mkdir -p` the isolated root and only then print the path. Soft-return of a missing path is forbidden.  
2. Failure to obtain a usable cache or persistence root **MUST** fail closed via `out_die`.  
3. Isolation: app identity in the leaf name; ownership-aware create; never rewrite to a single shared world-writable dump.  
4. `app_main` **MUST** wire early: `EFFECTIVE_STORAGE_DIR=$(util_resolve_storage)`; `PERSISTENT_STORAGE_DIR=$(util_resolve_persistent_storage)`; export both plus `STORAGE_DIR`; **`TMPDIR=${EFFECTIVE_STORAGE_DIR}`** so `mktemp -t` inherits **cache** isolation.  
5. `about` JSON **MUST** include `cache_preferred`, `cache_fallback`, `persistence_storage`, and live chosen cache root `effective_storage` (or documented equivalents); **MUST NOT** include `CHECKSUM`.  
6. `about` human **MUST** print **Cache folder (preferred)**, **Cache folder (fallback)**, and **Persistence storage**. **MUST NOT** label cache lines Storage (effective)/(fallback).

### 2.5 Domain coupling (this product — explicit)

Domain named-countdown files are **not** Type 0 scratch. Specialized design:

| Domain mode | Folder class | Must not |
|-------------|--------------|----------|
| Default volatile | Private per-user dir under `/dev/shm` or `/tmp` (domain law) | Treat that dir as the Type 0 **cache folder** |
| `--persist` | **Persistence folder** `${HOME}/.local/countdown` (this file) | Write persist state under XDG cache / `${HOME}/.cache/countdown` |

Domain verbs, duration, and `--persist` flag catalog stay on `requirement-domain-countdown`. This file owns the **folder classes** those modes may use.

### 2.6 Implementation Notes (this project)

| Item | Value for countdown |
|------|------------------------|
| **Product / APP_NAME** | `countdown` |
| **Ship unit** | `./countdown` |
| **Cache resolver name** | `util_resolve_storage` (plus `util_preferred_cache_dir` / `util_fallback_cache_dir`) |
| **Priority chain (live)** | `/dev/shm/cache/cache-countdown` → `/tmp/cache/cache-countdown` → `${XDG_CACHE_HOME}/cache-countdown` |
| **Preferred cache** | `/dev/shm/cache/cache-countdown` |
| **Fallback cache** | `${XDG_CACHE_HOME:-${HOME}/.cache}/cache-countdown` |
| **Persistence path** | `${HOME}/.local/countdown` |
| **Persistence helpers** | `util_persistent_storage_dir` (print); `util_resolve_persistent_storage` (create-before-return) |
| **Isolation keys** | `APP_NAME` in every leaf; sticky `…/cache/` parent on shm/tmp; **MUST NOT** `${APP_NAME}-${USERNAME}` as Type 0 cache |
| **Fallback `STORAGE_DIR` / Config** | `${XDG_CACHE_HOME}/cache-countdown` when shm and `/tmp/cache` fail |
| **Call sites** | `app_main` (early wire + `TMPDIR`); `app_about` (diagnostics); domain `--persist` uses persistence folder via `countdown_resolve_base_dir` |
| **Output SSOT on failure** | `out_die` |
| **Tests** | `tests/test_cli.sh` **TP-CLI-05**; domain persist **TP-STORAGE-02** in `tests/test_countdown_domain.sh` |

**Complete invocation samples (this file owns `about` storage rows):**

```text
countdown about
countdown --json about
countdown start --persist pomodoro 25m
```

### 2.7 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Multi-user machines; never mix users’ scratch files; never assume `/dev/shm` or `$HOME` is writable.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Storage = cache folder **and** persistence folder; `about` says both.  
- **CIAO Principle 5 – Single source of output** (https://github.com/cloudgen/ciao): Resolve failures via `out_*`; path returns are class B stdout.  
- **CIAO Principle 11 – Safe temps** (https://github.com/cloudgen/ciao): Scratch under the cache root; `TMPDIR` inherits isolation.  
- **CIAO Principle 4 / 20 – Over-protect** (https://github.com/cloudgen/ciao): Ban “mkdir -p shared temp” rewrites and cache-only about lines.

---

## Under command line for normal user only

When `countdown` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Resolve cache and persistence as this login | Type 1 `/var/…` deposit; wrap `apt`/`dnf`; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** storage folders. Cache and persistence stay this-login paths. Do not switch to a system-user home on this class.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume mounts missing until proven writable; fail closed.  
- **Intentional:** Two named folder classes; about labels match the classes.  
- **Anti-fragile:** shm → tmp → XDG cache fallback; persistence under `$HOME/.local/<app>`.  
- **Over-protect:** Do not drop persistence from law or from `about`.  
- **SSOT:** One cache resolver, one persistence helper, one about contract.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Mention only a **cache folder** and omit the **persistence folder** in this requirement, `about`, or README storage rows.  
2. Use `${HOME}/.cache/countdown` (or XDG cache) as `--persist` / durable storage.  
3. Use `${HOME}/.local/bin` or a Type 1 `/var/…` path as persistence.  
4. Use `/dev/shm/countdown` or `/dev/shm/countdown-<user>` as the Type 0 **cache folder**.  
5. Label about cache lines **Storage (effective)** / **Storage (fallback)** instead of **Cache folder (preferred)** / **Cache folder (fallback)**.  
6. Leave resolvers defined-but-unused (no `app_main` / `about` wire) while this file is Active.  
7. Echo a tier path without creating it (or without fail-closed create).  
8. Scatter ad-hoc `/tmp/countdown` dumps outside the central resolver.  
9. Remove per-user / per-app isolation “for simplicity.”  
10. Duplicate full domain verb tables here (those stay on `requirement-domain-countdown`).

**Violating this rule is a critical storage/isolation regression.**

---

## 5. Definition of done (storage)

1. `about` human lists Cache folder (preferred), Cache folder (fallback), and Persistence storage.  
2. `about --json` includes `cache_preferred`, `cache_fallback`, `persistence_storage`, `effective_storage`; no `CHECKSUM`.  
3. Persistence path is `${HOME}/.local/countdown`, not cache and not `bin`.  
4. Domain `--persist` uses the persistence folder.  
5. `app_main` exports cache + persistence + `TMPDIR`.  
6. **TP-CLI-05** is **have** (not n/a).  
7. Registry row Active in `docs/requirements/index.md`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-cli-interface.md` | `about` command surface; dual mention of storage diagnostics |
| `docs/requirements/requirement-shell-modular-function-design.md` | `util_*` prefix ownership |
| `docs/requirements/requirement-shell-output-requirements.md` | class B return-via-stdout vs `out_*` |
| `docs/requirements/requirement-domain-countdown.md` | Domain `--persist` semantics; uses persistence folder |
| `./countdown` | Implementation |

---

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-STORAGE`  
**Specialized from:** `LM-SHELL-CLI-STORAGE`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-05** about cache + persistence | `tests/test_cli.sh` | have |
| **TP-CLI-04** about JSON purity (peer) | `tests/test_cli.sh` | have |
| **TP-STORAGE-02** domain `--persist` uses persistence folder | `tests/test_countdown_domain.sh` | have |

**Last Updated**: 2026-08-30  
**Owner**: countdown project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
