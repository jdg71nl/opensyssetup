#!/bin/bash

# https://stackoverflow.com/questions/28772174/how-can-i-programmatically-in-a-shell-script-determine-whether-or-not-there-ar
#
#: > git diff --quiet; nochanges=$? ; echo "nochanges=$nochanges"
#: nochanges=0
#: #
#: if git diff --quiet; then
#:   # there are no changes
#: else
#:   # there are changes
#: fi
#
# As pointed out in a comment below, the approach outlined above does not cover untracked files. To cover them as well, you can use the following instead:
#: if [ -z "$(git status --porcelain)" ]; then
#:   # there are no changes
#: else
#:   # there are changes
#: fi

if ping -qc1 github.com 2>&1 1>/dev/null ; then echo "true" ; else echo "false" ; fi

#-eof

