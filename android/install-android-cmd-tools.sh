#!/usr/bin/env bash

set -e

FILE_LINK=$(
  curl -s https://developer.android.com/studio#command-tools \
    | grep -o "https://dl.google.com/android/repository/commandlinetools-linux-[0-9]*_latest.zip"
)
FILE_NAME="$(echo "$FILE_LINK" | grep -o "commandlinetools-linux-[0-9]*_latest")"
curl -o "/tmp/android-$FILE_NAME.zip" \
  -sL "$FILE_LINK"
unzip -qo "/tmp/android-$FILE_NAME.zip" "cmdline-tools/*" \
  -d "/tmp/android-$FILE_NAME"
rm -rf "$ANDROID_HOME/cmdline-tools/latest"
mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
mv /tmp/android-"$FILE_NAME"/cmdline-tools/* "$ANDROID_HOME/cmdline-tools/latest/"
