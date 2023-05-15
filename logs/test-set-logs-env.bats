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
  . "$COMMON_SCRIPTS_ROOT/logs/set-logs-env.sh"
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

@test "error_log" {
  run --separate-stderr error_log "Error log"
  [[ $stderr == "[31mERROR: Error log[0m" ]]
}

@test "warning_log" {
  run warning_log "Warning log"
  [ -z "${lines[0]}" ]
}

@test "info_log" {
  run info_log "Info log"
  [ -z "${lines[0]}" ]
}

@test "debug_log" {
  run debug_log "Debug log"
  [ -z "${lines[0]}" ]
}

@test "PRINT_WARNING_LOG=1 warning_log" {
  PRINT_WARNING_LOG=1
  run warning_log "Warning log"
  assert_output "[33mWARNING: Warning log[0m"
}

@test "PRINT_INFO_LOG=1 info_log" {
  PRINT_INFO_LOG=1
  run info_log "Info log"
  assert_output "[32mINFO: Info log[0m"
}

@test "PRINT_DEBUG_LOG=1 debug_log" {
  PRINT_DEBUG_LOG=1
  run debug_log "Debug log"
  assert_output "[36mDEBUG: Debug log[0m"
}

@test "print_in_green 1st-argument 2nd-argument" {
  run print_in_green "1st-argument" "2nd-argument"
  assert_output "[32m1st-argument 2nd-argument[0m"
}

@test "print_in_green multi-line or with escape sequences" {
  run print_in_green "1st-line\n2nd-line"
  # assert_line --index 0 "[32m1st-line"
  # assert_line --index 1 "2nd-line[0m"
  assert_output "[32m1st-line\n2nd-line[0m"
}

@test "error_log_with_exit Error log 0" {
  run --separate-stderr error_log_with_exit "Error log" 0
  [[ $stderr == "[31mERROR: Error log[0m" ]]
  assert_success
}

@test "error_log_with_exit Error log 1" {
  run --separate-stderr error_log_with_exit "Error log" 1
  [[ $stderr == "[31mERROR: Error log[0m" ]]
  assert_failure 1
}

@test "error_log_with_help Error log 0" {
  run --separate-stderr error_log_with_help "Error log" 0
  [[ ${stderr_lines[0]} == "[31mERROR: Error log[0m" ]]
  [[ ${stderr_lines[1]} == "Use -h or --help for details." ]]
  assert_success
}

@test "error_log_with_help Error log 1" {
  run --separate-stderr error_log_with_help "Error log" 1
  [[ ${stderr_lines[0]} == "[31mERROR: Error log[0m" ]]
  [[ ${stderr_lines[1]} == "Use -h or --help for details." ]]
  assert_failure 1
}
