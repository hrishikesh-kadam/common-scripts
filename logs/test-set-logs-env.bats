#!/usr/bin/env bats

setup_file() {
  cd "$( dirname "$BATS_TEST_FILENAME" )" || exit
}

setup() {
  load "$NPM_ROOT_GLOBAL/bats-support/load.bash"
  load "$NPM_ROOT_GLOBAL/bats-assert/load.bash"
  . "$PRIMARY_OS_ROOT/main-data/dev/scripts/logs/set-logs-env.sh"
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
  run error_log "Error log"
  assert_output "[31mERROR: Error log[0m"
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

@test "print_in_red 1st-argument 2nd-argument" {
  run print_in_red "1st-argument" "2nd-argument"
  assert_output "[31m1st-argument 2nd-argument[0m"
}

@test "error_with_help Error message 0" {
  run error_with_help "Error message" 0
  assert_success
  assert_line -n 0 "[31mERROR: Error message[0m"
  assert_line -n 1 "Use -h or --help for details."
}
