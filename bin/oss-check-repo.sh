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

# JDG: another reason the ping hangs is: no DNS resolve, better ping IP instead hostname
# > host $TARGET
# $TARGET has address 140.82.121.3
#TARGET="github.com"
TARGET="140.82.121.3"
TNAME="github.com($TARGET)"

echo "# > cd ~/opensyssetup "
cd ~/opensyssetup

if [ -z "$(git status --porcelain)" ]; then
  echo "# 'git status --porcelain' says: no (stagged/unstagged) changes in repo."
  #echo "# checking 'ping -4q -c1 -W1 $TNAME' ... "
  echo "# checking 'ping -q -c1 -W1 $TNAME' ... "
  if ping -q -c1 -W1 $TARGET 2>&1 1>/dev/null ; then
    echo "# 'ping -q -c1 -W1 $TNAME' says: remote repo is reachable, now updating (git pull) ..."
    echo "# > git pull "
    git pull 
    echo "# "
    exit 0
  else
    echo "# 'ping -q -c1 -W1 $TNAME' says: repo unreachable ... giving-up." 
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

