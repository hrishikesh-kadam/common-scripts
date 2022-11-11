#!/usr/bin/env bats

setup_file() {
  cd "$( dirname "$BATS_TEST_FILENAME" )" || exit
  gcloud config configurations create empty || true
  gcloud config configurations delete test-config --quiet || true
}

setup() {
  if [[ ! -x $(command -v starship) ]]; then
    skip
  fi
  load "$NPM_ROOT_GLOBAL/bats-support/load.bash"
  load "$NPM_ROOT_GLOBAL/bats-assert/load.bash"
  gcloud config configurations create test-config || true
}

teardown() {
  gcloud config configurations activate empty
  gcloud config configurations delete test-config --quiet || true
}

@test "starship module gcloud | test empty" {
  run starship module gcloud
  assert_output ""
}

@test "starship module gcloud | test with account" {
  gcloud config set account test@example.com --quiet
  run starship module gcloud
  assert_output "[1;34m☁️  test@example.com [0m"
}

@test "starship module gcloud | test with account, project" {
  gcloud config set account test@example.com --quiet
  gcloud config set project test-project --quiet
  run starship module gcloud
  assert_output "[1;34m☁️  test@example.com (test-project) [0m"
}

@test "starship module gcloud | test with project" {
  gcloud config set project test-project --quiet
  run starship module gcloud
  assert_output "[1;34m☁️  (test-project) [0m"
}
