#!/bin/bash
#= smartback4.sh

# required debain packages:
# apt install rsync apt-show-versions

if [ `id -u` != 0 ]; then 
	# re-run as root:
	echo "# provide your password for 'sudo':"
	sudo "$0" "$*"
	#echo "ERROR: can only run this command as root .."
	exit 1
fi

#usage() {
#  echo "Usage: $0 [ -n NAME ] [ -t TIMES ]" 1>&2 
#}
#exit_abnormal() {
#  usage
#  exit 1
#}

f_check_install_package() {
  PKG="$1"
  # if dpkg-query -l rsync ; then echo true ; else echo false ; fi
  if dpkg-query -l $PKG ; then
    echo "# [check] package '$PKG' is installed."
  else 
    echo "# [check] package '$PKG' is NOT installed, ==> will install now ... "
    echo "# > apt install -y $PKG "
    apt install -y $PKG
  fi
}

echo "# - - - "
echo "# test installed required packages:"
f_check_install_package rsync
f_check_install_package apt-show-versions
f_check_install_package lshw
f_check_install_package raspinfo

# general settings:
CONF_DIR="/etc/smartback4"
CONF_SH="$CONF_DIR/config.sh"
CLIENT_CONF="$CONF_DIR/client.sh"
FILELIST="$CONF_DIR/sources.txt"
CONF_TEMPL_DIR="/root/opensyssetup/bin/smartback4/_smartback4"
CONF_TEMPL_SH="$CONF_TEMPL_DIR/config.sh"

[ -f "$CONF_SH" ] && source "$CONF_SH"

if [ ! -f "$CLIENT_CONF" ] ; then
  echo "# - - - "
	echo "# NOTICE: smartback4 not yet setup on this system (file does not exist: \$CLIENT_CONF=$CLIENT_CONF)"
	echo 

# d230730 JDG: change of home address:
# OLD: /usr/local/syssetup/bin/
# NEW: /root/opensyssetup/bin/
  
  echo "# - - - "
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
	# 	echo "/root/opensyssetup/bin/smartback4/smartback4-add-ssh.sh  "
	# fi

	# ssh -p 48722 smartback4@185.84.140.52
	# sudo /root/opensyssetup/bin/ssh-copy-id_rsa-pub.sh -p 48722 smartback4@185.84.140.52
	#
	[ -f "$CONF_TEMPL_SH" ] && source "$CONF_TEMPL_SH"
	#
  echo "# - - - "
  echo "# run this command to copy the root:SSH-key to the remote rsync-server: "
	echo "> sudo /root/opensyssetup/bin/ssh-create-client-id_rsa.sh "
  echo "> sudo /root/opensyssetup/bin/ssh-copy-id_rsa-pub.sh -p $RSYNC_PORT $RSYNC_USER@$RSYNC_TARGET "

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

echo "# - - - "
# create file listing:
. $LISTER_SH

# do: lvmdump

echo "# - - - "
# expand:
. $EXPAND_SH

f_exec_cmd_log() {
  cmd="$1"
  log="$2"
  V_L_log="/var/log/$log"
  REFFILE="/tmp/$log"
	touch -d "-1 day" $REFFILE
	if [ $log -ot $REFFILE  ]; then
    echo "# - - - "
		echo -n "# $0: (running)>  $cmd > $V_L_log  ... "
		$cmd > $V_L_log
		echo "# $0: done!"
	fi
}

if [ -f "/etc/debian_version" ] ; then
  echo "# - - - "
  echo "# updating logs: "

	# INSTALL: aptitude install apt-show-versions 
  #
#   apt_show_versions__log="apt_show_versions__log.txt"
#   V_L_apt_show_versions__log="/var/log/$apt_show_versions__log"
#   REFFILE="/tmp/$apt_show_versions__log"
# 	touch -d "-1 day" $REFFILE
# 	if [ $V_L_apt_show_versions__log -ot $REFFILE  ]; then
# 		echo -n "# $0: updating 'apt-show-versions' ... " >/dev/stderr
# 		apt-show-versions > $V_L_apt_show_versions__log
# 		echo "# $0: done!" >/dev/stderr
# 	fi
#   #
#   dpkg_l__log="dpkg_l__log.txt"
#   V_L_dpkg_l__log="/var/log/$dpkg_l__log"
#   REFFILE="/tmp/$dpkg_l__log"
# 	touch -d "-1 day" $REFFILE
# 	if [ $V_L_dpkg_l__log -ot $REFFILE  ]; then
# 		echo -n "# $0: updating 'dpk -l' ... " >/dev/stderr
# 		dpkg -l > $V_L_dpkg_l__log
# 		echo "# $0: done!" >/dev/stderr
# 	fi
  #
  f_exec_cmd_log "dpkg -l" dpkg_l__log.txt
  f_exec_cmd_log "apt-show-versions" apt_show_versions__log.txt
  f_exec_cmd_log "lshw" lshw__log.txt
  f_exec_cmd_log "dmesg" dmesg__log.txt
  f_exec_cmd_log "raspinfo" raspinfo__log.txt
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

echo "# - - - "
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
echo "rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e \"$RSYNC_SSH\"  /  $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ "
     rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e "$RSYNC_SSH"  /  $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/

echo "$0: done!" >/dev/stderr

# move file back (after rsync to server):
mv "/$TOUCH_FILE" $CONF_DIR/

echo "# - - - "
#echo "$0: sync back using:> rsync -v -rtlz -e 'ssh -p 2221' smartback4@vps5.dgt-bv.com:/var/local/backup/smartback4/samba-deb10.buster-hw.sm.e50/ /var/local/backup/smartback4/samba-deb10.buster-hw.sm.e50/ " >/dev/stderr
#echo "$0: sync back using:> rsync -v -rtlz -e \"$RSYNC_SSH\" $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ /var/local/backup/smartback4/$CLIENT_NAME/ " >/dev/stderr
echo "$0: sync back using: > cat $SYNC_BACK " >/dev/stderr
cat $SYNC_BACK >/dev/stderr

# ------+++------
