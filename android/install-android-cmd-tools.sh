#!/usr/bin/env bash

set -e -o pipefail

KERNEL_NAME=$(uname -s)
if [[ $KERNEL_NAME =~ ^"MINGW" ]]; then
  OS_SHORT="win"
elif [[ $KERNEL_NAME =~ ^"Darwin" ]]; then
  OS_SHORT="mac"
elif [[ $KERNEL_NAME =~ ^"Linux" ]]; then
  OS_SHORT="linux"
else
  printf "%b\n" "\033[31mError: Unknown Kernel - $KERNEL_NAME\033[0m"
  exit 1
fi

FILE_LINK=$(
  curl -s https://developer.android.com/studio#command-tools \
    | grep -o "https://dl.google.com/android/repository/commandlinetools-$OS_SHORT-[0-9]*_latest.zip"
)
FILE_NAME="$(echo "$FILE_LINK" | grep -o "commandlinetools-$OS_SHORT-[0-9]*_latest")"
curl -o "/tmp/android-$FILE_NAME.zip" \
  -sL "$FILE_LINK"
unzip -qo "/tmp/android-$FILE_NAME.zip" "cmdline-tools/*" \
  -d "/tmp/android-$FILE_NAME"
rm -rf "$ANDROID_HOME/cmdline-tools/latest"
mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
mv /tmp/android-"$FILE_NAME"/cmdline-tools/* "$ANDROID_HOME/cmdline-tools/latest/"
