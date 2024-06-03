#!/usr/bin/env bash

# This script shows tmux spinner with a message. It is intended to be running
# as a background process which should be `kill`ed at the end.
#
# Example usage:
#
#   ./tmux_spinner.sh "Working..." "End message!" &
#   SPINNER_PID=$!
#   ..
#   .. execute commands here
#   ..
#   kill $SPINNER_PID # Stops spinner and displays 'End message!'

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

MESSAGE="$1"
END_MESSAGE="$2"
DEFAULT_SPIN_CHARS='-\|/'
SPIN_CHARS=$( get_tmux_option "$spinner_chars_option" "$DEFAULT_SPIN_CHARS" )
SPIN_CHARS_LENGTH=$( echo -n "$SPIN_CHARS" | wc -m )

trap "tmux display-message '$END_MESSAGE'; exit" SIGINT SIGTERM

main() {
	local i=0
	while true; do
	  i=$(( (i+1) % $SPIN_CHARS_LENGTH ))
	  tmux display-message " ${SPIN_CHARS:$i:1} $MESSAGE"
	  sleep 0.1
	done
}
main
