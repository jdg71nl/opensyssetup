#!/bin/bash
#= smartback4.sh

# required debain packages:
# apt install rsync apt-show-versions

if [ `id -u` != 0 ]; then 
	# re-run as root:
	#echo "Provide your password for 'sudo':"
	#sudo "$0" "$*"
	echo "ERROR: can only run this command as root .."
	exit 1
fi

# general settings:
CONF_DIR="/etc/smartback4"
CONF_SH="$CONF_DIR/config.sh"
CLIENT_CONF="$CONF_DIR/client.sh"
FILELIST="$CONF_DIR/sources.txt"
CONF_TEMPL_DIR="~/opensyssetup/bin/smartback4/_smartback4"
CONF_TEMPL_SH="$CONF_TEMPL_DIR/config.sh"

[ -f "$CONF_SH" ] && source "$CONF_SH"

if [ ! -f "$CLIENT_CONF" ] ; then
	echo
	echo "# NOTICE: smartback4 not yet setup on this system (file does not exist: \$CLIENT_CONF=$CLIENT_CONF)"
	echo 

# d230730 JDG: change of home address:
# OLD: /usr/local/syssetup/bin/
# NEW: ~/opensyssetup/bin/

	echo "# setup defaults in '$CONF_DIR' ..."
	echo 
	mkdir -pv $CONF_DIR/
	cp -av $CONF_TEMPL_DIR/* $CONF_DIR/
	echo -e '#!/bin/bash\n#= /etc/smartback4/client.sh\nCLIENT_NAME="'$(hostname -s)'"' > $CLIENT_CONF
	echo

	# RSA_DIR="/root/.ssh"
	# RSA_ID="$RSA_DIR/id_rsa"
	# RSA_PUB="$RSA_DIR/id_rsa.pub"
	# if [ ! -f $HOME/.ssh/id_rsa ] ; then 
	# 	echo "# No '.ssh/id_rsa exists for root user !! -- please run this command once:'"
	# 	echo "~/opensyssetup/bin/smartback4/smartback4-add-ssh.sh  "
	# fi

	# ssh -p 48722 smartback4@185.84.140.52
	# sudo ~/opensyssetup/bin/ssh-copy-id_rsa-pub.sh -p 48722 smartback4@185.84.140.52
	#
	[ -f "$CONF_TEMPL_SH" ] && source "$CONF_TEMPL_SH"
	#
  echo "# run this command to copy the root:SSH-key to the remote rsync-server: "
  echo "> sudo ~/opensyssetup/bin/ssh-copy-id_rsa-pub.sh -p $RSYNC_PORT $RSYNC_USER@$RSYNC_TARGET "

	exit
fi

# source client settings (this system)
. $CLIENT_CONF

# print msg to screen@stderr and to syslog:
echo_msg_log() { 
	MSG="script $0 (PID:$$): $1"
	echo $MSG > /dev/stderr
	logger "$MSG"
}

# ------+++------
# create status backups

# create file listing:
. $LISTER_SH

# do: lvmdump

# expand:
. $EXPAND_SH

DEBPKGS="debpkgs"
V_L_DEBPKGS="/var/log/$DEBPKGS"
REFFILE="/tmp/$DEBPKGS"
if [ -f "/etc/debian_version" ] ; then
	# INSTALL: aptitude install apt-show-versions 
	touch -d "-1 day" $REFFILE
	if [ $V_L_DEBPKGS -ot $REFFILE  ]; then
		echo -n "$0: updating 'apt-show-versions' ... " >/dev/stderr
		apt-show-versions > $V_L_DEBPKGS
		echo "done!" >/dev/stderr
	fi
fi

# SYNC_BACK="$CONF_DIR/sync_back.sh"
echo "#!/bin/bash " > $SYNC_BACK
echo "# > cat $SYNC_BACK " >> $SYNC_BACK
echo "#!/bin/bash " >> $SYNC_BACK
echo "mkdir -pv /var/local/backup/smartback4/$CLIENT_NAME/ " >> $SYNC_BACK
echo "rsync -v -rtlz -e \"$RSYNC_SSH\" $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ /var/local/backup/smartback4/$CLIENT_NAME/ " >> $SYNC_BACK
echo >> $SYNC_BACK
chmod +x $SYNC_BACK

# ------+++------
# create touchfile:
cd $CONF_DIR/
. $CREATETOUCH_SH
# move file to root for rsync to server:
mv touchfile "/$TOUCH_FILE"

# ------+++------
# setup rsync-command and log:

echo "$0: rsyncing ... " >/dev/stderr

# no need to create dir first:
# ssh -p2221 smartback2@vps3.de-graaff.net "mkdir -pv /var/backups/smartback2/tws-rmv-csw/"

#CMD="rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE / rsync://$TARGET/smartback2/$CLIENT_NAME/"
# use SSH in all cases (copy root SSH pub.key fro this system to vps3:auth-file):
#CMD="rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e 'ssh -p 2221' / smartback2@vps3.de-graaff.net:/var/backups/smartback2/$CLIENT_NAME/"
#echo_msg_log "$CMD"
# run rsync command:
# $CMD

#echo rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e "$RSYNC_SSH"  /  $RSYNC_TARGET/$CLIENT_NAME/
echo rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e "$RSYNC_SSH"  /  $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/
     rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e "$RSYNC_SSH"  /  $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/

echo "$0: done!" >/dev/stderr

# move file back (after rsync to server):
mv "/$TOUCH_FILE" $CONF_DIR/

#echo "$0: sync back using:> rsync -v -rtlz -e 'ssh -p 2221' smartback4@vps5.dgt-bv.com:/var/local/backup/smartback4/samba-deb10.buster-hw.sm.e50/ /var/local/backup/smartback4/samba-deb10.buster-hw.sm.e50/ " >/dev/stderr
#echo "$0: sync back using:> rsync -v -rtlz -e \"$RSYNC_SSH\" $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ /var/local/backup/smartback4/$CLIENT_NAME/ " >/dev/stderr
echo "$0: sync back using: > cat $SYNC_BACK " >/dev/stderr
cat $SYNC_BACK >/dev/stderr

# ------+++------
