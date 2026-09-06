# Requirements index

**Product:** countdown (POSIX `/bin/sh` Type 0 CLI + named-countdown domain)  
**Workspace state:** Specialized product law (not blank genesis); **software-development class** + **domain SSOT present**.  
**Class law:** `requirement-class-software-dev` / **`RQ-CLASS-SOFTWARE-DEV`**.  
**Domain SSOT:** `requirement-domain-countdown` / **`RQ-DOMAIN-COUNTDOWN`**.  
**Updated:** 2026-09-06

| Requirement-ID | Key | Title | Area | Status | Path | Updated |
|----------------|-----|-------|------|--------|------|---------|
| `RQ-CLASS-SOFTWARE-DEV` | requirement-class-software-dev | Software-development class law + residual stack (posix-sh Type 0) | class | Active | `requirement-class-software-dev.md` | 2026-08-24 |
| `RQ-BOOTSTRAP-CHAIN` | requirement-bootstrap-chain | Bootstrap chain (lineage hops, direction A→B, shared vs domain defect ownership) | architecture | Active | `requirement-bootstrap-chain.md` | 2026-07-24 |
| `RQ-SHELL-AUTOMATIC-CHECKSUM` | requirement-shell-automatic-checksum | Automatic companion-digest integrity (transparent link/value/result; CHECKSUM not help/about) | shell | Active | `requirement-shell-automatic-checksum.md` | 2026-07-24 |
| `RQ-SHELL-CLI-INTERFACE` | requirement-shell-cli-interface | Shell CLI interface (commands, flags, dispatch, modes) | shell | Active | `requirement-shell-cli-interface.md` | 2026-08-30 |
| `RQ-SHELL-CLI-STORAGE` | requirement-shell-cli-storage | Shell CLI storage (cache folder **and** persistence folder) | shell | Active | `requirement-shell-cli-storage.md` | 2026-08-30 |
| `RQ-SHELL-CLI-ZERO-ARGUMENTS` | requirement-shell-cli-zero-arguments | Empty argv Type O install-ensure (not installed / local / global) | shell | Active | `requirement-shell-cli-zero-arguments.md` | 2026-07-24 |
| `RQ-DOMAIN-COUNTDOWN` | requirement-domain-countdown | Named-countdown domain product law (duration, remaining time, storage, help/about domain rows) | domain | Active | `requirement-domain-countdown.md` | 2026-08-30 |
| `RQ-SHELL-IDEMPOTENCY` | requirement-shell-idempotency | Shell idempotency / re-run safety for ensure-style ops | shell | Active | `requirement-shell-idempotency.md` | 2026-07-24 |
| `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` | requirement-shell-interactive-vs-noninteractive | Interactive vs non-interactive / `curl\|sh` behavior | shell | Active | `requirement-shell-interactive-vs-noninteractive.md` | 2026-07-24 |
| `RQ-SHELL-MODULAR-FUNCTION-DESIGN` | requirement-shell-modular-function-design | Single-file modular function design (prefixes, zones) | shell | Active | `requirement-shell-modular-function-design.md` | 2026-07-24 |
| `RQ-SHELL-OUTPUT-REQUIREMENTS` | requirement-shell-output-requirements | Central `out_*` output SSOT (stdout/stderr, modes) | shell | Active | `requirement-shell-output-requirements.md` | 2026-07-24 |
| `RQ-SHELL-SCRIPT-CODING` | requirement-shell-script-coding | POSIX `/bin/sh` coding-style specialize-in home (without it, portable lessons arrive raw) | shell | Active | `requirement-shell-script-coding.md` | 2026-09-06 |
| `RQ-SHELL-SELF-MANAGEMENT` | requirement-shell-self-management | Self-management lifecycle (version-check, update, uninstall, about) | shell | Active | `requirement-shell-self-management.md` | 2026-07-24 |

**Rules for agents:**

1. Treat rows above as the **live product-law inventory** for countdown.  
2. **Primary citation** uses **Requirement-ID** (`RQ-*`) on product surfaces; path/basename secondary (policy-harness-id-notation).  
3. **Do not invent** additional `requirement-*.md` paths — verify on disk and add a registry row in the same change when creating one.  
4. Product source comments cite **only** these live requirement files (or future registered ones) — never `template-*` / `skill-*` as behavioral authority.  
5. This versioned surface lists **requirement rows only** — do not dump templates / skills / terminologies / incidents path inventories here (git-surface; INC-20260712-005).  
6. Keep Status and Path in sync with each file’s header when status changes.  
7. **Registry discipline (summary only):** invent no paths; same-change file+row; empty registry valid at genesis; this file stays **requirement rows only** (no harness tree dumps).  
8. **Domain naming:** Domain SSOT basename is `requirement-domain-<subject>.md` only (this product: `requirement-domain-countdown` / `RQ-DOMAIN-COUNTDOWN`). Confirm domain **subject** before creating a new domain requirement; Area `domain`; exactly one Active domain SSOT. Do not use `requirement-shell-domain*` for domain law.  
9. **Design-time verification** on each requirement lists TP-IDs + `tests/*` + `reviews/*` only — never `docs/templates/**` paths.

When adding a requirement: append a row (with `RQ-*`), create the file under `docs/requirements/`, keep Status in sync with the file header.

## Law-mold alignment (product)

Each Active non-class shell requirement **specializes** a portable law mold-ID (cited as **`LM-*`** on DTV, not as a template path). Domain SSOT **`RQ-DOMAIN-COUNTDOWN`** has no portable domain law mold; proof design aid is **`PM-DOMAIN-TEST-PLAN`** → product family **`TP-COUNTDOWN`**. Bootstrap lineage: **`LM-BOOTSTRAP-CHAIN`**. Full matrix: `reviews/requirement-test-matrix.md`.
