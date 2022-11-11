#!/usr/bin/env bash

SET_SHELL_ENV_VERBOSE=1
source "$COMMON_SCRIPTS_ROOT/testing/set-testing-env.sh"

pushd "$COMMON_SCRIPTS_ROOT/flutter" &> /dev/null || exit

if [[ "$(command -v trash)" ]]; then
  readonly delete_command="trash"
else
  readonly delete_command="rm -rf"
fi

run_test "./setup-flutter-channels.sh -h"
assert_test $? 79

run_test "./setup-flutter-channels.sh --help"
assert_test $? 79

run_test "./setup-flutter-channels.sh -v -h"
assert_test $? 79

run_test "./setup-flutter-channels.sh --verbose --help"
assert_test $? 79

run_test "./setup-flutter-channels.sh -v --help"
assert_test $? 79

run_test "./setup-flutter-channels.sh -help"
assert_test $? 80

run_test "./setup-flutter-channels.sh --setup-path"
assert_test $? 81

run_test "./setup-flutter-channels.sh --overwrite"
assert_test $? 81

run_test "./setup-flutter-channels.sh --channels"
assert_test $? 84

run_test "./setup-flutter-channels.sh --channels stable"
assert_test $? 81

run_test "./setup-flutter-channels.sh --debug"
assert_test $? 81

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir ./testdir
chmod u-w ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir"
assert_test $? 82
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir ./testdir
touch ./testdir/testfile.txt
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir -p ./testdir/stable
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir -p ./testdir/stable/tempdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir"
assert_test $? 83
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir -p ./testdir/stable/tempdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --overwrite"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir -p ./testdir/stable/tempdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --overwrite --debug"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
mkdir -p ./testdir/stable/tempdir
run_test "./setup-flutter-channels.sh --no-long-run --debug --setup-path ./testdir --overwrite"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir/ --debug"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir// --debug"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta dev master"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta --debug dev master"
assert_test $? 80
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels --debug stable beta dev master"
assert_test $? 84
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta dev master --debug"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels 2.2.0 stable beta dev master --debug"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --verbose --setup-path ./testdir"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --no-long-run --verbose --setup-path ./testdir --debug"
assert_test $? 0
$delete_command ./testdir

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --dry-run --setup-path ./testdir"
assert_test $? 0
[[ ! -d ./tempdir ]]
assert_test $? 0

[[ -d ./testdir ]] && $delete_command ./testdir
run_test "./setup-flutter-channels.sh --dry-run --setup-path ./testdir --debug"
assert_test $? 0
[[ ! -d ./tempdir ]]
assert_test $? 0

[[ -d ./testdir ]] && $delete_command ./testdir

popd &> /dev/null || exit

test_summary
