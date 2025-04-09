#!/bin/bash
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
#SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
#SCRIPT_PATH=`dirname $SCRIPT`
#echo "# now cd'ing (change dir) to:"
#cd $SCRIPT_PATH
#pwd
#
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#echo_exit1() { echo $1 ; exit 1 ; }
#
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#.

GFIND="/opt/homebrew/bin/gfind"
GFIND_SYMLINK="/opt/homebrew/bin/find"
FIND="/usr/bin/find"
FIND_BACKUP="$FIND.backup"

if [ ! -f "$GFIND" ]; then
  echo "# gfind not found: install using > brew install findutils "
  exit 1
fi

if [ -f "$FIND_BACKUP" ]; then
  echo "# file '$FIND_BACKUP' already exists ... "
  exit 1
fi

echo "# executing ... "
set -o xtrace

# Below gives error on MacOS 'operation not permitted' :
#mv $FIND $FIND_BACKUP
#cp -av $GFIND $FIND

# better just use symlink in brew, becase brew-path comes before /usr/bin :
ln -s $GFIND $GFIND_SYMLINK

#-eof



