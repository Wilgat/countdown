# Report: cache folder design and do-not-capture-read — countdown 1.1.5

**Date:** 2026-09-23
**Mode:** scoped design review (storage law + prompt call shape)
**Ship unit:** `./countdown`
**VERSION:** `1.1.5`
**Lessons re-checked:** L-01…L-13, L-B1…L-B3 (L-02 cache half reopened below)
**Tests this run:** full `./tests/run.sh` not re-run. One isolated probe: `HOME` in a temp dir, `countdown --json about`.
**Status:** **Fixed in 1.1.6** (findings below are the pre-fix review; ship unit and tests now match the remediation)

## Summary

The two-folder storage story is real in law and in `about`: scratch is the cache folder, durable `--persist` state is `${HOME}/.local/countdown`, and domain volatile files stay in a private `countdown-<user>` directory. That split is the right design. The cache resolver does not match it. `util_resolve_storage` creates one shared leaf, `/dev/shm/cache/cache-countdown`, under a mode `1777` parent, and accepts the leaf when it is writable. On this host that leaf is mode `775` (group-writable). `app_main` then exports it as `TMPDIR`. Lesson L-02 already forbids that shape for volatile state. The August 2026 storage requirement both cites “never mix users’ scratch” and forbids a per-user cache leaf, so the law disagrees with itself.

Do-not-capture-read, as a rule, is sound: call a function that contains `read` in the current shell, put a typed value in `PROMPT_ASK_VALUE`, and use the exit status of `prompt_yes_no`. Live `prompt_yes_no` call sites already do that. `prompt_ask` does not. It `printf`s the answer on stdout, never sets `PROMPT_ASK_VALUE`, and its header plus `requirement-shell-output-requirements` tell callers to use `$(prompt_ask …)`. Prompt text from `out_msg_n` is also stdout (`plain_n`), so a capture glues the question onto the answer. There is no live `prompt_ask` caller today, so this is a loaded contract, not a current hang.

## Scope

| Field | Value |
|-------|--------|
| In scope | Type 0 cache folder vs persistence folder; `about` labels; domain `--persist` path; do-not-capture-read vs `prompt_ask` / `prompt_yes_no` |
| Out of scope | Install, checksum, self-update, list JSON (L-10), full product pass |
| Law | `requirement-shell-cli-storage`, `requirement-shell-interactive-vs-noninteractive`, `requirement-shell-output-requirements`, `requirement-shell-script-coding`, `requirement-domain-countdown` |
| Term | `docs/terminologies/do-not-capture-read.md` |

## Lessons re-check (this scope)

| ID | Result | Notes |
|----|--------|-------|
| L-02 | **Fail on the cache resolver** | Domain volatile still uses `countdown-<user>` and `chmod 700`. `util_resolve_storage` does not. Live leaf mode `775` under parent mode `1777`. |
| L-10 | unchanged | Not in this scope. Still open. |

## Strengths

| Area | Notes |
|------|--------|
| Two classes | Cache is scratch. Persistence is `${HOME}/.local/<app>`. `--persist` countdown files go to the persistence folder via `PERSISTENT_STORAGE_DIR`. |
| Domain volatile | `countdown_resolve_base_dir` keeps a private per-user directory and `chmod 700`. It is not the Type 0 cache leaf. |
| About contract | Human lines say Cache folder (preferred), Cache folder (fallback), Persistence storage. JSON has `cache_preferred`, `cache_fallback`, `persistence_storage`, `effective_storage`, and no `CHECKSUM`. Probe matched those keys. |
| Yes/no call shape | `inst_maybe_install` and uninstall use `if prompt_yes_no …`. The only `$(prompt_ask` text in the ship unit is a comment. |
| The term | do-not-capture-read names the ban, the return cup, the false fix (stderr or `/dev/tty` still inside `$()`), and separates pure-data `$()` from `read` helpers. |

## Issues

### Issue 1 -- Severity: bug
- File: countdown:2060
- Description: `util_resolve_storage` creates `/dev/shm/cache` at mode `1777` and then `mkdir -p` of the shared leaf `/dev/shm/cache/cache-countdown`. It keeps that leaf when `[ -w ]` is true. It does not check the owner and it does not `chmod 700`. `app_main` sets `TMPDIR` to that path. On this host the parent is mode `1777` and owned by a different login; the leaf is mode `775` and owned by this login, so the group can read and write scratch. The storage requirement says never mix users’ scratch files and “ownership-aware create”, and the same file forbids a `${APP_NAME}-${USERNAME}` cache leaf. L-02 is the same defect on the cache side after the 2026-08-30 redesign.
- Suggestion: Change the requirement first, then the resolver. Prefer a per-user leaf mode `700` (or reject a leaf this uid does not own, including a symlink). Keep the mode `1777` parent only as a place for those private leaves. Do not treat “writable” as “ours”.
- Lesson: L-02, L-14
- Test: TP-STORAGE-04
- Status: fixed

### Issue 2 -- Severity: bug
- File: tests/test_countdown_domain.sh:198
- Description: TP-STORAGE-02 treats `${CI_HOME}/.cache/countdown` as the cache folder. The live cache paths are `/dev/shm/cache/cache-countdown`, `/tmp/cache/cache-countdown`, and `${XDG_CACHE_HOME}/cache-countdown`. The assertion can pass while a state file sits on a real cache path. `app_main` also creates the cache directory on every run, including `--persist`, so “the cache directory must not exist” is the wrong check. The right check is: the persist state file is under `${HOME}/.local/countdown` and not under the chosen cache root.
- Suggestion: Point the negative assert at `effective_storage` and at `${XDG_CACHE_HOME}/cache-countdown`. Assert the state file path, not the absence of a scratch directory the resolver is required to create.
- Lesson: L-14
- Test: TP-STORAGE-05
- Status: fixed

### Issue 3 -- Severity: suggestion
- File: countdown:2846
- Description: Human `about` prints the preferred path and the XDG fallback path. It does not print the chosen root (`effective_storage`) or the middle tier `/tmp/cache/cache-countdown`. JSON does include `effective_storage`. When the preferred leaf is not writable, a person still reads the preferred path as if it were the live scratch directory. The probe on this host happened to use the preferred leaf, so the gap is in the other tiers.
- Suggestion: Add one human line for the chosen cache folder, fed by `EFFECTIVE_STORAGE_DIR`, and keep preferred/fallback as the candidates.
- Lesson: L-14
- Test: TP-CLI-05 (extend)
- Status: fixed

### Issue 4 -- Severity: suggestion
- File: countdown:2043
- Description: `util_resolve_persistent_storage` creates `${HOME}/.local/countdown` and checks writability. It does not `chmod 700`. Domain `countdown_resolve_base_dir` does that later, on a persist verb. An `about`-only run leaves the directory at the process umask. The probe directory was mode `775`.
- Suggestion: `chmod 700` inside the persistence resolver after a successful create, and fail closed if the directory is not owned by this uid.
- Lesson: L-14
- Test: TP-STORAGE-04
- Status: fixed

### Issue 5 -- Severity: bug
- File: countdown:2123
- Description: Do-not-capture-read says a function whose body contains `read` is called in the current shell and a value prompt stores the answer in `PROMPT_ASK_VALUE`. `requirement-shell-interactive-vs-noninteractive` shows that sample and forbids `_x=$(prompt_ask …)`. `requirement-shell-script-coding` forbids teaching that capture. The ship unit does the opposite: `prompt_ask` `printf`s the default or the answer, never assigns `PROMPT_ASK_VALUE`, and the function header says the printf exists so callers can use `$(prompt_ask …)`. `requirement-shell-output-requirements` §2.1.1 class B lists `prompt_ask` among helpers that callers must capture. `out_msg_n` writes the prompt with `printf` on stdout, so the capture includes the question text. Quiet and JSON paths also `printf` the default, which leaks onto product stdout if the caller follows the interactive sample and does not capture. No command calls `prompt_ask` today. `prompt_yes_no` is the live prompt and is not captured.
- Suggestion: Make the output requirement list path resolvers only, not `prompt_ask`. Implement the interactive sample (`PROMPT_ASK_VALUE`, no stdout return). Delete the header sentence that licenses `$(prompt_ask`. Keep `if prompt_yes_no` as it is.
- Lesson: L-15
- Test: TP-CLI-13
- Status: fixed

### Issue 6 -- Severity: nit
- File: countdown:2087
- Description: `util_resolve_storage` and `util_resolve_persistent_storage` return the path with `echo`. The output requirement prefers `printf '%s'` for class B data returns. Command substitution strips the extra newline, so behavior matches. The same functions are correctly captured with `$()` because they do not `read`.
- Suggestion: Switch those two returns to `printf '%s\n'` when the resolver is next edited. Do not apply that pattern to `prompt_ask`.
- Lesson: —
- Test: —
- Status: fixed

## Non-findings

| Check | Result |
|-------|--------|
| `--persist` state directory | `countdown_resolve_base_dir` uses `PERSISTENT_STORAGE_DIR` (`${HOME}/.local/countdown`), not the cache leaf |
| Domain volatile vs Type 0 cache | Separate trees: `…/countdown-<user>` mode `700` vs `…/cache/cache-countdown` |
| `$(prompt_yes_no` / live `$(prompt_ask` | Absent. Yes/no uses the current shell |
| `about` JSON storage keys | Probe returned `cache_preferred`, `cache_fallback`, `persistence_storage`, `effective_storage` |
| Pure-data `$()` | Cache and persistence resolvers are allowed captures. The ban is the `read` body |

## Priority remediation order

1. Reconcile `requirement-shell-cli-storage` with L-02, then make `util_resolve_storage` owner-checked and mode `700` (Issue 1).
2. Align `prompt_ask`, its header, and output-requirement class B with do-not-capture-read (Issue 5) before any value prompt is added.
3. Fix TP-STORAGE-02 so it looks at the real cache paths and the state file (Issue 2).
4. `chmod 700` on the persistence resolver, and print the chosen cache folder in human `about` (Issues 3 and 4).

## Related

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-storage.md` | Two folder classes; conflicting isolation sentences |
| `docs/terminologies/do-not-capture-read.md` | Positive call-shape rule |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | `PROMPT_ASK_VALUE` sample |
| `docs/requirements/requirement-shell-output-requirements.md` | Class B currently includes `prompt_ask` |
| `reviews/lessons.md` | L-02, L-14, L-15 |

**Written by:** scoped product review (cache folder + do-not-capture-read)
**Review status:** Findings fixed in 1.1.6
