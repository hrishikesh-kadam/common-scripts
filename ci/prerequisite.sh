#!/usr/bin/env bash

set -e -o pipefail

"$COMMON_SCRIPTS_ROOT/ci/common-prerequisite.sh"

COMMON_SCRIPTS_PREREQUISITE="done"
if [[ $GITHUB_ACTIONS == "true" ]]; then
  echo "COMMON_SCRIPTS_PREREQUISITE=$COMMON_SCRIPTS_PREREQUISITE" >> "$GITHUB_ENV"
fi
