#!/bin/bash
#= oss-check-repo.sh

BASENAME=`basename $0`
echo "# "
echo "# running: $BASENAME ... "

# https://stackoverflow.com/questions/28772174/how-can-i-programmatically-in-a-shell-script-determine-whether-or-not-there-ar
# As pointed out in a comment below, the approach outlined above does not cover untracked files. To cover them as well, you can use the following instead:
#: if [ -z "$(git status --porcelain)" ]; then
#:   # there are no changes
#: else
#:   # there are changes
#: fi

echo "# > cd ~/opensyssetup "
cd ~/opensyssetup

if [ -z "$(git status --porcelain)" ]; then
  echo "# 'git status --porcelain' says: no (stagged/unstagged) changes in repo."
  echo "# checking 'ping -4q -c1 -W1 github.com' ... "
  if ping -4q -c1 -W1 github.com 2>&1 1>/dev/null ; then
    echo "# 'ping -4q -c1 -W1 github.com' says: remote repo (github.com) is reachable, now updating (git pull) ..."
    echo "# > git pull "
    git pull 
    echo "# "
    exit 0
  else
    echo "# 'ping -4q -c1 -W1 github.com' says: repo unreachable ... giving-up." 
    echo "# "
    exit 1
  fi
else
    echo "# 'git status --porcelain' says: there are (unstaged/uncommited) changes ... please check and commit." 
    echo "# > git status -s"
    git status -s
    echo "# "
    exit 0
fi

#-eof

