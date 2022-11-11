# shellcheck shell=sh

SET_SHELL_ENV_VERBOSE=1
. "$PRIMARY_OS_ROOT/main-data/dev/scripts/testing/set-testing-env.sh"

test_suite=0

echo
test_suite=$(( test_suite + 1 ))
(
  test_suite_init $test_suite

  run_test "exit 0"
  assert_test $? 0

  test_summary
)

echo
test_suite=$(( test_suite + 1 ))
(
  test_suite_init $test_suite

  run_test "exit 0"
  assert_test $? 0

  run_test "exit 79"
  assert_test $? 79

  test_summary
)

echo
test_suite=$(( test_suite + 1 ))
(
  test_suite_init $test_suite

  run_test "exit 0"
  assert_test $? 0

  run_test "exit 79"
  assert_test $? 0

  test_summary
)

echo
test_suite=$(( test_suite + 1 ))
(
  test_suite_init $test_suite

  test_summary
)

echo
test_suite=$(( test_suite + 1 ))
(
  test_suite_init $test_suite

  run_test "exit 0"
  assert_test $? 0

  run_test "exit 79"
  assert_test $? 0

  run_test "exit 80"
  assert_test $? 0

  test_summary
)

echo
test_suite=$(( test_suite + 1 ))
(
  test_suite_init $test_suite

  run_test -f "print_in_green Print in green"
  assert_test $? 0

  test_summary
)
