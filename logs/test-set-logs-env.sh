# shellcheck shell=sh

SET_SHELL_ENV_VERBOSE=1
. "$PRIMARY_OS_ROOT/main-data/dev/scripts/logs/set-logs-env.sh"

echo "-------------------------------------------"

print_in_red "Print in red"
print_in_yellow "Print in yellow"
print_in_green "Print in green"
print_in_cyan "Print in cyan"

echo "-------------------------------------------"

error_log "Error log"
warning_log "Warning log"
info_log "Info log"
debug_log "Debug log"

echo "-------------------------------------------"

PRINT_WARNING_LOG=1
warning_log "Warning log"
PRINT_INFO_LOG=1
info_log "Info log"
PRINT_DEBUG_LOG=1
debug_log "Debug log"

echo "-------------------------------------------"

print_in_red "1st-argument" "2nd-argument"
error_with_help "Error message" 0
