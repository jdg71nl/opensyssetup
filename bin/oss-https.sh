#!/bin/bash
# Usage:
# if you want to make direct changes ==> curl https://j71.nl/oss-ssh.sh   | bash 
# if you want to make it read-only*  ==> curl https://j71.nl/oss-https.sh | bash 
#                                 or ==> curl https://j71.nl/oss          | bash 
# (*) you can still make changes in a temporary branch, push using https, and use a access-token (purpose-pwd), or commit to new branch and create a pull-request
#
#
if [ -e /etc/debian_version ]; then
  echo "# Error: found non-Debain OS .."
  exit 1
fi
#
if which dpkg-query >/dev/null ; then
  echo "# Ah, package 'dpkg-query' is installed, so we are on a Debian system, yes?" ;
else
  echo "# please install first: using ==> sudo apt install dpkg-query ";
  exit 1
fi
#
if which sudo >/dev/null ; then
  echo "# Ah, package 'sudo' is installed, proceeding .."
else
  echo "# please install first (as root) ==> apt install sudo ";
  exit 1
fi
#
cd $HOME
#
# https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
# According to this page, $@ and $* do pretty much the same thing:
# - The $@ holds list of all arguments passed to the script. 
# - The $* holds list of all arguments passed to the script.
# They aren't the same. $* is a single string, whereas $@ is an actual array.
#
f_check_install_packages() {
  #PKG="$1"
  for PKG in $@ do
    # if dpkg-query -l rsync >/dev/null ; then echo true ; else echo false ; fi
    if dpkg-query -l $PKG >/dev/null ; then
      echo "# [check] package '$PKG' is installed."
    else 
      echo "# [check] package '$PKG' is NOT installed, ==> will install now ... "
      echo "# > sudo apt install -y $PKG "
      #
      sudo apt install -y $PKG
      #
  fi
done
}
PKG_LIST="curl git sudo"
f_check_install_packages curl git sudo
#
git clone --depth=1 https://github.com/jdg71nl/opensyssetup.git
./opensyssetup/setup.sh
#-EOF

