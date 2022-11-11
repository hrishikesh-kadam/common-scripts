# shellcheck shell=sh

# Source - http://www.etalabs.net/sh_tricks.html
parse_parameters () {
  for i do printf %s\\n "$i" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/' \\\\/" ; done
  echo " "
}
