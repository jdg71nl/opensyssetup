#!/bin/bash
#= oss-reboot-him.sh
#
HOST="$1"
#
sudo ssh jdg@$HOST './opensyssetup/bin/oss-reboot-me.sh'
#
#-eof
