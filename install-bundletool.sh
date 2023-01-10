#!/usr/bin/env bash

# This shell script is meant to be sourced

set -e

install_bundletool() {
  declare -r version=$( \
    curl -s "https://api.github.com/repos/google/bundletool/releases/latest" \
    | jq .name -r)
  curl -o "$ANDROID_SDK_ROOT/bundletool-all.jar" \
    -sL "https://github.com/google/bundletool/releases/download/$version/bundletool-all-$version.jar"
}

install_bundletool
# shellcheck disable=SC2139
alias bundletool="java -jar $ANDROID_SDK_ROOT/bundletool-all.jar"

set +e
