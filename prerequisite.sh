#!/usr/bin/env bash

set -e -o pipefail

source "$COMMON_SCRIPTS_ROOT/logs/set-logs-env.sh"

check_command_on_path() {
  if [[ ! -x $(command -v "$1") ]]; then
    error_log_with_exit "$1 command not accessible from PATH" 1
  fi
}

check_directory_on_path() {
  if [[ ! "$PATH" =~ $1 ]]; then
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
  brew install bash
  bash --version
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
  brew install diffutils
  diff --version
fi

check_command_on_path node
check_command_on_path npm
NPM_GLOBAL_PREFIX="$(npm config get prefix)"
if [[ $(uname -s) =~ ^"MINGW" ]]; then
  NPM_GLOBAL_PREFIX="$(cygpath "$NPM_GLOBAL_PREFIX")"
  # TODO(hrishikesh-kadam): Check this on Windows
else
  check_directory_on_path "$NPM_GLOBAL_PREFIX/bin"
fi
