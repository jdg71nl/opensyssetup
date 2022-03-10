#!/bin/bash
#MSG="$1"
#MSG="$@" # note: don't use: $*
#git commit -am "'$MSG'"
# https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments
echo "# > git commit -am \"$@\" ... "
git commit -am "$@" 
#
