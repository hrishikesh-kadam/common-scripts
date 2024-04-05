#!/usr/bin/env bash

set -e -o pipefail

source "$COMMON_SCRIPTS_ROOT/logs/logs-env.sh"

echo "Checking prerequisite"

"$COMMON_SCRIPTS_ROOT/ci/common-prerequisite.sh"

if [[ $(uname -s) =~ ^"MINGW" ]]; then
  pwsh -NoProfile "$COMMON_SCRIPTS_ROOT/ci/prerequisite.ps1"
fi

COMMON_SCRIPTS_PREREQUISITE="done"
if [[ $GITHUB_ACTIONS == "true" ]]; then
  echo "COMMON_SCRIPTS_PREREQUISITE=$COMMON_SCRIPTS_PREREQUISITE" >> "$GITHUB_ENV"
fi

print_in_green "Checked prerequisite"
