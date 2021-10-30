#!/bin/bash

#DIR="~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions"
DIR="~/Library/Application\ Support/VanDyke/SecureCRT/Config"
#DIR="~/Library/Application Support/VanDyke/SecureCRT/Config"
echo "# DIR = $DIR "
#ls -altr "$DIR"

# find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions/ -type f -iname '__*' -prune -o -iname '*.ini' -print -exec /usr/local/syssetup/bin/securecrt_update_session_file.sh "{}" \;
# find "$DIR" -type f -iname '__*' -prune -o -iname '*.ini' -print 
find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions -type f -iname '__*' -prune -o -iname '*.ini' -print 


