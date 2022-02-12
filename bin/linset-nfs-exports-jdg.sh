#!/bin/bash
#= linset-nfs-export-jdg.sh
# (c)2022 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME " 1>&2 
  exit 1
}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ; fi
#
echo "# > apt install -y nfs-kernel-server ... "
apt install -y nfs-kernel-server
echo "# done. "
echo "# "
#
echo "# > cat ~/opensyssetup/debian/etc/exports >> /etc/exports .."
cat ~/opensyssetup/debian/etc/exports >> /etc/exports
echo "# !!!!! ==> please check and edit: > sudo vi /etc/exports "
echo "# done. "
echo "# "
#
echo "# > echo '...' >> /etc/rc.local ... "
echo -e "# /etc/rc.local \n\n# jdg: required for nfs: \n/usr/sbin/rpc.statd\n# or?: /sbin/rpc.statd\n\n# need to exit with code 0 .. \n\nexit 0 \n" >> /etc/rc.local
chmod 755 /etc/rc.local
echo "# !!!!! ==> please check and edit: > sudo vi /etc/rc.local "
echo "# done. "
echo "# "
#
#-EOF
