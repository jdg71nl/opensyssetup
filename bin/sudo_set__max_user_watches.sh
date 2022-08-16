#!/bin/bash
#= sudo_set__max_user_watches.sh | updated: d220816
# (c)2022 John@de-Graaff.net
#
#BASENAME=`basename $0`
#SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
#SCRIPT_PATH=`dirname $SCRIPT`
MYUID=$( id -u )
usage() {
 #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
 echo "# usage: $BASENAME " 1>&2 
 exit 1
}
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
SYS_FILE="/etc/sysctl.conf"
PROC_FILE="/proc/sys/fs/inotify/max_user_watches"
#
# if [ -f ${SYS_FILE} ]; then
# else
# fi
#
if grep -q fs.inotify.max_user_watches ${SYS_FILE} ; then 
  echo "# ERROR: setting 'fs.inotify.max_user_watches' already exists in file '${SYS_FILE}'. " ; exit 1 ;
fi
#
cat <<EOF >> ${SYS_FILE}
#
# jdg need for VS Code: https://code.visualstudio.com/docs/setup/linux
fs.inotify.max_user_watches=524288
#
EOF
#
sysctl -p 2&>1 1>/dev/null 
#
WATCHES=$( cat ${PROC_FILE} )
echo "# setting (cat) '/proc/sys/fs/inotify/max_user_watches' now says: ${WATCHES} . "
#
exit 0
#
#-eof
