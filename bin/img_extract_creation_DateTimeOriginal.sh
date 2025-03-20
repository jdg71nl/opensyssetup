#!/bin/bash
#= 
# (c)2025 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
#echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
#MYUID=$( id -u )
#
usage() {
  echo "# usage:   $BASENAME <filename> " 1>&2 
  #echo "# example: > for FILE in IMG*.PNG IMG*.png IMG*.JP*G IMG*.jp*g ; do echo \"# '\$FILE' :\" ; $BASENAME \"\$FILE\" ; done  " 1>&2 
  echo "# example: > for FILE in IMG_* ; do echo \"# '\$FILE' :\" ; $BASENAME \"\$FILE\" ; done  " 1>&2 
  exit 0
}
#echo_exit1() { echo $1 ; exit 1 ; }
#
#if [ $MYUID != 0 ]; then
#  # $* is a single string, whereas $@ is an actual array.
#  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
#fi
#
#if [ -f ${SOME_FILE} ]; then
#else
#fi
#
# some_cmd
# # exit if the last command failed
# if [ $? -ne 0 ]; then exit 1; fi
#.
# examples:
# > identify -verbose IMG_6186.jpeg | grep DateTimeOriginal
#     exif:DateTimeOriginal: 2024:12:05 18:23:04
# > identify -verbose IMG_6206.PNG | grep DateTimeOriginal
#     exif:DateTimeOriginal: 2024:12:05 18:33:33
#

FILE="$1"

if [ -z "${FILE}" ] || [ ! -f "${FILE}" ]; then
  usage
fi

OK="Yes"

DateTimeOriginal=`identify -verbose "$FILE" | grep DateTimeOriginal`

# Test:
#DateTimeOriginal=""

DATE=""
TIME=""
#
#PATTERN1='git@([^:]+):.*/git/([^\.]+)\.git'
PATTERN1='exif:DateTimeOriginal: ([0-9:]+) ([0-9:]+)'
#
[[ $DateTimeOriginal =~ $PATTERN1 ]] && DATE=${BASH_REMATCH[1]} && TIME=${BASH_REMATCH[2]}

if [[ -z "$DATE" || -z "$TIME" ]]; then
  #echo "# DateTimeOriginal = \"$DateTimeOriginal\" "
  #echo "# PATTERN1 = '$PATTERN1' "
  #echo "# ERROR: regular-expression:extracting !"
  #exit 1
  #
  OK=""
  #
fi

#echo "# DATE = \"$DATE\" "
#echo "# TIME = \"$TIME\" "

# Test:
#DATE=""

YY=""
MM=""
DD=""
PATTERN2='([0-9]+):([0-9]+):([0-9]+)'
[[ $DATE =~ $PATTERN2 ]] && YY=${BASH_REMATCH[1]} && MM=${BASH_REMATCH[2]} && DD=${BASH_REMATCH[3]}

hh=""
mm=""
ss=""
PATTERN2='([0-9]+):([0-9]+):([0-9]+)'
[[ $TIME =~ $PATTERN2 ]] && hh=${BASH_REMATCH[1]} && mm=${BASH_REMATCH[2]} && ss=${BASH_REMATCH[3]}

STAMP="d${YY}${MM}${DD}t${hh}${mm}${ss}"

#echo "# STAMP = \"$STAMP\" "

d=""
t=""
PATTERN3='^d([0-9]{8})t([0-9]{6})$'
[[ $STAMP =~ $PATTERN3 ]] && d=${BASH_REMATCH[1]} && t=${BASH_REMATCH[2]}

if [[ -z "$d" || -z "$t" ]]; then
  #
  OK=""
  #
  #echo "# STAMP = \"$STAMP\" "
  #echo "# PATTERN3 = '$PATTERN3' "
  #echo "# ERROR: regular-expression:extracting !"
  #exit 1
fi

if [[ ! -z "$OK" ]]; then
  #echo "# STAMP = \"$STAMP\" -- FILE = \"$FILE\" "
  mv "$FILE" "$STAMP-$FILE"
else
  #echo "# STAMP = <ERROR> -------------- FILE = \"$FILE\" "
  OK=""
fi

#
exit 0
#
#-eof
