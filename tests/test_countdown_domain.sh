# =============================================================================
# tests/test_countdown_domain.sh — countdown product domain commands
# =============================================================================
# Covers: start with duration / stop / status / list, --json, --persist,
# kill/reset, invalid name, already-running, missing duration, no_countdown.
# Uses isolated HOME for persistent storage; cleans volatile files after suite.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_countdown_domain() {
    t_header "Countdown domain"

    require_cmd date
    require_cmd sh

    ci_isolated_env
    ci_cleanup_countdown_domain

    _run() {
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" "$@"
    }

    # --- start / status / list / stop (human, volatile) ---
    _out=$(_run start ci-smoke 30s 2>/dev/null)
    _ec=$?
    assert_eq "domain start exit 0" 0 "$_ec"
    assert_contains "domain start success text" "$_out" "started"

    _out=$(_run status ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain status exit 0" 0 "$_ec"
    assert_contains "domain status shows name" "$_out" "ci-smoke"
    assert_contains "domain status remaining text" "$_out" "remaining"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "domain list exit 0" 0 "$_ec"
    assert_contains "domain list includes countdown" "$_out" "ci-smoke"

    # already running fails
    _out=$(_run start ci-smoke 10s 2>/dev/null)
    _ec=$?
    assert_eq "domain start already-running exit 1" 1 "$_ec"

    _out=$(_run stop ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain stop exit 0" 0 "$_ec"
    assert_contains "domain stop remaining text" "$_out" "stopped"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "domain list after stop exit 0" 0 "$_ec"
    case "$_out" in
        *ci-smoke*) t_fail "domain list after stop still shows ci-smoke" ;;
        *) t_pass "domain list after stop has no ci-smoke" ;;
    esac

    # --- missing duration ---
    _err=$(_run --json start nodur 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain missing duration exit 1" 1 "$_ec"
    assert_contains "domain missing_duration code" "$_err" "missing_duration"

    # --- invalid duration (zero seconds) ---
    _err=$(_run --json start zd 0 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain zero duration exit 1" 1 "$_ec"
    assert_contains "domain invalid_duration code" "$_err" "invalid_duration"

    # --- default name with duration only ---
    _out=$(_run start 15s 2>/dev/null)
    _ec=$?
    assert_eq "domain start default name exit 0" 0 "$_ec"
    _out=$(_run stop 2>/dev/null)
    _ec=$?
    assert_eq "domain stop default exit 0" 0 "$_ec"

    # --- JSON start / status / stop ---
    _out=$(_run --json start json-t 20s 2>/dev/null)
    _ec=$?
    assert_eq "domain json start exit 0" 0 "$_ec"
    assert_contains "domain json start type success" "$_out" '"type":"success"'
    assert_contains "domain json start name" "$_out" '"name":"json-t"'
    assert_contains "domain json start remaining" "$_out" '"remaining":'

    _out=$(_run --json status json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json status exit 0" 0 "$_ec"
    assert_contains "domain json status type" "$_out" '"type":"status"'
    assert_contains "domain json status remaining" "$_out" '"remaining":'

    _out=$(_run --json list 2>/dev/null)
    _ec=$?
    assert_eq "domain json list exit 0" 0 "$_ec"
    assert_contains "domain json list type" "$_out" '"type":"list"'

    _out=$(_run --json stop json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json stop exit 0" 0 "$_ec"
    assert_contains "domain json stop remaining" "$_out" '"remaining":'

    # --- no_countdown errors ---
    _err=$(_run --json status gone 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain status missing exit 1" 1 "$_ec"
    assert_contains "domain status no_countdown code" "$_err" "no_countdown"

    # --- kill / reset ---
    _run start kill-me 40s >/dev/null 2>&1
    _out=$(_run kill kill-me 2>/dev/null)
    _ec=$?
    assert_eq "domain kill exit 0" 0 "$_ec"

    _run start reset-me 40s >/dev/null 2>&1
    _out=$(_run reset reset-me 2>/dev/null)
    _ec=$?
    assert_eq "domain reset exit 0" 0 "$_ec"
    assert_contains "domain reset text" "$_out" "reset"

    # --- invalid name ---
    _err=$(_run start 'bad/name' 10s 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name exit 1" 1 "$_ec"

    _err=$(_run --json start 'bad/name' 10s 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name json exit 1" 1 "$_ec"
    assert_contains "domain invalid_name code" "$_err" "invalid_name"

    # --- persistent mode ---
    _out=$(_run start --persist persist-t 45s 2>/dev/null)
    _ec=$?
    assert_eq "domain persist start exit 0" 0 "$_ec"
    assert_contains "domain persist mode note or success" "$_out" "started"

    _out=$(_run list --persist 2>/dev/null)
    _ec=$?
    assert_eq "domain persist list exit 0" 0 "$_ec"
    assert_contains "domain persist list name" "$_out" "persist-t"

    _out=$(_run stop --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "domain persist stop exit 0" 0 "$_ec"

    # cleanup domain artifacts for this user
    ci_cleanup_countdown_domain
    rm -rf "${CI_HOME}/.cache/${APP_NAME}" 2>/dev/null || true

    ci_cleanup_env
}
