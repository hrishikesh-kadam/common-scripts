#!/usr/bin/env bats

set -e -o pipefail

setup_file() {
  cd "$( dirname "$BATS_TEST_FILENAME" )"
  bats_require_minimum_version 1.5.0
  # To disable shellcheck SC2154
  stderr=""
  stderr_lines=[]
}

setup() {
  load "$NPM_ROOT_GLOBAL/bats-support/load.bash"
  load "$NPM_ROOT_GLOBAL/bats-assert/load.bash"
  . "$COMMON_SCRIPTS_ROOT/logs/logs-env.sh"
}

@test "print_in_red" {
  run print_in_red "Print in red"
  assert_output "[31mPrint in red[0m"
}

@test "print_in_yellow" {
  run print_in_yellow "Print in yellow"
  assert_output "[33mPrint in yellow[0m"
}

@test "print_in_green" {
  run print_in_green "Print in green"
  assert_output "[32mPrint in green[0m"
}

@test "print_in_cyan" {
  run print_in_cyan "Print in cyan"
  assert_output "[36mPrint in cyan[0m"
}

@test "log_error" {
  run --separate-stderr log_error "Error log"
  [[ $stderr == "[31mError: Error log[0m" ]]
}

@test "log_warning" {
  run log_warning "Warning log"
  assert_output "[33mWarning: Warning log[0m"
}

@test "log_info" {
  run log_info "Info log"
  assert_output "[32mInfo: Info log[0m"
}

@test "log_debug" {
  run log_debug "Debug log"
  assert_output "[36mDebug: Debug log[0m"
}

@test "PRINT_WARNING_LOG=0 log_warning" {
  PRINT_WARNING_LOG=0
  run log_warning "Warning log"
  [ -z "${lines[0]}" ]
}

@test "PRINT_INFO_LOG=0 log_info" {
  PRINT_INFO_LOG=0
  run log_info "Info log"
  [ -z "${lines[0]}" ]
}

@test "PRINT_DEBUG_LOG=0 log_debug" {
  PRINT_DEBUG_LOG=0
  run log_debug "Debug log"
  [ -z "${lines[0]}" ]
}

@test "print_in_green 1st-argument 2nd-argument" {
  run print_in_green "1st-argument" "2nd-argument"
  assert_output "[32m1st-argument 2nd-argument[0m"
}

@test "print_in_green multi-line" {
  run print_in_green "1st-line
2nd-line"
  assert_line --index 0 "[32m1st-line"
  assert_line --index 1 "2nd-line[0m"
}

@test "print_in_green with escape sequences" {
  run print_in_green "C:\n_escape\t_sequences"
  assert_output "[32mC:\n_escape\t_sequences[0m"
}

@test "log_error_with_exit Error log 0" {
  run --separate-stderr log_error_with_exit "Error log" 0
  [[ $stderr == "[31mError: Error log[0m" ]]
  assert_success
}

@test "log_error_with_exit Error log 1" {
  run --separate-stderr log_error_with_exit "Error log" 1
  [[ $stderr == "[31mError: Error log[0m" ]]
  assert_failure 1
}

@test "log_error_with_help Error log 0" {
  run --separate-stderr log_error_with_help "Error log" 0
  [[ ${stderr_lines[0]} == "[31mError: Error log[0m" ]]
  [[ ${stderr_lines[1]} == "Use -h or --help for details." ]]
  assert_success
}

@test "log_error_with_help Error log 1" {
  run --separate-stderr log_error_with_help "Error log" 1
  [[ ${stderr_lines[0]} == "[31mError: Error log[0m" ]]
  [[ ${stderr_lines[1]} == "Use -h or --help for details." ]]
  assert_failure 1
}
