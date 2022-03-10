#!/bin/bash
#= gcm.sh
#MSG="$1"
#MSG="$@" # note: don't use: $*
#git commit -am "'$MSG'"
# https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments
echo "# NOTE: use \"double-quotes\" around the commit-message, like: gcm.sh \"my commit msg with <any> special chars like $.\"  ..! "
echo "# > git commit -am \"$@\" ... "
git commit -am "$@" 
#
