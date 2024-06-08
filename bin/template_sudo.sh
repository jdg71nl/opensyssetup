#!/bin/bash
#= debian_install_default_apt.sh
# (c)2023 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
#if ! which dpkg-query >/dev/null ; then echo_exit1 "# please install first: using ==> sudo apt install dpkg-query "; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
# some_cmd
# # exit if the last command failed
# if [ $? -ne 0 ]; then exit 1; fi
#
# my statements here ...
#
#
exit 0
#
#-eof
