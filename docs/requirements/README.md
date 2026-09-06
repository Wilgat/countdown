# Requirements (countdown)

**Current state (2026-09-06 — human-facing + coding-style):** Live Active set registered in `index.md` with primary **Requirement-IDs (`RQ-*`)**. Includes **class** (`RQ-CLASS-SOFTWARE-DEV`), **ten** shell `requirement-shell-*` files (including **`RQ-SHELL-CLI-STORAGE`** and **`RQ-SHELL-SCRIPT-CODING`**), **domain SSOT** `requirement-domain-countdown` / **`RQ-DOMAIN-COUNTDOWN`**, and **bootstrap chain** (`RQ-BOOTSTRAP-CHAIN`).

## Layout

| Path | Role |
|------|------|
| `docs/requirements/index.md` | Registry of all requirements (IDs, status, owners) — keep in sync with files |
| `docs/requirements/requirement-*.md` | Project-enforceable product law |
| `docs/requirements/<area>/<REQ-ID>.md` | Optional council-style `REQ-<AREA>-<NNN>` files |

## ID notation

- **Primary citation:** `RQ-*` Requirement-IDs on product surfaces (reviews, tests comments, DTV).
- Basename / path is secondary.
- Format for optional council files: `REQ-<AREA>-<NNN>` (example: `REQ-PLAT-001`).
- **Never** freeze product `RQ-*` into portable templates/skills/terminologies (policy-harness-id-notation).
- Test cases use **`TP-*`**; skills **`SK-*`**; law molds **`LM-*`**; proof molds **`PM-*-TEST-PLAN`**.

## Status values

| Status | Meaning |
|--------|---------|
| `draft` | Proposed; not yet binding |
| `approved` / `Active` | Binding product law |
| `in-progress` | Implementation underway |
| `done` | Implemented and verified |
| `deprecated` | No longer binding |
| `superseded` | Replaced by another Requirement-ID (link it) |

## Agent rules

1. Do not invent requirement basenames — verify disk + registry.
2. Same-change: create/update file **and** `index.md` row.
3. Product source cites only live `requirement-*.md` (not templates/skills as behavioral authority).
4. Session plan must list affected Requirement-IDs and whether each is create / update / no-change.
5. Every non-trivial PR/change set cites one or more Requirement-IDs when requirements exist.
6. Empty registry is valid for genesis; do not invent requirements to “fill” the index.
7. **Design-time verification** lists TP-IDs + `tests/*` + `reviews/*` only — never `docs/templates/**` paths.
8. Domain SSOT basename is `requirement-domain-<subject>.md` only (this product: `requirement-domain-countdown`).

## Related

- Product RTM: `reviews/requirement-test-matrix.md`
- Product test plan: `reviews/test-plan.md`
