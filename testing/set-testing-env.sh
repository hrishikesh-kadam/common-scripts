# shellcheck shell=sh

# This shell script is mean to be sourced for unit testing

. "$PRIMARY_OS_ROOT/main-data/dev/scripts/logs/set-logs-env.sh"

total_tests=0
failed_tests=0

test_suite_init() {
  echo "Test Suite $*"
  total_tests=0
  failed_tests=0
}

#######################################
# Usage:
#   For commands - run_test "echo 'hello world!'"
#   For functions - run_test -f "print_in_green 'hello world!'"
#######################################
run_test() (
  if [ "$1" = "-f" ]; then
    print_in_cyan "$2"
    $2
  else
    print_in_cyan "$1"
    sh -c "$1"
  fi
)

assert_test() {
  total_tests=$(( total_tests + 1 ))
  current_test=$total_tests
  if [ "$1" -eq "$2" ]; then
    print_in_green "Test number $current_test passed"
  else
    print_in_red "Test number $current_test failed"
    echo "Actual: $1, Expected: $2"
    failed_tests=$(( failed_tests + 1 ))
  fi
  unset current_test
}

test_summary() {
  if [ $total_tests -eq 0 ]; then
    echo "No tests were performed"
    exit 1
  elif [ $total_tests -eq 1 ]; then
    test_word="test"
  else
    test_word="tests"
  fi

  if [ $failed_tests -eq 0 ]; then
    print_in_green "$total_tests of $total_tests $test_word passed"
    unset total_tests
    unset failed_tests
    exit 0
  else
    print_in_red "$failed_tests of $total_tests $test_word failed"
    unset total_tests
    unset failed_tests
    exit 1
  fi
}
