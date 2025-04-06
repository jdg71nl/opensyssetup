#!/bin/bash
#= template.sh | updated: d220705
# (c)2022 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
echo "# now cd'ing (change dir) to:"
cd $SCRIPT_PATH
pwd
#
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
#MYUID=$( id -u )
#
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
echo_exit1() { echo $1 ; exit 1 ; }
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
#
# my statements here ...
#
exit 0
#
#-eof
