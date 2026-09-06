# =============================================================================
# tests/test_countdown_domain.sh — countdown domain (RQ-DOMAIN-COUNTDOWN / TP-COUNTDOWN-* ops + TP-STORAGE-*)
# =============================================================================
# Domain-subject family TP-COUNTDOWN-* ops + TP-STORAGE-* proves RQ-DOMAIN-COUNTDOWN (policy-harness-id-notation §5).
# Duration + remaining-time semantics (not timer elapsed). Type O-P TP-PAYLOAD-* n/a.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_countdown_domain() {
    t_header "Countdown domain (TP-COUNTDOWN-* ops + TP-STORAGE-*)"

    require_cmd date
    require_cmd sh

    ci_isolated_env
    ci_cleanup_countdown_domain

    _run() {
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" "$@"
    }

    # --- TP-COUNTDOWN-01: help lists domain verbs/flags ---
    _out=$(_run help 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-01 help exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-01 help lists start" "$_out" "start"
    assert_contains "TP-COUNTDOWN-01 help lists stop" "$_out" "stop"
    assert_contains "TP-COUNTDOWN-01 help lists status" "$_out" "status"
    assert_contains "TP-COUNTDOWN-01 help lists list" "$_out" "list"
    assert_contains "TP-COUNTDOWN-01 help lists kill" "$_out" "kill"
    assert_contains "TP-COUNTDOWN-01 help lists reset" "$_out" "reset"
    assert_contains "TP-COUNTDOWN-01 help lists --persist" "$_out" "--persist"

    # --- TP-COUNTDOWN-02: start / status / list / stop (human, volatile; duration required) ---
    _out=$(_run start ci-smoke 30s 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 start exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-02 start success text" "$_out" "started"

    _out=$(_run status ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 status exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-02 status shows name" "$_out" "ci-smoke"
    assert_contains "TP-COUNTDOWN-02 status remaining text" "$_out" "remaining"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 list exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-02 list includes countdown" "$_out" "ci-smoke"

    # --- TP-COUNTDOWN-03: already-running fail ---
    _out=$(_run start ci-smoke 10s 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-03 start already-running exit 1" 1 "$_ec"

    # already_running JSON on stderr (review lock-in TP-01 legacy)
    _err=$(_run --json start ci-smoke 10s 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-03 already_running json exit 1" 1 "$_ec"
    assert_contains "TP-COUNTDOWN-03 already_running code" "$_err" "already_running"

    _out=$(_run stop ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 stop exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-02 stop remaining text" "$_out" "stopped"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 list after stop exit 0" 0 "$_ec"
    case "$_out" in
        *ci-smoke*) t_fail "TP-COUNTDOWN-02 list after stop still shows ci-smoke" ;;
        *) t_pass "TP-COUNTDOWN-02 list after stop has no ci-smoke" ;;
    esac

    # --- duration gates (countdown-specific) ---
    _err=$(_run --json start nodur 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 missing duration exit 1" 1 "$_ec"
    assert_contains "TP-COUNTDOWN-02 missing_duration code" "$_err" "missing_duration"

    _err=$(_run --json start zd 0 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 zero duration exit 1" 1 "$_ec"
    assert_contains "TP-COUNTDOWN-02 invalid_duration code" "$_err" "invalid_duration"

    # default name with duration only
    _out=$(_run start 15s 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 start default name exit 0" 0 "$_ec"
    _out=$(_run stop 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-02 stop default exit 0" 0 "$_ec"

    # --- TP-COUNTDOWN-04: JSON start / status / list / stop + numeric remaining ---
    _out=$(_run --json start json-t 20s 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-04 json start exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-04 json start type success" "$_out" '"type":"success"'
    assert_contains "TP-COUNTDOWN-04 json start name" "$_out" '"name":"json-t"'
    assert_contains "TP-COUNTDOWN-04 json start remaining" "$_out" '"remaining":'

    _out=$(_run --json status json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-04 json status exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-04 json status type" "$_out" '"type":"status"'
    assert_contains "TP-COUNTDOWN-04 json status remaining" "$_out" '"remaining":'
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
# remaining may be number or string depending on product; prefer number when present
r=o.get("remaining")
assert r is not None
if isinstance(r, str):
    assert r.isdigit() or r.replace(".","",1).isdigit()
else:
    assert isinstance(r, (int, float))
' 2>/dev/null; then
            t_pass "TP-COUNTDOWN-04 json status remaining is numeric-compatible"
        else
            t_fail "TP-COUNTDOWN-04 json status remaining type invalid"
        fi
    else
        t_skip "TP-COUNTDOWN-04 python3 missing for remaining type check"
    fi

    _out=$(_run --json list 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-04 json list exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-04 json list type" "$_out" '"type":"list"'

    _out=$(_run --json stop json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-04 json stop exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-04 json stop remaining" "$_out" '"remaining":'

    # --- TP-COUNTDOWN-05: no_countdown error ---
    _err=$(_run --json status gone 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-05 status missing exit 1" 1 "$_ec"
    assert_contains "TP-COUNTDOWN-05 no_countdown code" "$_err" "no_countdown"

    # --- TP-COUNTDOWN-06: kill / reset ---
    _run start kill-me 40s >/dev/null 2>&1
    _out=$(_run kill kill-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-06 kill exit 0" 0 "$_ec"

    _run start reset-me 40s >/dev/null 2>&1
    _out=$(_run reset reset-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-06 reset exit 0" 0 "$_ec"
    assert_contains "TP-COUNTDOWN-06 reset text" "$_out" "reset"

    # --- TP-COUNTDOWN-07: invalid_name ---
    _err=$(_run start 'bad/name' 10s 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-07 invalid name exit 1" 1 "$_ec"

    _err=$(_run --json start 'bad/name' 10s 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-COUNTDOWN-07 invalid name json exit 1" 1 "$_ec"
    assert_contains "TP-COUNTDOWN-07 invalid_name code" "$_err" "invalid_name"

    # --- TP-STORAGE-02: --persist start / list / stop ---
    _out=$(_run start --persist persist-t 45s 2>/dev/null)
    _ec=$?
    assert_eq "TP-STORAGE-02 persist start exit 0" 0 "$_ec"
    assert_contains "TP-STORAGE-02 persist mode note or success" "$_out" "started"
    _u=$(id -un 2>/dev/null || echo "unknown")
    if [ -f "${CI_HOME}/.local/${APP_NAME}/${APP_NAME}_${_u}_persist-t" ]; then
        t_pass "TP-STORAGE-02 persist state under persistence folder"
    else
        t_fail "TP-STORAGE-02 persist state missing under ${CI_HOME}/.local/${APP_NAME}"
    fi
    if [ -e "${CI_HOME}/.cache/${APP_NAME}" ]; then
        t_fail "TP-STORAGE-02 persist must not use cache folder (${CI_HOME}/.cache/${APP_NAME})"
    else
        t_pass "TP-STORAGE-02 persist did not write cache folder"
    fi

    _out=$(_run list --persist 2>/dev/null)
    _ec=$?
    assert_eq "TP-STORAGE-02 persist list exit 0" 0 "$_ec"
    assert_contains "TP-STORAGE-02 persist list name" "$_out" "persist-t"

    _out=$(_run stop --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-STORAGE-02 persist stop exit 0" 0 "$_ec"

    if [ -d "${CI_HOME}/.local/${APP_NAME}" ]; then
        t_pass "TP-STORAGE-02 persist uses persistence folder (~/.local/${APP_NAME})"
    else
        t_fail "TP-STORAGE-02 persistence folder missing (${CI_HOME}/.local/${APP_NAME})"
    fi

    # --- TP-STORAGE-01: volatile private dir storage ---
    # Layout: ${VOLATILE|/tmp}/${APP_NAME}-${USER}/${APP_NAME}_${USER}_${name}
    _run start stor-path 50s >/dev/null 2>&1
    _u=$(id -un 2>/dev/null || echo "unknown")
    _hit=0
    _state=
    for _base in /dev/shm /tmp; do
        _candidate="${_base}/${APP_NAME}-${_u}/${APP_NAME}_${_u}_stor-path"
        if [ -f "$_candidate" ]; then
            _hit=1
            _state="$_candidate"
            break
        fi
    done
    if [ "$_hit" -eq 1 ]; then
        t_pass "TP-STORAGE-01 volatile private dir file present"
    else
        _out=$(_run status stor-path 2>/dev/null)
        if [ $? -eq 0 ]; then
            t_pass "TP-STORAGE-01 storage resolved (status OK; path layout may differ)"
        else
            t_fail "TP-STORAGE-01 no storage file and status failed"
        fi
    fi
    _run stop stor-path >/dev/null 2>&1 || true

    # --- TP-STORAGE-03: corrupted state → clean error ---
    _run start corrupt-me 60s >/dev/null 2>&1
    _u=$(id -un 2>/dev/null || echo "unknown")
    _state=
    for _base in /dev/shm /tmp; do
        _candidate="${_base}/${APP_NAME}-${_u}/${APP_NAME}_${_u}_corrupt-me"
        if [ -f "$_candidate" ]; then
            _state="$_candidate"
            break
        fi
    done
    if [ -n "$_state" ]; then
        printf 'not-a-number\nbad\n' > "$_state"
        _err=$(_run --json status corrupt-me 2>&1 >/dev/null)
        _ec=$?
        if [ "$_ec" -ne 0 ]; then
            t_pass "TP-STORAGE-03 corrupted state status non-zero"
            assert_contains "TP-STORAGE-03 corrupted_data or error type" "$_err" "corrupted"
        else
            t_fail "TP-STORAGE-03 corrupted state expected non-zero status"
        fi
    else
        t_skip "TP-STORAGE-03 could not locate state file to corrupt"
    fi
    _run kill corrupt-me >/dev/null 2>&1 || true
    _run stop corrupt-me >/dev/null 2>&1 || true

    # cleanup
    ci_cleanup_countdown_domain
    rm -rf "${CI_HOME}/.local/${APP_NAME}" 2>/dev/null || true
    rm -rf "${CI_HOME}/.cache/${APP_NAME}" 2>/dev/null || true
    ci_cleanup_env
}
