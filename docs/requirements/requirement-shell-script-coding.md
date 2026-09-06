**file**: docs/requirements/requirement-shell-script-coding.md  
**Requirement-ID**: `RQ-SHELL-SCRIPT-CODING`  
**Status**: Active (Version 1.0.0 – specialize-in home for POSIX `/bin/sh` coding)  
**Area**: shell  
**Key**: `requirement-shell-script-coding`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **specialize-in home** for POSIX `/bin/sh` coding on countdown. **Without this file, agents bring portable learned lessons raw** (from coding skills or law molds) and treat those as product law.

It owns ship-unit coding rules that are **not** already owned by a peer: shebang, POSIX subset, quoting, safe defaults, function headers, Protection Zones, and product-source citation. Peers keep full tables for output, prefixes, TTY/prompts, storage, and install.

**Scope:** How `./countdown` is written and changed.  
**Out of scope (point, do not duplicate):** `out_*` catalog (`requirement-shell-output-requirements`); prefix table (`requirement-shell-modular-function-design`); TTY/prompt contracts (`requirement-shell-interactive-vs-noninteractive`); cache/persistence resolvers (`requirement-shell-cli-storage`); command catalog (`requirement-shell-cli-interface`).

### 1.1 Human-facing

**In one sentence:** Maintainers write `./countdown` as one POSIX `/bin/sh` file you can install and run as yourself, with prefixes and Protection Zones that stop careless “cleanup.”

| You | The other role | Not this |
|-----|----------------|----------|
| A maintainer editing `./countdown` | Operators who only run commands | A second output or command-table SSOT |

**Includes:** `#!/bin/sh`, quoted variables, `: "${VAR:=default}"` at function top, CIAO function headers, live `requirement-*.md` cites in product comments.  
**Excludes:** treating coding skills as product law; dumping the full `out_*` or prefix tables here; wrapping `sudo` (this product does not).

| Surface | What you open | What for |
|---------|---------------|----------|
| `./countdown` | program file people install | live coding |
| `countdown help` | command | listed verbs stay aligned with code |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Change a helper | Keep the prefix, header, and safe defaults. Do not replace `out_*` with raw `echo`. | edit `./countdown`; then `./tests/run.sh` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialize-in (software-development)

1. **MUST** treat this file as the language-matched coding-style related REQ for countdown.  
2. **MUST NOT** tell agents to follow a coding skill or law mold as product law.  
3. When a peer already owns a slice, **MUST** point at that peer — **MUST NOT** copy the full table.

### 2.2 POSIX `/bin/sh` body

1. Shebang **MUST** be `#!/bin/sh`.  
2. **MUST** stay in the POSIX subset that `tests/run.sh` proves (`dash` / BusyBox ash / bash-as-sh).  
3. **MUST NOT** introduce Bashisms (`[[ ]]`, arrays, process substitution, here-strings) as default style.  
4. Variables used in commands **MUST** be quoted: `"${VAR}"`.  
5. Every function **MUST** start with `: "${VAR:=default}"` for the globals it reads.  
6. Prefer `command -v` over `which`. Prefer `.` over `source`.  
7. User-facing messages **MUST** go through `out_*` (`requirement-shell-output-requirements`).  
8. Functions **MUST** use the live prefix table (`requirement-shell-modular-function-design`): `out_`, `inst_`, `util_`, `app_`, `countdown_`, `ver_`, `path_`, `prompt_`.  
9. New functions **MUST** keep the CIAO header (General Purpose, principles, `!!! DO NOT MODIFY OR SIMPLIFY !!!` on reusable helpers).  
10. Product-source `ALIGNMENT` / `See` comments **MUST** cite only live `docs/requirements/requirement-*.md` (never templates or skills as authority).  
11. **MUST NOT** freeze a session Unix login or `/home/<login>/…` into comments or defaults.

### 2.3 TTY / prompts / temps (own-or-point)

| Slice | Owner | This file |
|-------|-------|-----------|
| Measure `[ -t 0 ]` / `[ -t 1 ]` **outside functions**; helpers consume `TTY` | `requirement-shell-interactive-vs-noninteractive` | Point |
| `prompt_yes_no` / `prompt_ask` bodies | same | Point; **MUST NOT** teach `_x=$(prompt_ask …)` |
| Cache folder **and** persistence folder | `requirement-shell-cli-storage` | Point |
| Scratch files | cache resolver + `mktemp` under that root | **MUST NOT** use predictable `$$` names |
| In-tool `sudo` | **none** — this product does not wrap `sudo` | **MUST NOT** add `util_sudo` |

### 2.4 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Product / ship unit** | `./countdown` |
| **Language** | POSIX `/bin/sh` |
| **Domain prefix** | `countdown_*` |
| **In-tool sudo** | **none** |
| **Numbered main menu** | **not claimed** (empty argv is install-ensure) |
| **Termux / Git Bash / Windows cmd** | Same ceiling as § Under command line for normal user only |

### 2.5 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional:** Coding lessons have a specialize-in home; they do not arrive raw.  
- **CIAO Principle 5 – SSOT of output:** `out_*` stays on the output peer.  
- **CIAO Principle 8 – Reusable function protection:** Headers and Protection Zones stay.  
- **CIAO Principle 4 / 20 – Over-protect:** Do not “clean up” defensive verbosity.

---

## Under command line for normal user only

When `countdown` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Write helpers that run as this login | Add in-tool `sudo`, wrap `apt`/`dnf`, create a dedicated system user, or recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** coding of helpers. Do not add a Type 1 password-sudo ladder or `util_sudo` while this product stays normal-user-only.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Quote, default, fail loud.  
- **Intentional:** Prefixes and headers encode why.  
- **Anti-fragile:** POSIX subset survives Alpine ash and Git Bash.  
- **Over-protect:** Protection Zones are not optional decoration.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Delete this file while the workspace remains software-development.  
2. Treat coding skills or law molds as product law.  
3. Change the shebang away from `#!/bin/sh` without an explicit redesign.  
4. Replace `out_*` with raw `echo`/`printf` for product UI.  
5. Add in-tool `sudo` without a dedicated sudo-command requirement and user order.  
6. Duplicate full peer output/prefix/TTY tables here.  
7. Freeze a session Unix login or home path into this file.

**Violating this rule is a critical coding-law regression.**

---

## 5. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-class-software-dev.md` | Class residual points here |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefix table |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | TTY / prompts |
| `docs/requirements/requirement-shell-cli-storage.md` | Cache + persistence |
| `./countdown` | Implementation |

---

## Design-time verification

**Requirement-ID:** `RQ-SHELL-SCRIPT-CODING`  
**Specialized from:** `LM-SHELL-SCRIPT-CODING` (router `LM-CODING-STYLE`)  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-01** `sh -n` + companion | `tests/test_cli.sh` | have |
| **TP-CLASS-01** class residual points here | static | have |

**Last Updated**: 2026-09-06  
**Owner**: countdown project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §5; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
