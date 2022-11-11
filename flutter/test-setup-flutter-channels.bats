#!/usr/bin/env bats

# shellcheck disable=SC2076

setup_file() {
  cd "$( dirname "$BATS_TEST_FILENAME" )" || exit
  bats_require_minimum_version 1.5.0
  # To disable shellcheck SC2154
  stderr=""
  if [[ "$(command -v trash)" ]]; then
    export DELETE_COMMAND="trash"
  else
    export DELETE_COMMAND="rm -rf"
  fi
  if [[ -d ./testdir ]]; then $DELETE_COMMAND ./testdir; fi
}

setup() {
  load "$NPM_ROOT_GLOBAL/bats-support/load.bash"
  load "$NPM_ROOT_GLOBAL/bats-assert/load.bash"
}

teardown() {
  if [[ -d ./testdir ]]; then $DELETE_COMMAND ./testdir; fi
}

@test "./setup-flutter-channels.sh -h" {
  run ./setup-flutter-channels.sh -h
  assert_failure 79
  assert_output -p "Usage: setup-flutter-channels.sh"
}

@test "./setup-flutter-channels.sh --help" {
  run ./setup-flutter-channels.sh --help
  assert_failure 79
  assert_output -p "Usage: setup-flutter-channels.sh"
}

@test "./setup-flutter-channels.sh -v -h" {
  run ./setup-flutter-channels.sh -v -h
  assert_failure 79
  assert_output -p "Usage: setup-flutter-channels.sh"
  assert_output -p "[--no-long-run]"
}

@test "./setup-flutter-channels.sh --verbose --help" {
  run ./setup-flutter-channels.sh --verbose --help
  assert_failure 79
  assert_output -p "Usage: setup-flutter-channels.sh"
}

@test "./setup-flutter-channels.sh -v --help" {
  run ./setup-flutter-channels.sh -v --help
  assert_failure 79
  assert_output -p "Usage: setup-flutter-channels.sh"
}

@test "./setup-flutter-channels.sh -help" {
  run --separate-stderr ./setup-flutter-channels.sh -help
  assert_failure 80
  [[ "$stderr" =~ "ERROR: Unrecognized option: -help" ]]
}

@test "./setup-flutter-channels.sh --setup-path" {
  run --separate-stderr ./setup-flutter-channels.sh --setup-path
  assert_failure 81
  [[ "$stderr" =~ "--setup-path <path> is needed." ]]
}

@test "./setup-flutter-channels.sh --overwrite" {
  run --separate-stderr ./setup-flutter-channels.sh --overwrite
  assert_failure 81
  [[ "$stderr" =~ "--setup-path <path> is needed." ]]
}

@test "./setup-flutter-channels.sh --channels" {
  run --separate-stderr ./setup-flutter-channels.sh --channels
  assert_failure 84
  [[ "$stderr" =~ "No channels specified." ]]
}

@test "./setup-flutter-channels.sh --channels stable" {
  run --separate-stderr ./setup-flutter-channels.sh --channels stable
  assert_failure 81
  [[ "$stderr" =~ "--setup-path <path> is needed." ]]
}

@test "./setup-flutter-channels.sh --debug" {
  run --separate-stderr ./setup-flutter-channels.sh --debug
  assert_failure 81
  [[ "$stderr" =~ "--setup-path <path> is needed." ]]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir | when testdir is not a writable directory" {
  mkdir ./testdir
  chmod u-w ./testdir
  run --separate-stderr ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir
  assert_failure 82
  [[ "$stderr" =~ "--setup-path ./testdir needs to be a writable directory." ]]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir | when testdir is a writable directory" {
  mkdir ./testdir
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir | when testdir contains testfile.txt" {
  mkdir ./testdir
  touch ./testdir/testfile.txt
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir | when testdir contains empty stable dir" {
  mkdir -p ./testdir/stable
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir | when testdir contains non empty stable dir" {
  mkdir -p ./testdir/stable/tempdir
  run --separate-stderr ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir
  assert_failure 83
  [[ "$stderr" =~ "./testdir/stable is not empty, please append --overwrite after <path> to continue." ]]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --overwrite" {
  mkdir -p ./testdir/stable/tempdir
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --overwrite
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --overwrite --debug" {
  mkdir -p ./testdir/stable/tempdir
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --overwrite --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --debug --setup-path ./testdir --overwrite" {
  mkdir -p ./testdir/stable/tempdir
  run ./setup-flutter-channels.sh --no-long-run --debug --setup-path ./testdir --overwrite
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir/ --debug" {
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir/ --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir// --debug" {
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir// --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta dev master" {
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta dev master
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
  assert [ -d ./testdir/master ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta --debug dev master" {
  run --separate-stderr ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta --debug dev master
  assert_failure 80
  [[ "$stderr" =~ "ERROR: Unrecognized option: dev" ]]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels --debug stable beta dev master" {
  run --separate-stderr ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels --debug stable beta dev master
  assert_failure 84
  [[ "$stderr" =~ "No channels specified." ]]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta dev master --debug" {
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels stable beta dev master --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
  assert [ -d ./testdir/master ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels 2.2.0 stable beta dev master --debug" {
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir --channels 2.2.0 stable beta dev master --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/2.2.0 ]
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
  assert [ -d ./testdir/master ]
}

@test "./setup-flutter-channels.sh --no-long-run --setup-path ./testdir" {
  run ./setup-flutter-channels.sh --no-long-run --setup-path ./testdir
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
}

@test "./setup-flutter-channels.sh --no-long-run --verbose --setup-path ./testdir" {
  run ./setup-flutter-channels.sh --no-long-run --verbose --setup-path ./testdir
  assert_success
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
  assert_output -p "mkdir ./testdir"
  assert_output -p "mkdir ./testdir/stable"
  assert_long_run_block
}

@test "./setup-flutter-channels.sh --no-long-run --verbose --setup-path ./testdir --debug" {
  run ./setup-flutter-channels.sh --no-long-run --verbose --setup-path ./testdir --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ -d ./testdir/stable -a -d ./testdir/beta -a -d ./testdir/dev ]
  assert_output -p "mkdir ./testdir"
  assert_output -p "mkdir ./testdir/stable"
  assert_long_run_block
}

@test "./setup-flutter-channels.sh --dry-run --setup-path ./testdir" {
  run ./setup-flutter-channels.sh --dry-run --setup-path ./testdir
  assert_success
  assert [ ! -d ./testdir/stable -a ! -d ./testdir/beta -a ! -d ./testdir/dev ]
  assert_output -p "mkdir ./testdir"
  assert_output -p "mkdir ./testdir/stable"
  assert_long_run_block
}

@test "./setup-flutter-channels.sh --dry-run --setup-path ./testdir --debug" {
  run ./setup-flutter-channels.sh --dry-run --setup-path ./testdir --debug
  assert_success
  assert_output -p "--setup-path=./testdir"
  assert [ ! -d ./testdir/stable -a ! -d ./testdir/beta -a ! -d ./testdir/dev ]
  assert_output -p "mkdir ./testdir"
  assert_output -p "mkdir ./testdir/stable"
  assert_long_run_block
}

assert_long_run_block() {
  assert_output -p "git clone --branch stable --depth 1 https://github.com/flutter/flutter.git ./testdir/stable"
  assert_output -p "./testdir/stable/bin/flutter precache"
  assert_output -p "./testdir/stable/bin/flutter doctor"
}
