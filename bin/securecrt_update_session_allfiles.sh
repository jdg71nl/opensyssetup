#!/bin/bash
# securecrt_update_session_allfiles.sh
# (c)2016 John de Graaff @ De Graaff Innovations VOF <john@dgi-vof.com>

# Usage:
# /usr/local/syssetup/bin/securecrt_update_session_allfiles.sh 

find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions/ -type f -iname '__*' -prune -o -iname '*.ini' -print -exec /usr/local/syssetup/bin/securecrt_update_session_file.sh "{}" \;

