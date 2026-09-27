**file**: docs/requirements/requirement-shell-cli-storage.md  
**Requirement-ID**: `RQ-SHELL-CLI-STORAGE`  
**Status**: Active (Version 1.2.0 – per-login per-process cache folder **and** persistence folder)  
**Area**: shell  
**Key**: `requirement-shell-cli-storage`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **Single Source of Truth** for Type 0 shell CLI **storage** on countdown. **Storage** means **two** classes, not one:

| Class | Role | Survives reboot |
|-------|------|-----------------|
| **Cache folder** | Volatile scratch / temps / staging | No (`/dev/shm` or `/tmp`) or maybe (home fallback) |
| **Persistence folder** | Durable per-user app data | Yes (under this login’s `$HOME`) |

It owns path **shapes**, central resolvers, `app_main` wire, and `about` diagnostics for both classes.

**Scope:** Cache resolve, persistence resolve, isolation, create-before-return, about labels.  
**Out of scope:** Install binary placement (`${HOME}/.local/bin` / `USER_BIN`); Type 1 `/var/…` deposit; domain remaining-time verbs (peer `requirement-domain-countdown`).

The preferred cache is **not** a ram-drive **project** tree (`/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${login}`). It lives under `/dev/shm/cache/` (Linux) or `/tmp/cache/` (Git Bash and Mac). The leaf is **per login and per process** on volatile tiers so two logins never share one cache directory.

### 1.1 Human-facing

**In one sentence:** You run `countdown about` to see this login’s **cache folder** (scratch that can go away) **and** **persistence folder** (durable files that survive reboot).

| You | The other role | Not this |
|-----|----------------|----------|
| A normal login who installs and runs `countdown` | Maintainers who keep both folder classes honest | A dest approval machine or inbound request queue |

**Includes:** a private cache leaf for this process, host-specific fallbacks, persistence under `${HOME}/.local/countdown`.  
**Excludes:** treating `${HOME}/.local/bin` as persistence; storing `--persist` countdown state in the cache folder; one shared cache directory for every login.

| Surface | What you open | What for |
|---------|---------------|----------|
| `src/countdown` | program file people install | live resolve + `about` |
| `countdown about` | command | cache folder used, preferred, fallbacks, persistence |
| `countdown --json about` | command | `cache_used` / `cache_preferred` / `cache_fallback` / `cache_fallback_2` / `persistence_storage` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| See both folders | About names the cache folder in use, the preferred path, each fallback this computer has, and persistence. A skipped cache tier prints nothing. | `countdown about` |
| Keep a countdown across reboot | Domain `--persist` writes into the **persistence folder**, not the cache folder. | `countdown start --persist pomodoro 25m` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Two storage classes

1. Shell CLI **storage** **MUST** mean **cache folder and persistence folder**. Naming only a cache path is incomplete.  
2. Callers that need a scratch/cache root **MUST** use the central cache resolver (or `mktemp` under a root it returned).  
3. Durable per-user app data **MUST** use the persistence folder.  
4. The resolver **MUST** return a path via **stdout for capture** (`$(util_resolve_storage)` / `$(util_resolve_persistent_storage)`) — that write is a **data return**, not product UI.  
5. User-visible storage warnings/errors **MUST** go through the product **output SSOT** (`out_*`).

Placeholders only. **MUST NOT** hardcode an app name, a login name, or a process id.

- `${APP_NAME}` is the product app name.  
- `${login}` is this login (`id -un`), one path segment (`USERNAME` after replacing any character outside `A-Za-z0-9._-`).  
- `$$` is this process id. It is not a fixed number.  
- `${HOME}` is this login’s home.

### 2.2 Cache folder (host chains)

Volatile leaf (shared parents `/dev/shm` and `/tmp`): `cache-${APP_NAME}-${login}-$$`.  
Home leaf (already per login): `cache-${APP_NAME}-$$`.  
Home tiers omit `${login}` because `${HOME}` is already that login.

| Host | Preferred | 1st fallback | 2nd fallback |
|------|-----------|--------------|--------------|
| Linux (and Termux, and any host that is not Git Bash or Mac) | `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/.cache/cache-${APP_NAME}-$$` |
| Git Bash (`MSYSTEM`, or `uname -s` `MINGW*` / `MSYS*`) | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$` | none |
| Mac (`uname -s` `Darwin`) | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/Library/Caches/cache-${APP_NAME}-$$` | `${HOME}/cache/cache-${APP_NAME}-$$` |

| Class | Helper |
|-------|--------|
| Cache folder (preferred) | `util_preferred_cache_dir` |
| Cache folder (1st fallback) | `util_fallback_cache_dir` |
| Cache folder (2nd fallback) | `util_fallback2_cache_dir` (empty on Git Bash) |
| Persistence folder | `util_persistent_storage_dir` → `${HOME}/.local/${APP_NAME}` |

Live chosen **cache** root: `util_resolve_storage` (stdout).  
Live **persistence** root: `util_resolve_persistent_storage` (stdout; create-before-return).

**Silent fallback.** A skipped tier is silent. Choosing a later tier **MUST NOT** print a warning or an error. **MUST NOT** say that a fallback happened. An error is allowed only when **every** tier for this host failed to be created.

On Termux/Android, the chosen cache root (including `/tmp` and `/dev/shm`) **MAY** be **`noexec`**. Termux uses the **Linux** chain. Cache remains scratch **only**. **MUST NOT** exec a downloaded program from the cache folder.

**MUST NOT** use `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${login}` as the **cache** folder — those are ram-drive project folders (domain volatile may use a private per-user dir; that is **not** the Type 0 cache folder).

**MUST NOT** replace this chain with one shared `cache-${APP_NAME}` leaf, with `XDG_CACHE_HOME`, or with a home leaf that still inserts `${login}`.

### 2.3 Create, mode, isolation

Walk this host’s chain in order. First directory that can be created **and** claimed wins.

**Parent:** for `/dev/shm/cache` and `/tmp/cache` the resolver **MUST** create that parent (prefer mode **1777** when creating) so each login can add its own leaf. An existing parent is left in place.

**Leaf:** mode **0700**. Claim it only when all of these hold: it is a directory, it is not a symlink, `chmod 700` succeeds (this uid owns it), and a listing shows mode `drwx------`. A leaf that is merely writable, including one planted by another login, **MUST** be rejected and the resolver **MUST** try the next tier with no message.

**Create before return:** for the **chosen** leaf, the resolver **MUST** create it, confirm the claim, then print the path. If none work → **MUST** fail closed via `out_die`. **MUST NOT** return a path without creating it.

**Scratch files.** The **cache directory** name includes `$$`. Scratch **files** inside it **MUST** stay `mktemp` names (`${APP_NAME}.….XXXXXX` under `TMPDIR`). They **MUST NOT** use a predictable `$$` file name (forbidden: `/tmp/${APP_NAME}.$$`, `${EFFECTIVE_STORAGE_DIR}/${APP_NAME}.$$`).

`app_main` **MUST** wire early:

- `EFFECTIVE_STORAGE_DIR=$(util_resolve_storage)` — chosen cache, created  
- `STORAGE_DIR=$(util_fallback_cache_dir)` — 1st fallback path (diagnostic; same value as JSON `storage_dir`)  
- `PERSISTENT_STORAGE_DIR=$(util_resolve_persistent_storage)`  
- export those plus **`TMPDIR=${EFFECTIVE_STORAGE_DIR}`** so `mktemp -t` inherits the chosen cache

### 2.4 Persistence folder (normative)

1. Persistence **MUST** be **`${HOME}/.local/${APP_NAME}`**. No login suffix and no `$$`. Persistence is not a cache tier.  
2. Helper **`util_persistent_storage_dir`** **MUST** print that path. **`util_resolve_persistent_storage`** **MUST** create the parent, claim the leaf as mode `700` (not a symlink; `chmod 700` must succeed), then print it (fail closed).  
3. **MUST NOT** use `${HOME}/.local/bin` as persistence (that is `USER_BIN`).  
4. **MUST NOT** use a Type 1 `/var/…` deposit as Type 0 persistence.  
5. **MUST NOT** use `${HOME}/.local/share/${APP_NAME}` as this product’s persistence shape.  
6. **MUST NOT** store scratch/temps in persistence when a cache root is available.  
7. **MUST NOT** store durable `--persist` countdown state in the **cache folder**.

### 2.5 About

`about` human **MUST** print, in order:

1. **`Cache folder used:`** then the live directory (the tier that was created).  
2. **`Cache folder (preferred):`** then this host’s preferred path.  
3. **`Cache folder (1st fallback):`** then the 1st fallback.  
4. **`Cache folder (2nd fallback):`** only when this host has a 2nd fallback.  
5. **`Persistence storage:`** then `${HOME}/.local/${APP_NAME}`.

When the preferred tier is the one used, the used line and the preferred line are the same path. When a fallback is used, the used line is that fallback path and the preferred line still shows the preferred path. Neither case prints a warning.

**MUST NOT** label cache lines **Storage (effective)** or **Storage (fallback)**. **MUST NOT** print **Cache folder (chosen)** (the used line replaced it).

Linux sample (placeholders, not a fixed process id):

```
[INFO] Cache folder used: /dev/shm/cache/cache-${APP_NAME}-${login}-$$
[INFO] Cache folder (preferred): /dev/shm/cache/cache-${APP_NAME}-${login}-$$
[INFO] Cache folder (1st fallback): /tmp/cache/cache-${APP_NAME}-${login}-$$
[INFO] Cache folder (2nd fallback): ${HOME}/.cache/cache-${APP_NAME}-$$
[INFO] Persistence storage: ${HOME}/.local/${APP_NAME}
```

Git Bash omits the 2nd fallback line. Mac prints preferred under `/tmp/cache/`, 1st fallback under `${HOME}/Library/Caches/`, and 2nd fallback under `${HOME}/cache/`.

`about` JSON **MUST** include `cache_used`, `cache_preferred`, `cache_fallback` (1st), `cache_fallback_2` (2nd, empty string when the host has none), `persistence_storage`, `effective_storage` (same value as `cache_used`), and `storage_dir` (1st fallback). **MUST NOT** include `CHECKSUM`.

### 2.6 Domain coupling (this product — explicit)

Domain named-countdown files are **not** Type 0 scratch. Specialized design:

| Domain mode | Folder class | Must not |
|-------------|--------------|----------|
| Default volatile | Private per-user dir under `/dev/shm` or `/tmp` (domain law) | Treat that dir as the Type 0 **cache folder** |
| `--persist` | **Persistence folder** `${HOME}/.local/countdown` (this file) | Write persist state under the cache folder or `${HOME}/.cache/countdown` |

Domain verbs, duration, and `--persist` flag catalog stay on `requirement-domain-countdown`. This file owns the **folder classes** those modes may use.

### 2.7 Implementation Notes (this project)

| Item | Value for countdown |
|------|------------------------|
| **Product / APP_NAME** | `countdown` |
| **Ship unit** | `src/countdown` |
| **Cache resolver name** | `util_resolve_storage` |
| **Path helpers** | `util_preferred_cache_dir`, `util_fallback_cache_dir`, `util_fallback2_cache_dir` |
| **Linux preferred** | `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` mode `700` |
| **Linux 1st / 2nd** | `/tmp/cache/cache-${APP_NAME}-${login}-$$` then `${HOME}/.cache/cache-${APP_NAME}-$$` |
| **Git Bash** | `/tmp/cache/cache-${APP_NAME}-${login}-$$` then `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$` |
| **Mac** | `/tmp/cache/cache-${APP_NAME}-${login}-$$` then `${HOME}/Library/Caches/cache-${APP_NAME}-$$` then `${HOME}/cache/cache-${APP_NAME}-$$` |
| **Persistence path** | `${HOME}/.local/countdown` mode `700` |
| **Persistence helpers** | `util_persistent_storage_dir` (print); `util_resolve_persistent_storage` (create-before-return) |
| **Isolation keys** | volatile leaf `cache-${APP_NAME}-${login}-$$` mode `700` under sticky `…/cache/`; home leaf `cache-${APP_NAME}-$$` mode `700`; **MUST NOT** use `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${login}` as this cache |
| **Call sites** | `app_main` (early wire + `TMPDIR`); `app_about` (diagnostics); domain `--persist` uses persistence folder via `countdown_resolve_base_dir` |
| **Output SSOT on failure** | `out_die` only when every tier for this host failed |
| **Tests** | `tests/test_cli.sh` **TP-CLI-05** · **TP-STORAGE-04**; domain persist **TP-STORAGE-02** · **TP-STORAGE-05** in `tests/test_countdown_domain.sh` |

**Complete invocation samples (this file owns `about` storage rows):**

```text
countdown about
countdown --json about
countdown start --persist pomodoro 25m
```

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Multi-user machines; never mix users’ scratch files; never assume `/dev/shm` or `$HOME` is writable.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Storage = cache folder **and** persistence folder; `about` says both.  
- **CIAO Principle 5 – Single source of output** (https://github.com/cloudgen/ciao): Resolve failures via `out_*`; path returns are class B stdout. A skipped tier prints nothing.  
- **CIAO Principle 11 – Safe temps** (https://github.com/cloudgen/ciao): Scratch files are `mktemp` names under the cache root; `TMPDIR` inherits isolation. The directory name carries `$$`.  
- **CIAO Principle 4 / 20 – Over-protect** (https://github.com/cloudgen/ciao): Ban shared world-writable leaves and cache-only about lines.

---

## Under command line for normal user only

When `countdown` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Resolve cache and persistence as this login | Type 1 `/var/…` deposit; wrap `apt`/`dnf`; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |
| Termux: Linux cache chain; scratch only (may be `noexec`) | Exec a downloaded program from the cache folder |

**This requirement:** storage folders. Cache and persistence stay this-login paths. Do not switch to a system-user home on this class.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume mounts missing until proven writable; fail closed only when every tier failed.  
- **Intentional:** Two named folder classes; about labels match the classes.  
- **Anti-fragile:** Missing `/dev/shm` still works, and the miss is silent.  
- **Over-protect:** Do not drop persistence from law or from `about`. Leaf mode `700`, not “writable is enough.”  
- **SSOT:** One cache resolver, one persistence helper, one about contract.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Mention only a **cache folder** and omit the **persistence folder** in this requirement, `about`, or README storage rows.  
2. Use `${HOME}/.cache/countdown` (or any cache leaf) as `--persist` / durable storage.  
3. Use `${HOME}/.local/bin` or a Type 1 `/var/…` path as persistence.  
4. Use `/dev/shm/countdown` or `/dev/shm/countdown-<user>` as the Type 0 **cache folder**.  
5. Label about cache lines **Storage (effective)** / **Storage (fallback)**. The labels are **Cache folder used**, **Cache folder (preferred)**, **Cache folder (1st fallback)**, **Cache folder (2nd fallback)** when that host has one.  
6. Leave resolvers defined-but-unused (no `app_main` / `about` wire) while this file is Active.  
7. Echo a tier path without creating the **chosen** leaf (or without fail-closed create when every tier failed).  
8. Scatter ad-hoc `/tmp/countdown` dumps outside the central resolver.  
9. Remove per-login / per-process / per-app isolation “for simplicity.”  
10. Duplicate full domain verb tables here (those stay on `requirement-domain-countdown`).  
11. Accept a cache or persistence leaf that is a symlink, group-writable, or owned by another login.  
12. Warn or error only because a higher cache tier was skipped.  
13. Drop `${login}` or `$$` from a volatile cache leaf, or put `${login}` back on a home leaf.  
14. Use a predictable `$$` scratch **file** name. The cache **directory** itself includes `$$`.  
15. Print a 2nd fallback line on Git Bash, or use `${HOME}/.cache` as the Git Bash cache root.  
16. Exec a downloaded program from the cache folder on Termux.

**Violating this rule is a critical storage/isolation regression.**

---

## 5. Definition of done (storage)

1. `about` human lists Cache folder used, preferred, 1st fallback, 2nd fallback when this host has one, and Persistence storage.  
2. `about --json` includes `cache_used`, `cache_preferred`, `cache_fallback`, `cache_fallback_2`, `persistence_storage`, `effective_storage`, `storage_dir`; no `CHECKSUM`.  
3. Linux preferred leaf is `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` when that directory is usable. Git Bash and Mac preferred leaf is `/tmp/cache/cache-${APP_NAME}-${login}-$$`.  
4. Persistence path is `${HOME}/.local/countdown`, not cache and not `bin`.  
5. Domain `--persist` uses the persistence folder.  
6. `app_main` exports cache + persistence + `TMPDIR`.  
7. Skipping a cache tier prints no warning and no error.  
8. **TP-CLI-05** and **TP-STORAGE-04** / **TP-STORAGE-05** are **have**.  
9. Registry row Active in `docs/requirements/index.md`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-cli-interface.md` | `about` command surface; dual mention of storage diagnostics |
| `docs/requirements/requirement-shell-modular-function-design.md` | `util_*` prefix ownership |
| `docs/requirements/requirement-shell-output-requirements.md` | class B return-via-stdout vs `out_*` |
| `docs/requirements/requirement-domain-countdown.md` | Domain `--persist` semantics; uses persistence folder |
| `src/countdown` | Implementation |

---

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-STORAGE`  
**Specialized from:** `LM-SHELL-CLI-STORAGE`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-05** about cache + persistence; Linux / Git Bash / Mac chains; silent skip | `tests/test_cli.sh` | have |
| **TP-CLI-04** about JSON purity (peer) | `tests/test_cli.sh` | have |
| **TP-STORAGE-02** domain `--persist` uses persistence folder | `tests/test_countdown_domain.sh` | have |
| **TP-STORAGE-04** chosen cache leaf and persistence folder mode `700` | `tests/test_cli.sh` | have |
| **TP-STORAGE-05** persist state is not under a cache folder | `tests/test_countdown_domain.sh` | have |

## 7. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-08-30 | Active 1.0.0 | Cache folder and persistence folder split |
| 2026-09-23 | Active 1.1.0 | Private per-login leaf mode `700` (no shared `cache-${APP_NAME}`) |
| 2026-09-27 | Active 1.2.0 | Per-login per-process leaves. Linux shm → tmp → `${HOME}/.cache`. Git Bash tmp → AppData Local Temp. Mac tmp → Library/Caches → `${HOME}/cache`. Silent tier miss. `about` prints used / preferred / 1st / 2nd |

**Last Updated**: 2026-09-27  
**Owner**: countdown project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
