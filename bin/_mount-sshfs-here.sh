#!/bin/bash
#!/usr/bin/env bash
# mount-sshfs-here.sh
# (c)2017 John de Graaff @ DGI

echo
echo "# ===>====>====> DON'T use this script !!"
echo "# instead create a local shell script for each SSHFS dir, like this:"
echo
cat <<HERE
SS="mount_vps3_ingosur.sh" ; SD="./vps3/ingosur/" ; mkdir -pv "\$SD" ; echo "sshfs -p2221 jdg@vps3.dgt-bv.com:SSHFS/INGOSUR/ \"\$SD\" " > "\$SS" ; chmod +x "\$SS"
HERE
echo

exit


# ---

DIR="$1"
SSHFSDIR="/Users/jdg/SSHFS"
SSHFSFILE="$SSHFSDIR/mount-sshfs-here.sh"
GITFILE="/usr/local/syssetup/bin/mount-sshfs-here.sh"

if [[ ! -d $SSHFSDIR ]]; then
	mkdir -p -v $SSHFSDIR
fi
if [[ ! -e $SSHFSFILE ]]; then
	ln -s -v $GITFILE $SSHFSFILE
fi

BASENAME=`basename $0`
usage() {
        echo
        echo "Usage: $BASENAME <local-dir-name>"
        echo
        exit 1
}
error_usage()  { echo "$BASENAME: Error - $1"; usage       ; }
error()        { echo "$BASENAME: Error - $1"; exit 1      ; }
echo_msg_log() { echo "$BASENAME: Error - $1"; logger "$1" ; }

PORT=""
REMOTE=""
#LOCAL="/Users/jdg/SSHFS/$DIR/"
LOCAL="./$DIR/"

if [ -z "$DIR" ]; then 
	usage

elif [ "$DIR" = "ingosur" ]; then 
	PORT="2221"
	REMOTE="jdg@vps3.dgt-bv.com:SSHFS/INGOSUR/"

elif [ "$DIR" = "samba" ]; then 
	PORT="22"
	REMOTE="jdg@10.77.64.50:/mnt/sda4/"

elif [ "$DIR" = "vps1" ]; then 
	PORT="2221"
	REMOTE="jdg@vps1.de-graaff.net:"

elif [ "$DIR" = "rmv8" ]; then 
	PORT="22"
	REMOTE="jdg@10.77.5.112:/opt/rmv8/"
	#LOCAL="/Users/jdg/dev/rmv8/"

elif [ "$DIR" = "netadmin2" ]; then
        PORT="22"
        REMOTE="jdgncnl@10.200.133.35:dev/"
fi

if [ "$REMOTE" != "" ]; then 
	if [[ ! -d $LOCAL ]]; then
		mkdir -pv $LOCAL
	fi
	CMD="sshfs -p $PORT $REMOTE $LOCAL"
	echo "# running CMD > $CMD"
	eval "$CMD"
fi

