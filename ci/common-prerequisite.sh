#!/usr/bin/env bash

set -e -o pipefail

source "$COMMON_SCRIPTS_ROOT/logs/set-logs-env.sh"
PRINT_DEBUG_LOG=1
PRINT_WARNING_LOG=1

check_command_on_path() {
  if [[ ! -x $(command -v "$1") ]]; then
    error_log_with_exit "$1 command not accessible from PATH" 1
  fi
}

check_directory_on_path() {
  local directory=$1
  if [[ $(uname -s) =~ ^"MINGW" ]]; then
    directory=$(cygpath "$directory")
  fi
  if [[ ! $PATH =~ $directory ]]; then
    error_log_with_exit "$1 directory not found on PATH" 1
  fi
}

if [[ $(uname -s) =~ ^"Darwin" ]]; then
  check_command_on_path brew
elif [[ $(uname -s) =~ ^"MINGW" ]]; then
  check_command_on_path choco
  if [[ ! $GITHUB_ACTIONS ]]; then
    check_command_on_path winget
  fi
fi

if [[ $(uname -s) =~ ^"Darwin" ]]; then
  if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
    brew install bash
    bash --version
  fi
fi

if [[ ! -x $(command -v shellcheck) ]]; then
  if [[ $(uname -s) =~ ^"Linux" ]]; then
    sudo apt install shellcheck
  elif [[ $(uname -s) =~ ^"Darwin" ]]; then
    brew install shellcheck
  elif [[ $(uname -s) =~ ^"MINGW" ]]; then
    choco install shellcheck
  fi
  shellcheck --version
fi

if [[ $(uname -s) =~ ^"Darwin" ]]; then
  if ! diff --version | grep "diff (GNU diffutils) 3" &> /dev/null; then
    brew install diffutils
    diff --version
  fi
fi

check_command_on_path node
check_command_on_path npm
NPM_PREFIX="$(npm config get prefix)"
if [[ $(uname -s) =~ ^"MINGW" ]]; then
  check_directory_on_path "$NPM_PREFIX"
else
  check_directory_on_path "$NPM_PREFIX/bin"
fi

NPM_ROOT_GLOBAL="$(npm root -g)"
if [[ $(uname -s) =~ ^"MINGW" ]]; then
  NPM_ROOT_GLOBAL="$(cygpath "$NPM_ROOT_GLOBAL")"
fi
if ! export -p | grep "declare -x NPM_ROOT_GLOBAL=" &> /dev/null; then
  if [[ $GITHUB_ACTIONS == "true" ]]; then
    echo "NPM_ROOT_GLOBAL=$NPM_ROOT_GLOBAL" >> "$GITHUB_ENV"
  else
    warning_log "NPM_ROOT_GLOBAL variable is not exported"
  fi
fi

if [[ ! -x $(command -v bats) ]]; then
  npm install -g bats
  bats --version
fi
if [[ ! -d "$NPM_ROOT_GLOBAL/bats-support" ]]; then
  npm install -g bats-support
fi
if [[ ! -d "$NPM_ROOT_GLOBAL/bats-assert" ]]; then
  npm install -g bats-assert
fi
