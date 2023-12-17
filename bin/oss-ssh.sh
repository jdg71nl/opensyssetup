#!/bin/bash
# Usage:
# if you want to make direct changes ==> curl https://j71.nl/oss-ssh.sh   | bash 
# if you want to make it read-only*  ==> curl https://j71.nl/oss-https.sh | bash 
#                                 or ==> curl https://j71.nl/oss          | bash 
# (*) you can still make changes in a temporary branch, push using https, and use a access-token (purpose-pwd), or commit to new branch and create a pull-request
#
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
#
if [ ! -f $HOME/.ssh/id_rsa ] ; then
  echo "# first create a local SSH key: "
  echo "# using either: "
  echo "# > ssh-create-client-id_rsa.sh "
  echo "# "
  echo "# or: "
  echo "# > mkdir -pv \$HOME/.ssh "
  echo "# > chmod 0700 \$HOME/.ssh "
  echo "# > ssh-keygen -t rsa -f \$HOME/.ssh/id_rsa -P ''  "
  echo "# then copy the pub-key to github: "
  echo "# > cat \$HOME/.ssh/id_rsa.pub "
  echo "# "
  echo "# in summary (copy-paste): "
  echo "mkdir -pv \$HOME/.ssh "
  echo "chmod 0700 \$HOME/.ssh "
  echo "ssh-keygen -t rsa -f \$HOME/.ssh/id_rsa -P ''  "
  echo "cat \$HOME/.ssh/id_rsa.pub "
  exit 1
fi
#
cd $HOME
git clone --depth=1 git@github.com:jdg71nl/opensyssetup.git
./opensyssetup/run_setup_oss.sh
#
#-eof

