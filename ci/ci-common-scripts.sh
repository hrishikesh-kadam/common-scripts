#!/usr/bin/env bash

set -e -o pipefail

source "$COMMON_SCRIPTS_ROOT/logs/logs-env-bash.sh"

check_git_ls_files() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  echo "Comparing saved_git_ls_files with current_git_ls_files"
  local saved_git_ls_files
  saved_git_ls_files="$(< "$CI_SCRIPT_DIR/git-ls-files.txt")"
  local current_git_ls_files
  current_git_ls_files="$(git ls-files --full-name --recurse-submodules)"
  if [[ "$saved_git_ls_files" != "$current_git_ls_files" ]]; then
    log_error "saved_git_ls_files != current_git_ls_files"
    diff --unified --color \
      <(echo "$saved_git_ls_files") <(echo "$current_git_ls_files")
  else
    print_in_green "saved_git_ls_files == current_git_ls_files"
  fi
  popd &> /dev/null
}

check_cr_line_endings() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  echo "Checking CR line endings in git tracked files"
  local output
  output=$( \
    git ls-files \
      --full-name \
      --recurse-submodules \
      -z \
      | xargs -0 \
          mac2unix \
            --info=chdumbt \
  )
  if [[ $output ]]; then
    log_error "Found CR line ending File(s)"
    print_in_red "$output"
    exit 1
  else
    print_in_green "Checked CR line endings in git tracked files"
  fi
  popd &> /dev/null
}

check_crlf_line_endings() {
  pushd "$COMMON_SCRIPTS_ROOT" &> /dev/null
  echo "Checking CRLF line endings in git tracked files"
  local output
  output=$( \
    git ls-files \
      --full-name \
      --recurse-submodules \
      -z \
      | xargs -0 \
          dos2unix \
            --info=chdumbt \
  )
  if [[ $output ]]; then
    log_error "Found CRLF line ending File(s)"
    print_in_red "$output"
    exit 1
  else
    print_in_green "Checked CRLF line endings in git tracked files"
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
  check_cr_line_endings
  check_crlf_line_endings
  if [[ $(uname -s) =~ ^"MINGW" ]]; then
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
