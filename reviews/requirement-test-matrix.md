# Requirement ↔ test matrix — countdown

**Product:** countdown  
**Updated:** 2026-09-06  
**Map:** `reviews/test-plan.md`  
**Suite:** `./tests/run.sh`  
**Portable RTM mold:** `PM-REQUIREMENT-TEST-TRACEABILITY` (local harness)

Primary citation: **Requirement-ID (`RQ-*`)**, **law mold-ID (`LM-*`)** for specialize provenance, and **TP-***. Paths secondary.  
Git-surface: versioned REQs list TP + `tests/*` + `reviews/*` only (no `docs/templates/**` paths).

| Requirement-ID | Key | Specialized from (LM / design) | TP families | Suite files | Core status |
|----------------|-----|--------------------------------|-------------|-------------|-------------|
| **RQ-CLASS-SOFTWARE-DEV** | requirement-class-software-dev | **LM-REQUIREMENT-CLASS-SOFTWARE-DEV** | TP-CLASS-01; suite green | static + `tests/run.sh` | **have** |
| **RQ-BOOTSTRAP-CHAIN** | requirement-bootstrap-chain | **LM-BOOTSTRAP-CHAIN** | **TP-BOOT-01/02**; TP-CLASS-01 | static + reviews + suite | **have** |
| **RQ-SHELL-CLI-INTERFACE** | requirement-shell-cli-interface | **LM-CLI-INTERFACE** | TP-CLI-*; TP-COUNTDOWN-01 | `test_cli.sh`, `test_countdown_domain.sh` | **have** |
| **RQ-SHELL-CLI-STORAGE** | requirement-shell-cli-storage | **LM-SHELL-CLI-STORAGE** | TP-CLI-05; TP-STORAGE-02 | `test_cli.sh`, `test_countdown_domain.sh` | **have** |
| **RQ-SHELL-CLI-ZERO-ARGUMENTS** | requirement-shell-cli-zero-arguments | **LM-SHELL-CLI-ZERO-ARGUMENTS** | TP-CLI-09; TP-LC-01/09; TP-CURL-02/03/08; TP-U-02 | CLI, lifecycle, curl | **have** |
| **RQ-SHELL-OUTPUT-REQUIREMENTS** | requirement-shell-output-requirements | **LM-OUTPUT-REQUIREMENTS** | TP-CLI-02/04/06/07/12; TP-COUNTDOWN-04 | CLI, domain | **have** |
| **RQ-SHELL-AUTOMATIC-CHECKSUM** | requirement-shell-automatic-checksum | **LM-AUTOMATIC-CHECKSUM** | TP-CSUM-01..05; TP-LC-06 | CLI, lifecycle | **have** |
| **RQ-SHELL-SELF-MANAGEMENT** | requirement-shell-self-management | **LM-SELF-MANAGEMENT** | TP-LC-04..08,11,12; TP-CLI-11; TP-CURL-02/07 | lifecycle, CLI, curl | **have** |
| **RQ-SHELL-IDEMPOTENCY** | requirement-shell-idempotency | **LM-IDEMPOTENCY** | TP-LC-01/05/10; TP-CURL-03 | lifecycle, curl | **have** |
| **RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE** | requirement-shell-interactive-vs-noninteractive | **LM-INTERACTIVE-VS-NONINTERACTIVE** | TP-CLI-07/11; TP-LC-07; TP-CURL-02/03 | CLI, lifecycle, curl | **have** |
| **RQ-SHELL-MODULAR-FUNCTION-DESIGN** | requirement-shell-modular-function-design | **LM-MODULAR-FUNCTION-DESIGN** | TP-CLI-01; review | CLI + review | **have** |
| **RQ-SHELL-SCRIPT-CODING** | requirement-shell-script-coding | **LM-SHELL-SCRIPT-CODING** | TP-CLI-01 | `test_cli.sh` | **have** |
| **RQ-DOMAIN-COUNTDOWN** | requirement-domain-countdown | **PM-DOMAIN-TEST-PLAN** → **TP-COUNTDOWN** (no domain law mold) | **TP-COUNTDOWN-01..07**; **TP-STORAGE-01..03** | `test_countdown_domain.sh` | **have** |

**n/a (honest):**

| Family | Why |
|--------|-----|
| **TP-PAYLOAD-*** | Not a Type O-P payload product |
| **TP-CLI-10** | No product sdkman/source path |
| **TP-DOM-*** | Deprecated product family — use **TP-COUNTDOWN-*** |
| **TP-CLI-12 @key raw** | Countdown `out_json` string-escapes all pairs (no `@` raw extension yet) |

**Law mold ↔ proof mold (portable design):** load `PM-REQUIREMENT-TEST-TRACEABILITY` under local harness `docs/templates/tests/`.
