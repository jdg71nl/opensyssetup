#!/bin/bash
# Usage:
# if you want to make direct changes ==> curl https://j71.nl/oss-ssh.sh   | bash 
# if you want to make it read-only*  ==> curl https://j71.nl/oss-https.sh | bash 
#                                 or ==> curl https://j71.nl/oss          | bash 
# (*) you can still make changes in a temporary branch, push using https, and use a access-token (purpose-pwd), or commit to new branch and create a pull-request
#
 #-- # - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
 #-- f_echo_exit1() { echo $1 ; exit 1 ; }
 #-- if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
 #-- if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
 #-- if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
 #-- # - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
 #-- f_check_install_packages() { 
 #--   for PKG in $@ ; do 
 #--     if ! dpkg-query -l $PKG >/dev/null ; then 
 #--       echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
 #--       sudo apt install -y $PKG 
 #--     fi
 #--   done
 #-- }
 #-- f_check_install_packages curl git sudo
 #-- # - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
cd $HOME
git clone --depth=1 https://github.com/jdg71nl/opensyssetup.git
./opensyssetup/run_setup_oss.sh
#-EOF

