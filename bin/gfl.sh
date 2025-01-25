#!/bin/bash
#= gfl.sh | updated: d250125
# (c)2025 John @ de-Graaff .net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
#
#
# About: this script is intended to replace a 'git pull', and first 'git fetch' so to check for any updates, to prevent merge-conflicts.
#
# https://www.git-scm.com/docs/git-pull
# 'git pull' = 'git fetch' + < either: 'git rebase' or 'git merge' >
# 
#
# used this check same as in 'oss-check-repo.sh':
# examples of:
# > git status --porcelain
# one change:
#   AM bin/gfl.sh
# multiple changes:
#   AM bin/gfl.sh M bin/oss-check-repo.sh
#
# man bash:
# -z string   True if the length of string is zero.
# -n string   True if the length of string is non-zero.
#
GITSTATUS=$(git status --porcelain)
#if [ -z "$(git status --porcelain)" ]; then
if [ -n "$GITSTATUS" ]; then
    echo "# NOTE: there are local changes in this repo -- 'git status --porcelain' says:"
    echo $GITSTATUS
fi
echo "# After 'fetch', first check 'logg', and then decide to 'merge' : "
echo -n '# Press ENTER to continue, CTRL-C to abort...'
read
#
echo "# > git fetch ..."
git fetch
#
echo "# > git logg ..."
git logg
#
#
exit 0
#
#-eof

