# shellcheck shell=sh

set -e

SET_SHELL_ENV_VERBOSE=1
. "$COMMON_SCRIPTS_ROOT/set-shell-env.sh"
. "$COMMON_SCRIPTS_ROOT/logs/logs-env-posix.sh"

echo "Testing logs-env-posix.sh"
echo "-------------------------------------------"

print_in_red "Print in red"
print_in_yellow "Print in yellow"
print_in_green "Print in green"
print_in_cyan "Print in cyan"

echo "-------------------------------------------"

log_error "Error log"
log_warning "Warning log"
log_info "Info log"
log_debug "Debug log"

echo "-------------------------------------------"

( PRINT_WARNING_LOG=0 log_warning "Warning log" )
( PRINT_INFO_LOG=0 log_info "Info log" )
( PRINT_DEBUG_LOG=0 log_debug "Debug log" )

echo "-------------------------------------------"

print_in_green "1st-argument" "2nd-argument"
print_in_green "1st-line
2nd-line"
print_in_green "C:\n_escape\t_sequences"

echo "-------------------------------------------"

( log_error_with_exit "Error log" ) || true
( log_error_with_exit "Error log" 1 ) || true
( log_error_with_exit "Error log" 0 )
( log_error_with_help "Error log" ) || true
( log_error_with_help "Error log" 1 ) || true
( log_error_with_help "Error log" 0 )

echo "-------------------------------------------"
