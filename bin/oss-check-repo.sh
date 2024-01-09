#!/bin/bash
#= oss-check-repo.sh

# https://stackoverflow.com/questions/28772174/how-can-i-programmatically-in-a-shell-script-determine-whether-or-not-there-ar
# As pointed out in a comment below, the approach outlined above does not cover untracked files. To cover them as well, you can use the following instead:
#: if [ -z "$(git status --porcelain)" ]; then
#:   # there are no changes
#: else
#:   # there are changes
#: fi

cd ~/opensyssetup

if [ -z "$(git status --porcelain)" ]; then
  echo "# no (stagged/unstagged) changes in repo, checking remote ..."
  if ping -qc1 github.com 2>&1 1>/dev/null ; then
    echo "# remote repo (github.com) is reachable, now updating (git pull) ..."
    echo "# > git pull "
    git pull 
    exit 0
  else
    echo "# repo unreachable ... giving-up." 
    exit 1
  fi
else
    echo "# there are (uncommited) changes ... please check and commit." 
    echo "# > git status -s"
    git status -s
    exit 0
fi

#-eof

