**file**: docs/requirements/requirement-bootstrap-chain.md  
**Requirement-ID**: `RQ-BOOTSTRAP-CHAIN`  
**Status**: Active (Version 1.0.0 – CIAO v2.10.2 Principles 1/2/3/4/5/20)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for the **bootstrap chain** of the countdown product: the ordered specialization lineage, hop roles, direction rules, and shared-defect ownership between ancestors and this leaf.

**Scope:** Declared hops; root / immediate / leaf roles; direction A→B only; per-edge inherit / retarget / domain; ship unit and channel separation; shared vs domain-only defect routing.  
**Out of scope (cited, not re-owned):** Shell modular prefixes (`requirement-shell-modular-function-design.md`); output SSOT (`requirement-shell-output-requirements.md`); self-management command behavior (`requirement-shell-self-management.md`); automatic checksum algorithm (`requirement-shell-automatic-checksum.md`); CLI dispatch catalog (`requirement-shell-cli-interface.md`); empty-argv Type O (`requirement-shell-cli-zero-arguments.md`).

**Core idea:** Countdown is not a greenfield invention — it is a **leaf** on an explicit specialization chain. Agents **MUST** name hops, **MUST NOT** reverse-copy this leaf onto ancestors, and **MUST** fix shared architecture defects at the responsible hop when authorized.

### 1.1 Human-facing

**In one sentence:** Countdown grew from an older install-yourself CLI; you must not copy countdown’s body back onto those parents.

| You | The other role | Not this |
|-----|----------------|----------|
| A maintainer changing install or remaining-time code | Parent products (`timer`, `selfmanaged`) that own shared install architecture | Treating countdown as the parent of those tools |

**Includes:** hop table, A→B direction, who owns a shared bug vs a countdown-only bug.  
**Excludes:** duration grammar; help text for `start`.

| Surface | What you open | What for |
|---------|---------------|----------|
| `./countdown` | leaf program | specialized product |
| this file | hop table | who is parent vs leaf |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Fix a shared install bug | Fix it on the parent hop, then re-specialize countdown. Do not overwrite the parent with countdown. | keep `./countdown` as the leaf |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Direction (sacred)

1. Specialization direction **MUST** be **ancestor → descendant** only.  
2. Agents **MUST NOT** overwrite an ancestor ship unit with countdown’s body (or with any descendant) to “share fixes” or “sync bootstrap.”  
3. Detected reverse parentage in docs or plans **MUST** be treated as a critical defect until corrected.  
4. After an authorized fix on an ancestor, refreshing countdown **MUST** re-specialize **from** the fixed ancestor (down-chain), not the reverse.

### 2.2 Declared chain (SSOT)

The project **MUST** maintain an explicit hop table (Implementation Notes §3.1). Informal git history alone is **not** sufficient as chain SSOT.

| Position | Rule |
|----------|------|
| **Root** | First hop in the declared chain — named |
| **Immediate origin** | Direct parent of countdown — named (may equal root only on a one-edge chain) |
| **Leaf** | This product (`countdown`) — named |
| **Intermediates** | Named when present between root and leaf |

### 2.3 Per-edge obligations

For each edge parent → child on the chain:

| Obligation | Rule |
|------------|------|
| **Inherit** | Child **MUST** keep parent Type 0 structural contracts (output family, install/lifecycle family, entry gate, Type O empty argv, integrity pattern, modular prefixes) unless a registered requirement and explicit authorization change the product type |
| **Retarget** | Child **MUST** own its identity (`APP_NAME` / version story) and install channel separately from the parent |
| **Domain** | Child **MAY** add domain surface; domain **MUST NOT** be reverse-written onto the parent as “cleanup” |
| **Ship unit** | Parent and child **MUST** remain distinct installable artifacts when both exist in tree or as declared external references |
| **Tests** | Leaf **MUST** own a suite that covers Type 0 inheritance + leaf domain (peer shell test expectations via live shell requirements) |

### 2.4 Shared vs domain-only defects

| Class | Ownership |
|-------|-----------|
| Shared architecture / install / lifecycle / output helper / integrity pattern | Prefer earliest responsible ancestor hop; leaf-only patches without ancestor plan are incomplete when the defect is known inherited |
| Leaf identity / channel retarget only | Leaf |
| Leaf domain (countdown start/stop/status/list/kill/reset, duration, volatile/persist state) | Leaf only — **MUST NOT** be pushed onto ancestors |
| “Fix ancestor by pasting leaf” | **Forbidden** |

When a leaf revision report is used to audit an ancestor, each finding **MUST** be classified with evidence on the ancestor path before claiming inheritance.

### 2.5 Documentation honesty

1. Product README and ship unit headers **MAY** state specialization from an ancestor honestly.  
2. They **MUST NOT** claim the ancestor was produced by trimming countdown (or any reverse story).  
3. Product source comments that cite law **MUST** use live `requirement-*.md` keys only (including this file for chain rules).  
4. Channel URLs and repo identity for countdown **MUST** remain countdown’s SSOT — not an ancestor’s channel by silent merge.

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Assume multi-hop parentage can be wrong unless declared; do not reverse-copy under time pressure.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Every hop and edge has named inherit/retarget/domain decisions.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Fix ancestors so future specializations do not re-inherit known shared bugs.  
- **CIAO Principle 5 – SSOT** (https://github.com/cloudgen/ciao): One hop table for this product’s lineage.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI** (https://github.com/cloudgen/ciao): Direction and reverse-copy bans are Protection Zone material.

---

## 3. Implementation Notes (this project — no-placeholder)

### 3.1 Hop table (countdown)

| # | Hop name | Position | Ship unit path | Channel / identity | Domain? | Notes |
|---|----------|----------|----------------|--------------------|---------|-------|
| 0 | selfmanaged | root | External / sibling product (not required in this repo); Type 0 baseline origin | selfmanaged product channel when present | no / Type 0 only | Architecture parent of timer |
| 1 | timer | intermediate + **immediate origin** of countdown | `./timer` (reference ship unit in this workspace when present) | timer product channel when published | yes — count-up named timers | Bootstrap used to specialize countdown |
| 2 | countdown | **leaf** (this product) | `./countdown` | `REPO_USER` / `REPO_NAME` / `SCRIPT_URL` Config SSOT for countdown; companion `./countdown.sha256` | yes — remaining-time countdowns | Product under this requirements registry |

**Chain diagram:**

```text
selfmanaged (root)
    │
    ▼ specialize
timer (immediate origin)
    │
    ▼ specialize
countdown (leaf)
```

### 3.2 Edges

| Edge | Inherit Type 0 contracts | Retarget identity/channel | Domain extend |
|------|--------------------------|---------------------------|---------------|
| selfmanaged → timer | yes | yes (timer) | timer domain |
| timer → countdown | yes | yes (countdown) | countdown domain (remaining time / duration) |

### 3.3 Defaults for origin review and shared fixes

| Policy | Value for this project |
|--------|------------------------|
| Default hop for “review bootstrap origin” after a countdown revision report | **Immediate** = `timer` (`./timer` when on disk) |
| Optional second hop | Root = selfmanaged (when available as sibling/external ship unit) |
| Shared install/lifecycle/output/integrity defects | Prefer fix on responsible ancestor; then re-specialize timer→countdown if the leaf must absorb the fix |
| Countdown domain defects | Fix `./countdown` only |

### 3.4 Product paths (disk-truth)

| Artifact | Path |
|----------|------|
| Leaf ship unit | `./countdown` |
| Immediate origin ship unit (when present) | `./timer` |
| Leaf companion digest | `./countdown.sha256` |
| Leaf tests | `tests/` |
| This requirement | `docs/requirements/requirement-bootstrap-chain.md` |

### 3.5 Explicit non-goals

- Declaring every folder under a multi-project host as part of this chain  
- Treating shell entry-gate bootstrap as product parentage  
- Merging timer and countdown install channels  
- Using countdown as the parent of timer or selfmanaged  

---

## 4. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Name hops; verify ship unit paths on disk before claiming a hop is local.  
- **Intentional:** Chain table is intentional product law, not tribal knowledge.  
- **Anti-fragile:** Ancestor health protects future specializations.  
- **Over-protect:** Reverse-copy and reverse parentage language are banned.  
- **SSOT:** This file owns the hop table for countdown.  
- **Respect old working logic:** Surgical ancestor fixes only when proven; do not wholesale replace ancestors with leaf bodies.

---

## 5. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Reverse-copy `./countdown` (or any leaf body) onto `./timer`, selfmanaged, or any ancestor path.  
2. Claim timer or selfmanaged was “created by trimming countdown.”  
3. Leave the hop table empty while claiming multi-hop bootstrap specialization.  
4. Silently use timer’s or selfmanaged’s install channel as countdown’s channel.  
5. Push countdown domain (remaining-time timers, duration start, etc.) into ancestor ship units as “shared cleanup.”  
6. Treat git log alone as a substitute for the hop table.  
7. Weaken direction or reverse-copy rules without explicit project approval.  
8. Cite harness template/skill/terminology paths as product-source law authority in `./countdown` comments (cite this and other live `requirement-*.md` only).

**Violating this rule is a critical bootstrap-direction / pollution regression.**

---

## 6. Definition of done (bootstrap chain)

A change that touches parentage, ship-unit bootstrap claims, or shared Type 0 surfaces across hops is **not done** if any of the following fail:

1. Hop table in §3.1 still matches disk-truth (or intentional external hops are labeled external).  
2. Direction remains ancestor → descendant in plan and docs.  
3. No reverse-copy of leaf onto ancestor.  
4. Countdown identity and `SCRIPT_URL` remain countdown’s SSOT.  
5. Shared vs domain-only ownership is respected for the change.  
6. Implementation cites this requirement key `requirement-bootstrap-chain` when the change is about lineage or multi-hop specialize/review.  
7. Registry `docs/requirements/index.md` lists this requirement as Active.

---

## 7. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-modular-function-design.md` | Inherited modular prefix contracts |
| `docs/requirements/requirement-shell-output-requirements.md` | Inherited output SSOT |
| `docs/requirements/requirement-shell-self-management.md` | Inherited lifecycle surface |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Inherited integrity pattern |
| `docs/requirements/requirement-shell-cli-interface.md` | Leaf CLI surface includes domain + Type 0 |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Inherited Type O empty argv |
| `docs/requirements/requirement-shell-idempotency.md` | Inherited ensure re-run safety |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | Inherited mode behavior |
| `docs/requirements/index.md` | Registry SSOT |
| `./countdown` | Leaf ship unit |
| `./timer` | Immediate origin ship unit when present in workspace |

---

## Design-time verification

**Requirement-ID:** `RQ-BOOTSTRAP-CHAIN`  
**Specialized from:** `LM-BOOTSTRAP-CHAIN`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| Gate / TP | Suite or method | Status |
|-----------|-----------------|--------|
| Lineage docs honest (timer → countdown) | static review + `reviews/` | have |
| No reverse-copy of ship unit | process / reviews | have |
| Suite green after specialize hops | `./tests/run.sh` | have |


**Last Updated**: 2026-07-15  
**Owner**: countdown project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §7; CIAO Principles 1, 2, 3, 4, 5, 20 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
