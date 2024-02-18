#!/bin/bash
#= syssetup-git-pull.sh
# (c)2020 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME "
  echo "# - will check if syssetup.git@local has no updates, and do a pull."
  exit 1
}
#error_usage()  { echo "# $BASENAME: ERROR - $1"; usage       ; }
#error()        { echo "# $BASENAME: ERROR - $1"; exit 1      ; }
#echo_msg_log() { echo "# $BASENAME: ERROR - $1"; logger "$1" ; }
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ;
fi
#
#if [[ -z "$2" ]]; then usage ; fi
#echo "\$MYID=$MYID "
#
cd /usr/local/syssetup
#STATUS=$( git status )
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
  [ -n "$git_status_string" ] && echo "# git repo is dirty, check, commit, push first!" && exit 1 ;
  echo "#  git repo is clean!, so will do: "
  echo "#> git pull .."
  git pull
)
#
