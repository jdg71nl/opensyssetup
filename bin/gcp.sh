#!/bin/bash
#= gcp.sh = git-checkfirst-pull.sh 
# (c)2021 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME "
  echo "# - will check if git-repo is clean (no updates), and then do a pull"
  exit 1
}
#error_usage()  { echo "# $BASENAME: ERROR - $1"; usage       ; }
#error()        { echo "# $BASENAME: ERROR - $1"; exit 1      ; }
#echo_msg_log() { echo "# $BASENAME: ERROR - $1"; logger "$1" ; }
#
git status 2>/dev/null | (
  unset dirty deleted untracked newfile ahead renamed
  while read line ; do
    case "$line" in
      *modified:*)                      dirty='!' ;     ;;
      *deleted:*)                       deleted='x' ;   ;;
      *'Untracked files:')              untracked='?' ; ;;
      *'new file:'*)                    newfile='+' ;   ;;
      *'Your branch is ahead of '*)     ahead='*' ;     ;;
      *renamed:*)                       renamed='>' ;   ;;
    esac
  done
  git_status_string="$dirty$deleted$untracked$newfile$ahead$renamed"
  #[ -n "$git_status_string" ] && echo " $git_status_string" || echo
  #echo "\$git_status_string=\"$git_status_string\""
  #
  #[ -n "$git_status_string" ] && echo "git-dirty"
  #[ -z "$git_status_string" ] && echo "git-clean"
  #
  [ -n "$git_status_string" ] && echo "# git repo is dirty (git_status_string=$git_status_string), check, commit, push first!" && exit 1 ;
  echo "#  git repo is clean!, so will do: "
  echo "#> git pull .."
  git pull
)
#
