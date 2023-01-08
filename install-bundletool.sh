#!/usr/bin/env bash

set -e

LATEST_VERSION=$( \
  curl -s "https://api.github.com/repos/google/bundletool/releases/latest" \
  | jq .name -r)
curl -o "$ANDROID_SDK_ROOT/bundletool-all.jar" \
  -sL "https://github.com/google/bundletool/releases/download/$LATEST_VERSION/bundletool-all-$LATEST_VERSION.jar"
# shellcheck disable=SC2139
alias bundletool="java -jar $ANDROID_SDK_ROOT/bundletool-all.jar"
