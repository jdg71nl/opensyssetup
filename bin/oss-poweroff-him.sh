#!/bin/bash
#= oss-poweroff-him.sh
#
HOST="$1"
#
sudo ssh jdg@$HOST './opensyssetup/bin/oss-poweroff-me.sh'
#
#-eof
