#!/bin/bash

# not space-transparant:
#tar czf - $* | openssl base64
#
# space-transparant:
#tar czf - "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"  | openssl base64
#
#echo 'tar czf - file-or-dir | openssl base64'

#tar czf - "$*" | openssl base64
tar czf - "$@" | openssl base64

# ---

# http://mywiki.wooledge.org/BashFAQ/031
# What is the difference between test, [ and [[ ?
# [ ("test" command) and [[ ("new test" command) are used to evaluate expressions.

# ---
# found: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"
	case $key in
		 -e|--extension)
		 EXTENSION="$2"
		 shift # past argument
		 shift # past value
		 ;;
		 --default)
		 DEFAULT=YES
		 shift # past argument
		 ;;
		 *)    # unknown option
		 POSITIONAL+=("$1") # save it in an array for later
		 shift # past argument
		 ;;
	esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# ---

