# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface (PM-SHELL-CLI-TEST-PLAN / TP-CLI-*)
# =============================================================================
# Portable families: TP-CLI, TP-CSUM-01/05, TP-U-01.
# Primary REQs: RQ-SHELL-CLI-INTERFACE, RQ-SHELL-CLI-STORAGE, RQ-SHELL-OUTPUT-REQUIREMENTS, RQ-SHELL-AUTOMATIC-CHECKSUM, RQ-SHELL-CLI-ZERO-ARGUMENTS.
# Labels MUST include TP-IDs (policy-harness-id-notation / PM-SHELL-CLI-TEST-PLAN).
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface (TP-CLI / TP-CSUM / TP-U)"

    require_cmd sh
    require_cmd sha256sum
    require_cmd grep

    # --- TP-CLI-01: syntax + companion Shape A ---
    sh -n "${SCRIPT}"
    _syn=$?
    assert_eq "TP-CLI-01 sh -n countdown (syntax)" 0 "$_syn"

    _digest="${REPO_ROOT}/src/${APP_NAME}.sha256"
    if [ -f "${_digest}" ]; then
        _expected=$(awk '{print $1; exit}' "${_digest}")
        _actual=$(sha256sum "${SCRIPT}" | awk '{print $1}')
        assert_eq "TP-CLI-01 TP-CSUM-01 src/countdown.sha256 matches src/countdown" "$_expected" "$_actual"
    else
        t_fail "TP-CLI-01 TP-CSUM-01 src/countdown.sha256 missing beside src/countdown"
    fi

    # --- TP-CLI-02: version human + JSON ---
    _out=$(sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version human mentions version" "$_out" "${APP_VERSION}"
    assert_contains "TP-CLI-02 version human mentions app" "$_out" "countdown"

    _out=$(sh "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version --json type" "$_out" '"type":"version"'
    assert_contains "TP-CLI-02 version --json app" "$_out" '"app":"countdown"'
    assert_contains "TP-CLI-02 version --json version field" "$_out" "\"version\":\"${APP_VERSION}\""
    assert_contains "TP-CLI-02 version human via app_version" "$(sh "${SCRIPT}" version 2>/dev/null)" "${APP_VERSION}"

    # --- TP-CLI-03: help Type 0 surface (CHECKSUM absent → TP-CSUM-05) ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-03 help lists install" "$_out" "install"
    assert_contains "TP-CLI-03 help lists version-check" "$_out" "version-check"
    assert_contains "TP-CLI-03 help lists self-update" "$_out" "self-update"
    assert_contains "TP-CLI-03 help lists self-uninstall" "$_out" "self-uninstall"
    assert_contains "TP-CLI-03 help lists about" "$_out" "about"
    assert_contains "TP-CLI-03 help lists start (domain)" "$_out" "start"
    assert_contains "TP-CLI-03 help lists stop (domain)" "$_out" "stop"
    assert_contains "TP-CLI-03 help lists status (domain)" "$_out" "status"
    assert_contains "TP-CLI-03 help lists list (domain)" "$_out" "list"
    assert_contains "TP-CLI-03 help lists kill (domain)" "$_out" "kill"
    assert_contains "TP-CLI-03 help lists reset (domain)" "$_out" "reset"
    assert_contains "TP-CLI-03 help empty argv is install-ensure" "$_out" "no command"
    assert_contains "TP-CLI-03 help privilege people words" "$_out" "normal user privilege"
    assert_contains "TP-CLI-03 help lists --persist" "$_out" "--persist"
    assert_contains "TP-CLI-03 help lists --json" "$_out" "--json"
    assert_contains "TP-CLI-03 help lists --force" "$_out" "--force"
    assert_contains "TP-CLI-03 help lists --debug" "$_out" "--debug"
    assert_contains "TP-CLI-03 help lists REPO_USER" "$_out" "REPO_USER"
    assert_contains "TP-CLI-03 help lists REPO_NAME" "$_out" "REPO_NAME"
    assert_contains "TP-CLI-03 help lists SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_contains "TP-CLI-03 help lists SCRIPT_RELPATH" "$_out" "SCRIPT_RELPATH"
    assert_not_contains "TP-CLI-03 TP-CSUM-05 help must not list CHECKSUM" "$_out" "CHECKSUM"
    _assign=$(grep '^: "${SCRIPT_URL:=' "${SCRIPT}" 2>/dev/null | head -1 || true)
    assert_contains "TP-CLI-03 SCRIPT_URL composes SCRIPT_RELPATH" "$_assign" 'main/${SCRIPT_RELPATH}'
    _rel=$(grep '^: "${SCRIPT_RELPATH:=' "${SCRIPT}" 2>/dev/null | head -1 || true)
    assert_contains "TP-CLI-03 SCRIPT_RELPATH default is src/APP_NAME" "$_rel" 'src/${APP_NAME}'
    _channel=$(
        SCRIPT_URL= SCRIPT_RELPATH= REPO_USER= REPO_NAME= \
        sh "${SCRIPT}" help 2>/dev/null
    )
    assert_contains "TP-CLI-03 help default channel is src/countdown" "$_channel" \
        "https://raw.githubusercontent.com/Wilgat/countdown/main/src/countdown"

    # --- TP-CLI-04: help/about JSON purity ---
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 help --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 help --json type success" "$_out" '"type":"success"'
    assert_contains "TP-CLI-04 help --json command help" "$_out" '"command":"help"'
    assert_contains "TP-CLI-04 help --json note lists start" "$_out" "start"
    assert_contains "TP-CLI-04 help --json note lists self-uninstall" "$_out" "self-uninstall"

    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 about --json type" "$_out" '"type":"about"'
    assert_contains "TP-CLI-04 about --json app" "$_out" '"app":"countdown"'
    assert_not_contains "TP-CLI-04 TP-CSUM-05 about --json must not include CHECKSUM" "$_out" "CHECKSUM"

    # --- TP-CLI-05: about cache folder AND persistence folder ---
    # Linux / Git Bash / Mac chains, silent skip, leaf mode 700 (TP-STORAGE-04).
    ci_isolated_env
    _login=$(id -un 2>/dev/null || echo "unknown")
    _out=$(HOME="${CI_HOME}" sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-05 about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-05 about --json cache_used" "$_out" '"cache_used"'
    assert_contains "TP-CLI-05 about --json cache_preferred" "$_out" '"cache_preferred"'
    assert_contains "TP-CLI-05 about --json cache_fallback" "$_out" '"cache_fallback"'
    assert_contains "TP-CLI-05 about --json cache_fallback_2" "$_out" '"cache_fallback_2"'
    assert_contains "TP-CLI-05 about --json persistence_storage" "$_out" "${CI_HOME}/.local/countdown"
    assert_contains "TP-CLI-05 about --json effective_storage" "$_out" '"effective_storage"'
    assert_contains "TP-CLI-05 about --json storage_dir" "$_out" '"storage_dir"'
    assert_not_contains "TP-CLI-05 about --json has no CHECKSUM" "$_out" "CHECKSUM"
    _pref=$(printf '%s' "$_out" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _pid="${_pref##*-}"
    case "${_pref}" in
        /dev/shm/cache/cache-"${APP_NAME}"-"${_login}"-[0-9]*)
            t_pass "TP-CLI-05 cache_preferred is shm login process leaf"
            ;;
        *) t_fail "TP-CLI-05 cache_preferred unexpected: '${_pref:-empty}'" ;;
    esac
    _fb=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 cache_fallback 1st" "/tmp/cache/cache-${APP_NAME}-${_login}-${_pid}" "${_fb}"
    _fb2=$(printf '%s' "$_out" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 cache_fallback 2nd" "${CI_HOME}/.cache/cache-${APP_NAME}-${_pid}" "${_fb2}"
    _sdir=$(printf '%s' "$_out" | sed -n 's/.*"storage_dir":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 storage_dir is 1st fallback" "${_fb}" "${_sdir}"
    _used=$(printf '%s' "$_out" | sed -n 's/.*"cache_used":"\([^"]*\)".*/\1/p' | head -n1)
    _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 cache_used matches effective" "${_eff}" "${_used}"
    if [ -n "$_eff" ] && [ -d "$_eff" ]; then
        t_pass "TP-STORAGE-04 effective cache directory exists"
    else
        t_fail "TP-STORAGE-04 effective cache missing: '${_eff:-empty}'"
    fi
    case "${_eff}" in
        /dev/shm/"${APP_NAME}"|/dev/shm/"${APP_NAME}"-*)
            t_fail "TP-CLI-05 effective cache must not be ram-drive project shape: '${_eff}'"
            ;;
        *) t_pass "TP-CLI-05 effective cache is not a ram-drive project shape" ;;
    esac
    _mode=$(ls -ld "${_eff}" 2>/dev/null || true)
    case "${_mode}" in
        drwx------*) t_pass "TP-STORAGE-04 cache leaf mode 700 (${_eff})" ;;
        *) t_fail "TP-STORAGE-04 cache leaf not private (${_mode})" ;;
    esac
    _err=$(HOME="${CI_HOME}" COUNTDOWN_CACHE_SKIP=preferred \
        sh "${SCRIPT}" about 2>&1 >/dev/null)
    assert_not_contains "TP-CLI-05 silent cache fallback" "${_err}" "fallback"
    assert_not_contains "TP-CLI-05 silent cache fallback error" "${_err}" "Cannot create cache"
    _skip=$(HOME="${CI_HOME}" COUNTDOWN_CACHE_SKIP=preferred \
        sh "${SCRIPT}" --json about 2>/dev/null)
    _skip_eff=$(printf '%s' "$_skip" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
    _skip_fb=$(printf '%s' "$_skip" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 skipped preferred uses 1st fallback" "${_skip_fb}" "${_skip_eff}"
    _gb=$(HOME="${CI_HOME}" COUNTDOWN_CACHE_HOST=gitbash sh "${SCRIPT}" --json about 2>/dev/null)
    _gb_pref=$(printf '%s' "$_gb" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _gb_pid="${_gb_pref##*-}"
    assert_eq "TP-CLI-05 gitbash preferred" "/tmp/cache/cache-${APP_NAME}-${_login}-${_gb_pid}" "${_gb_pref}"
    _gb_fb=$(printf '%s' "$_gb" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 gitbash 1st fallback" "${CI_HOME}/AppData/Local/Temp/cache-${APP_NAME}-${_gb_pid}" "${_gb_fb}"
    assert_contains "TP-CLI-05 gitbash json has cache_fallback_2" "${_gb}" '"cache_fallback_2":""'
    _gb_fb2=$(printf '%s' "$_gb" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 gitbash no 2nd fallback" "" "${_gb_fb2}"
    _mac=$(HOME="${CI_HOME}" COUNTDOWN_CACHE_HOST=mac sh "${SCRIPT}" --json about 2>/dev/null)
    _mac_pref=$(printf '%s' "$_mac" | sed -n 's/.*"cache_preferred":"\([^"]*\)".*/\1/p' | head -n1)
    _mac_pid="${_mac_pref##*-}"
    assert_eq "TP-CLI-05 mac preferred" "/tmp/cache/cache-${APP_NAME}-${_login}-${_mac_pid}" "${_mac_pref}"
    _mac_fb=$(printf '%s' "$_mac" | sed -n 's/.*"cache_fallback":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 mac 1st fallback" "${CI_HOME}/Library/Caches/cache-${APP_NAME}-${_mac_pid}" "${_mac_fb}"
    _mac_fb2=$(printf '%s' "$_mac" | sed -n 's/.*"cache_fallback_2":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 mac 2nd fallback" "${CI_HOME}/cache/cache-${APP_NAME}-${_mac_pid}" "${_mac_fb2}"
    _hum=$(HOME="${CI_HOME}" sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-05 about human Cache folder used" "${_hum}" "Cache folder used:"
    assert_contains "TP-CLI-05 about human Cache folder preferred" "${_hum}" "Cache folder (preferred):"
    assert_contains "TP-CLI-05 about human Cache folder 1st fallback" "${_hum}" "Cache folder (1st fallback):"
    assert_contains "TP-CLI-05 about human Cache folder 2nd fallback" "${_hum}" "Cache folder (2nd fallback):"
    assert_contains "TP-CLI-05 about human Persistence storage" "${_hum}" "Persistence storage:"
    assert_not_contains "TP-CLI-05 no Storage (effective) label" "${_hum}" "Storage (effective)"
    assert_not_contains "TP-CLI-05 no Storage (fallback) label" "${_hum}" "Storage (fallback)"
    assert_not_contains "TP-CLI-05 no Cache folder (chosen)" "${_hum}" "Cache folder (chosen)"
    assert_contains "TP-CLI-05 about human preferred path" "${_hum}" "/dev/shm/cache/cache-${APP_NAME}-${_login}-"
    assert_contains "TP-CLI-05 about human 2nd path" "${_hum}" "/.cache/cache-${APP_NAME}-"
    assert_contains "TP-CLI-05 about human persistence path" "${_hum}" "${CI_HOME}/.local/countdown"
    if [ -n "${_eff}" ]; then
        assert_contains "TP-CLI-05 about human used path" "${_hum}" "Cache folder used:"
    fi
    _hum_gb=$(HOME="${CI_HOME}" COUNTDOWN_CACHE_HOST=gitbash sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-05 gitbash about 1st" "${_hum_gb}" "AppData/Local/Temp/cache-${APP_NAME}-"
    assert_not_contains "TP-CLI-05 gitbash about omits 2nd" "${_hum_gb}" "Cache folder (2nd fallback)"
    _hum_mac=$(HOME="${CI_HOME}" COUNTDOWN_CACHE_HOST=mac sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-CLI-05 mac about 1st" "${_hum_mac}" "Library/Caches/cache-${APP_NAME}-"
    assert_contains "TP-CLI-05 mac about 2nd path" "${_hum_mac}" "Cache folder (2nd fallback): ${CI_HOME}/cache/cache-${APP_NAME}-"
    _persist=$(printf '%s' "$_out" | sed -n 's/.*"persistence_storage":"\([^"]*\)".*/\1/p' | head -n1)
    assert_eq "TP-CLI-05 persistence_storage path" "${CI_HOME}/.local/${APP_NAME}" "${_persist}"
    if [ -n "${_persist}" ] && [ -d "${_persist}" ]; then
        t_pass "TP-CLI-05 persistence folder created"
    else
        t_fail "TP-CLI-05 persistence folder missing (${CI_HOME}/.local/countdown)"
    fi
    case "${_persist}" in
        */.local/bin|*/.local/bin/) t_fail "TP-CLI-05 persistence must not be USER_BIN: '${_persist}'" ;;
        *) t_pass "TP-CLI-05 persistence is not the install bin directory" ;;
    esac
    _pmode=$(ls -ld "${CI_HOME}/.local/countdown" 2>/dev/null || true)
    case "${_pmode}" in
        drwx------*) t_pass "TP-STORAGE-04 persistence folder mode 700" ;;
        *) t_fail "TP-STORAGE-04 persistence folder not private (${_pmode})" ;;
    esac
    ci_cleanup_env

    # --- TP-CLI-13: prompt_ask uses PROMPT_ASK_VALUE; no $(prompt_ capture ---
    if grep -q 'PROMPT_ASK_VALUE="${default}"' "${SCRIPT}" && grep -q 'PROMPT_ASK_VALUE="${answer}"' "${SCRIPT}"; then
        t_pass "TP-CLI-13 prompt_ask assigns PROMPT_ASK_VALUE"
    else
        t_fail "TP-CLI-13 prompt_ask does not assign PROMPT_ASK_VALUE"
    fi
    if grep -n '\$[(]prompt_' "${SCRIPT}" >/dev/null 2>&1; then
        t_fail "TP-CLI-13 ship unit captures a prompt helper"
    else
        t_pass "TP-CLI-13 no command-substitution of prompt helpers"
    fi

    # --- TP-CLI-06: unknown command ---
    _err=$(sh "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command error text" "$_err" "Unknown command"

    _err=$(sh "${SCRIPT}" --json no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command --json exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command --json type error" "$_err" '"type":"out_error"'

    # --- TP-CLI-07: quiet mode (--quiet and -q) ---
    _out=$(sh "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version --quiet exit 0" 0 "$_ec"
    if [ -z "$_out" ]; then
        t_pass "TP-CLI-07 version --quiet suppresses human info"
    else
        _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
        if [ -z "$_trim" ]; then
            t_pass "TP-CLI-07 version --quiet suppresses human info"
        else
            t_fail "TP-CLI-07 version --quiet expected empty stdout, got '$(_trunc "$_out")'"
        fi
    fi
    _out=$(sh "${SCRIPT}" -q version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version -q exit 0" 0 "$_ec"
    _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
    if [ -z "$_trim" ]; then
        t_pass "TP-CLI-07 version -q suppresses human info"
    else
        t_fail "TP-CLI-07 version -q expected empty stdout, got '$(_trunc "$_out")'"
    fi

    # --- --debug does not break version ---
    _out=$(sh "${SCRIPT}" --debug version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 --debug version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 --debug version still reports version" "$_out" "${APP_VERSION}"

    # --- TP-CLI-08 / TP-U-01: HOME unset under set -u ---
    _out=$(env -u HOME sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-08 TP-U-01 env -u HOME version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-08 TP-U-01 env -u HOME version still reports version" "$_out" "${APP_VERSION}"

    # --- TP-CLI-09 / TP-LC-09 / TP-U-02: zero-arg bad channel ---
    ci_isolated_env
    _errf="${CI_HOME}/zero-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/countdown-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CLI-09 TP-LC-09 TP-U-02 zero-arg failed install exits non-zero"
    else
        t_fail "TP-CLI-09 zero-arg failed install expected non-zero exit, got 0 (stdout='$(_trunc "$_out")' err='$(_trunc "$_err")')"
    fi
    assert_file_missing "TP-CLI-09 zero-arg failed install left no binary" "${CI_USER_BIN}/countdown"
    # Not silent: stderr or stdout has content
    if [ -n "$_err" ] || [ -n "$_out" ]; then
        t_pass "TP-CLI-09 zero-arg fail is not silent"
    else
        t_fail "TP-CLI-09 zero-arg fail was silent (0-byte out+err)"
    fi
    ci_cleanup_env

    # --- TP-CLI-11: self-uninstall --json without force ---
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}"
    cp "${SCRIPT}" "${CI_USER_BIN}/countdown"
    chmod +x "${CI_USER_BIN}/countdown"
    _errf="${CI_HOME}/un-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CLI-11 self-uninstall --json without --force exit 1" 1 "$_ec"
    assert_contains "TP-CLI-11 self-uninstall --json confirm_required code" "$_err" '"code":"confirm_required"'
    assert_contains "TP-CLI-11 self-uninstall --json out_error type" "$_err" '"type":"out_error"'
    assert_not_contains "TP-CLI-11 self-uninstall --json must not fake success cancel" "$_out$_err" "cancelled by user"
    assert_file_exists "TP-CLI-11 binary remains without --force" "${CI_USER_BIN}/countdown"
    ci_cleanup_env

    # --- TP-CLI-12: out_json string-key contract ---
    # Countdown out_json string-escapes all k/v pairs (no @raw nested extension yet).
    # Lock escape + string embedding; @key raw nested is n/a until product gains it.
    _harness=$(mktemp "${TMPDIR:-/tmp}/cd-outjson.XXXXXX")
    {
        printf '%s\n' 'JSON=1'
        sed -n '/^util_json_escape()/,/^}/p' "${SCRIPT}"
        sed -n '/^out_json()/,/^}/p' "${SCRIPT}"
        printf '%s\n' 'out_json "t" "m" "plain" "v" "name" "ci-smoke"'
    } > "${_harness}"
    _out=$(sh "${_harness}" 2>/dev/null)
    _ec=$?
    rm -f "${_harness}"
    assert_eq "TP-CLI-12 out_json string-key harness exit 0" 0 "$_ec"
    assert_contains "TP-CLI-12 out_json type" "$_out" '"type":"t"'
    assert_contains "TP-CLI-12 out_json plain string key" "$_out" '"plain":"v"'
    assert_contains "TP-CLI-12 out_json name field" "$_out" '"name":"ci-smoke"'
    t_pass "TP-CLI-12 @key raw nested n/a (countdown out_json string-escapes all pairs)"
}
