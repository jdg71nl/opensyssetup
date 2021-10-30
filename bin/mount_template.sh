#!/bin/bash
#
DIR="usbgw1"
USER="jdg"
HOST="10.21.82.155"
PORT="22"
#
OPTS="-o follow_symlinks -o reconnect -o ServerAliveInterval=30 -o ServerAliveCountMax=3"
#
mkdir -pv $DIR
sshfs -p $PORT $OPTS $USER@$HOST:. $DIR
#
