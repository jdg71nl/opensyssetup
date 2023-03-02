#!/bin/bash
#= dd_pv_progressview.sh | updated: d230302
# (c)2023 John@de-Graaff.net
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
#SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT=`realpath $0`  
SCRIPT_PATH=`dirname $SCRIPT`
#
#MYUID=$( id -u )
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#if [ $MYUID != 0 ]; then
#  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
#fi
#
#
# INSTALL: > sudo apt install pv
#
#
# https://superuser.com/questions/234199/good-block-size-for-disk-cloning-with-diskdump-dd
# ==> all at or above bs=1k is fine ==> bs=4096
#
# https://unix.stackexchange.com/questions/33099/how-to-check-progress-when-cloning-a-disk-using-dd
# https://askubuntu.com/questions/215505/how-do-you-monitor-the-progress-of-dd
# "You could specify the approximate size with the --size if you want a time estimation."
#
# > dd if=/dev/urandom | pv -s 2G | dd of=/dev/null
# 1.02GiB 0:00:06 [ 182MiB/s] [=======================>     ] 50% ETA 0:00:05
#
echo "# advised usage: "
echo "# > sudo dd if=/dev/sdb | pv -s 2G | dd of=DriveCopy1.dd bs=4096 "
#
exit 0
#
#-eof
