#!/bin/bash
#= create-keep-file-in-directory.sh 
# (c)2022 John@de-Graaff.net
#
BASENAME=`basename $0`
MYUID=$( id -u )
usage() {
  #echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -m MM ] [ -d DD ] [-h HH ] [ -i MM ] [-s SS] } " 1>&2 
  echo "# usage: gfind . -type d | $BASENAME " 1>&2 
  exit 1
}
#
#if [ $MYUID != 0 ]; then
#  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
#fi
#
#if [ -f ${SYS_FILE} ]; then
#else
#fi
#
KEEP=".keep"
while read LINE ; do
  #echo "# '$LINE' ... "
  NEWFILE="${LINE}/${KEEP}"
  echo "# touch '$NEWFILE' ... "
  touch $NEWFILE
done
#
exit 0
#-eof
