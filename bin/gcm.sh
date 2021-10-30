#!/bin/bash
#MSG="$1"
MSG="$@" # note: don't use: $*
echo "# > git commit -am \"$MSG\" ... "
git commit -am "$MSG"
#
