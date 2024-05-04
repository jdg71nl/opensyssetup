#!/bin/bash
#= SecureCRT-setup-mac-priv-git.sh

echo_exit1() { echo $1 ; exit 1 ; }

REPO="ssh://git@vps3.j71.nl:2221/opt/git/securecrt.git"

BASE="/Users/jdg/Library/Application Support/VanDyke/SecureCRT"

CONFIG1="Config"
CONFIG2="_ori_Config"

echo "# > cd \"$BASE\" "
cd "$BASE"

[[ ! -d $CONFIG1 ]] && echo_exit1 "# SecureCRT not installed, missing Config/ dir ..."

if [ -d $CONFIG2 ]; then
  echo "# this system is already setup: '$CONFIG2' exists -- quitting ... "
  exit 1
fi

echo "# > mv $CONFIG1 $CONFIG2 "
mv $CONFIG1 $CONFIG2

echo "# > git clone $REPO "
git clone $REPO

# exit if the last command failed
if [ $? -ne 0 ]; then exit 1; fi

echo "# > mv securecrt $CONFIG1 "
mv securecrt $CONFIG1

# copy other files:
cd $CONFIG2
# not
#  Recent File List SecureCRT.ini \
#  Recent Script List.ini \
#
for x in \
  Commands \
  Global.ini \
  SSH2.ini \
  SecureCRT.lic ; 
do 
  echo "# > cp -v \"$x\" ../Config/ "
  cp -av "$x" ../Config/
done

echo "# > cd $HOME "
cd $HOME
echo "# > ln -s \"Library//Application Support/VanDyke/SecureCRT/Config/Sessions\" SecureCRT "
ln -s "Library//Application Support/VanDyke/SecureCRT/Config/Sessions" SecureCRT

echo "# Done !"

#-eof


