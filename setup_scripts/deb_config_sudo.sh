#!/bin/bash
#= 
# (c)2024 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
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
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
f_check_install_packages() { 
  for PKG in $@ ; do 
    if ! dpkg-query -l $PKG >/dev/null ; then 
      echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
      sudo apt install -y $PKG 
    fi
  done
}
f_check_install_packages sudo
#
#

echo "# updating /etc/sudoers ... (check with 'visudo') "
cat >> /etc/sudoers <<HERE

# jdg
Defaults editor=/usr/bin/vim
# %sudo ALL=(ALL) NOPASSWD:ALL
jdg ALL=(ALL) NOPASSWD:ALL
# optionally: add existing user to an existing group:
# > adduser jdg sudo

HERE



#
exit 0
#
#-eof

