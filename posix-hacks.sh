# shellcheck shell=sh

if [ -z ${-%*e*} ]; then PARENT_ERREXIT=true; else PARENT_ERREXIT=false; fi
set -e

# Source - http://www.etalabs.net/sh_tricks.html
parse_parameters () {
  for i do printf %s\\n "$i" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/' \\\\/" ; done
  echo " "
}

if [ $PARENT_ERREXIT ]; then set -e; else set +e; fi
