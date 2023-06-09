#!/usr/bin/env bash

set -e -o pipefail

source "$COMMON_SCRIPTS_ROOT/logs/set-logs-env.sh"

check_git_ls_files() {
  # TODO(hrishikesh-kadam): Check this on Windows
  if [[ $(uname -s) =~ ^"MINGW" ]]; then
    set +e +o pipefail
  fi
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  saved_git_ls_files="$(< "$CI_SCRIPT_DIR/git-ls-files.txt")"
  current_git_ls_files="$(git ls-files --full-name --recurse-submodules)"
  if [[ "$saved_git_ls_files" != "$current_git_ls_files" ]]; then
    error_log "saved_git_ls_files != current_git_ls_files"
    diff --unified --color \
      <(echo "$saved_git_ls_files") <(echo "$current_git_ls_files")
  else
    print_in_green "saved_git_ls_files == current_git_ls_files"
  fi
  popd &> /dev/null
  if [[ $(uname -s) =~ ^"MINGW" ]]; then
    set -e -o pipefail
  fi
}

check_crlf_files() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  output=$( \
    git ls-files --full-name --recurse-submodules \
      | xargs -I {} dos2unix --info=cdbt {}
  )
  if [[ $output ]]; then
    error_log "Found CRLF Files"
    print_in_red "$output"
    exit 1
  else
    print_in_green "All git tracked files ends with LF"
  fi
  popd &> /dev/null
}

run_scriptanalyzer() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  while read -r file; do
    print_in_cyan "+ Invoke-ScriptAnalyzer $file"
    pwsh -NoProfile -Command "Invoke-ScriptAnalyzer $file -EnableExit"
  done < "$CI_SCRIPT_DIR/scriptanalyzer-input-files.txt"
  popd &> /dev/null
}

run_test_ps1_scripts() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  while read -r file; do
    print_in_cyan "+ pwsh -NoProfile $file"
    pwsh -NoProfile "$file"
  done < "$CI_SCRIPT_DIR/test-ps1-scripts-files.txt"
  popd &> /dev/null
}

run_shellcheck() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  while read -r file; do
    print_in_cyan "+ shellcheck $file"
    shellcheck "$file"
  done < "$CI_SCRIPT_DIR/shellcheck-input-files.txt"
  popd &> /dev/null
}

run_test_bats_scripts() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  while read -r file; do
    if [[ $CI == "true" ]]; then
      print_in_cyan "+ bats -t $file"
      bats -t "$file"
    else
      print_in_cyan "+ bats -p $file"
      bats -p "$file"
    fi
  done < "$CI_SCRIPT_DIR/test-bats-scripts-files.txt"
  popd &> /dev/null
}

run_test_bash_scripts() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  while read -r file; do
    print_in_cyan "+ bash $file"
    bash "$file"
  done < "$CI_SCRIPT_DIR/test-bash-scripts-files.txt"
  popd &> /dev/null
}

run_test_sh_scripts() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  while read -r file; do
    print_in_cyan "+ sh $file"
    sh "$file"
  done < "$CI_SCRIPT_DIR/test-sh-scripts-files.txt"
  popd &> /dev/null
}

main() {
  CI_SCRIPT_DIR="$COMMON_SCRIPTS_ROOT/ci"
  if [[ $COMMON_SCRIPTS_PREREQUISITE != "done" ]]; then
    "$CI_SCRIPT_DIR/prerequisite.sh"
  fi
  check_git_ls_files
  if [[ $(uname -s) =~ ^"MINGW" ]]; then
    check_crlf_files
    run_scriptanalyzer
    run_test_ps1_scripts
  fi
  run_shellcheck
  run_test_bats_scripts
  run_test_bash_scripts
  run_test_sh_scripts
}

# To check if the script is being executed or sourced
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi
