#!/bin/bash
#= /etc/smartback4/config.sh
#
# RSYNC_SSH="ssh -p 22"
# RSYNC_TARGET="ipbackup.twsmgt.net"
# RSYNC_SSH="ssh -p 33022"
# RSYNC_TARGET="ipbackup.twsnet.net"
# RSYNC_SSH="ssh -p 2221"
# RSYNC_TARGET="vps5.dgt-bv.com"
# > ssh -p 48722 smartback4@185.84.140.52
RSYNC_PORT="48722"
RSYNC_SSH="ssh -p $RSYNC_PORT"
RSYNC_TARGET="185.84.140.52"
#
RSYNC_USER="smartback4"
#
# Note: $RSYNC_DIR is the server-side dir, which should be a symlink:
# > sudo mkdir -pv /var/backups/smartback4
# > sudo chown smartback4.smartback4 /var/backups/smartback4/
# > sudo -u smartback4 ln -s /var/backups/smartback4/ /home/smartback4/
# now '/home/smartback4/smartback4/' exists...
RSYNC_DIR="smartback4"
#
CONF_DIR="/etc/smartback4"
CLIENT_CONF="$CONF_DIR/client.sh"
SYNC_BACK="$CONF_DIR/sync_back.sh"
FILELIST="$CONF_DIR/sources.txt"
INCL_FILE="$CONF_DIR/rsync.includes.txt"
#
BIN_DIR="/root/opensyssetup/bin/smartback4"
CREATETOUCH_SH="$BIN_DIR/_smartback4-touchfile.sh"
EXPAND_PL="$BIN_DIR/_smartback4-expand.pl"
EXPAND_SH="$BIN_DIR/_smartback4-expand.sh"
LISTER_SH="$BIN_DIR/_smartback4-filelist.sh"
#
TOUCH_FILE="smartback4.lastsync.touchfile"
LOGGER_BIN="/usr/bin/logger"
#

