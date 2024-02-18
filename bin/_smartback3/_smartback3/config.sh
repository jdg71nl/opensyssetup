#!/bin/bash
#= /etc/smartback3/config.sh
#
#RSYNC_SSH="ssh -p 22"
#RSYNC_TARGET="ipbackup.twsmgt.net"
#RSYNC_SSH="ssh -p 33022"
#RSYNC_TARGET="ipbackup.twsnet.net"
RSYNC_SSH="ssh -p 2221"
RSYNC_TARGET="vps5.dgt-bv.com"
#
RSYNC_USER="smartback3"
RSYNC_DIR="smartback3/"
#
CONF_DIR="/etc/smartback3"
CLIENT_CONF="$CONF_DIR/client.sh"
SYNC_BACK="$CONF_DIR/sync_back.sh"
FILELIST="$CONF_DIR/sources.txt"
INCL_FILE="$CONF_DIR/rsync.includes.txt"
#
BIN_DIR="/usr/local/syssetup/bin/smartback3"
CREATETOUCH_SH="$BIN_DIR/_smartback3-touchfile.sh"
EXPAND_PL="$BIN_DIR/_smartback3-expand.pl"
EXPAND_SH="$BIN_DIR/_smartback3-expand.sh"
LISTER_SH="$BIN_DIR/_smartback3-filelist.sh"
#
TOUCH_FILE="smartback3.lastsync.touchfile"
LOGGER_BIN="/usr/bin/logger"
#

