#!/usr/bin/env bash

source "$COMMON_SCRIPTS_ROOT/logs/logs-env-bash.sh"

declare -i VERBOSE=0
declare -i DRY_RUN=0
declare -i _NO_LONG_RUN=0

usage() {
  printf "Usage: %s [-v|--verbose] [-h|--help] " "$(basename "$0")"
  printf "[--dry-run] --setup-path <path> [--overwrite] "
  printf "[--channels <channels>] [--debug] "
  if (( VERBOSE == 1 )); then
    printf "[--no-long-run] "
  fi
  printf "\n"
  exit 79
}

##################################################
# See also - long_run()
# Globals:
#   VERBOSE
#   DRY_RUN
# Arguments:
#   $1 - Command to run
##################################################
run() {
  if (( DRY_RUN == 1 )); then
    echo "+ $*"
    return
  fi
  if (( VERBOSE == 1 )); then
    echo "+ $*"
  fi
  sh -c "$*"
}

##################################################
# Long running command
# Globals:
#   VERBOSE
#   DRY_RUN
#   _NO_LONG_RUN
# Arguments:
#   $1 - Command to run
##################################################
long_run() {
  if (( DRY_RUN == 1 )); then
    echo "+ $*"
    return
  fi
  if (( VERBOSE == 1 )); then
    echo "+ $*"
  fi
  if (( _NO_LONG_RUN == 0 )); then
    sh -c "$*"
  fi
}

##################################################
# Arguments:
#   $1 - channel array for nameref
#   $2 - rest of the arguments
##################################################
parse_channels() {
  local -n __channels=$1
  __channels=()
  shift;
  while (( $# > 0 )); do
    case $1 in
      -*)
        break
        ;;
      *)
        __channels+=( "$1" ); shift
        ;;
    esac
  done
  if (( ${#__channels[@]} == 0 )); then
    error_log_with_help "No channels specified." 84
  fi
}

##################################################
# Globals:
#   PRINT_DEBUG_LOG
# Arguments:
#   $1 - _NO_LONG_RUN for nameref
#   $2 - VERBOSE for nameref
#   $3 - DRY_RUN for nameref
#   $4 - setup_path for nameref
#   $5 - overwrite for nameref
#   $6 - channel array for nameref
#   $7 - rest of the arguments
##################################################
parse_arguments() {
  local -n _no_long_run=$1
  _no_long_run=0
  local -n _verbose=$2
  _verbose=0
  local -n _dry_run=$3
  _dry_run=0
  local -n _setup_path=$4
  _setup_path=""
  local -n _overwrite=$5
  _overwrite=0
  local -n _channels=$6
  _channels=()
  shift 6;

  while (( $# > 0 )); do
    case $1 in
      --debug)
        PRINT_DEBUG_LOG=1; shift
        ;;
      --no-long-run)
        _no_long_run=1; shift
        ;;
      -v|--verbose)
        _verbose=1; shift
        ;;
      --dry-run)
        _dry_run=1; shift
        ;;
      -h|--help)
        usage
        ;;
      --setup-path)
        _setup_path=$2
        if [[ -z "$2" ]]; then shift; else shift 2; fi
        ;;
      --overwrite)
        _overwrite=1; shift
        ;;
      --channels)
        shift
        parse_channels _channels "$@"
        shift ${#_channels[@]}
        ;;
      *)
        error_log_with_help "Unrecognized option: $1" 80
        ;;
    esac
  done

  if [[ -z "$_setup_path" ]]; then
    error_log_with_help "--setup-path <path> is needed." 81
  elif [[ ! -d "$_setup_path" ]]; then
    run mkdir "$_setup_path"
  elif [[ ! -w "$_setup_path" ]]; then
    error_log_with_help "--setup-path $_setup_path needs to be a writable directory." 82
  fi

  _setup_path=${_setup_path%/}

  if (( ${#_channels[@]} == 0 )); then
    _channels=(stable beta dev)
  fi
}

##################################################
# Arguments:
#   $1 - setup_path
#   $2 - overwrite
#   $3 - channel array
##################################################
setup_flutter_channels() {
  local setup_path=$1
  local -i overwrite=$2
  # shellcheck disable=SC2206
  local -a channels=($3)

  # if [[ "$(command -v trash)" ]]; then
  #   readonly delete_command="trash"
  # else
  #   readonly delete_command="rm -rf"
  # fi
  readonly delete_command="rm -rf"

  for channel in "${channels[@]}"; do
    local channel_path=$setup_path/$channel
    if [[ -d "$channel_path" ]]; then
      if [[ -n "$(ls -A "$channel_path")" ]]; then
        if (( overwrite == 0 )); then
          error_log_with_help "$channel_path is not empty, please append --overwrite after <path> to continue." 83
        else
          run $delete_command "$channel_path"
          run mkdir "$channel_path"
        fi
      fi
    else
      run mkdir "$channel_path"
    fi
  done

  for channel in "${channels[@]}"; do
    (
      local channel_path="$setup_path/$channel"
      long_run git clone --branch "$channel" --depth 1 https://github.com/flutter/flutter.git "$channel_path"
      long_run "$channel_path"/bin/flutter precache
      long_run "$channel_path"/bin/flutter doctor
    )
  done
}

##################################################
# Globals:
#   VERBOSE
#   DRY_RUN
#   _NO_LONG_RUN
# Arguments:
#   Refer usage()
##################################################
main() {
  local setup_path
  local -i overwrite=0
  local -a channels

  parse_arguments _NO_LONG_RUN VERBOSE DRY_RUN setup_path overwrite channels "$@"

  readonly _NO_LONG_RUN
  readonly VERBOSE
  readonly DRY_RUN
  readonly setup_path
  readonly overwrite
  readonly channels

  debug_log "--no-long-run=$_NO_LONG_RUN"
  debug_log "--verbose=$VERBOSE"
  debug_log "--dry-run=$DRY_RUN"
  debug_log "--setup-path=$setup_path"
  debug_log "--overwrite=$overwrite"
  debug_log "--channels=${channels[*]}"

  setup_flutter_channels "$setup_path" $overwrite "${channels[*]}"
}

# To check if the script is being executed of sourced
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi
