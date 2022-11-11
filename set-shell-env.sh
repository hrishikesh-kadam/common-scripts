# shellcheck shell=sh

# Source - https://unix.stackexchange.com/a/72475/356166

SET_SHELL_ENV_VERBOSE=${SET_SHELL_ENV_VERBOSE:=0}

if [ "$ZSH_VERSION" ]; then
  PROFILE_SHELL="zsh"
elif [ "$BASH_VERSION" ]; then
  PROFILE_SHELL="bash"
elif [ "$KSH_VERSION" ]; then
  PROFILE_SHELL="ksh"
elif [ "$FCEDIT" ]; then
  PROFILE_SHELL="ksh"
elif [ "$PS3" ]; then
  PROFILE_SHELL="unknown"
else
  PROFILE_SHELL="sh"
fi

export PROFILE_SHELL

if [ $SET_SHELL_ENV_VERBOSE -eq 1 ]; then
  echo "\$SHELL = $SHELL"
  echo "\$PROFILE_SHELL = $PROFILE_SHELL"
fi