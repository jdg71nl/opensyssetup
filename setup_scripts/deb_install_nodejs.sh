#!/bin/bash
#= debian_install_nodejs.sh
# (c)2023 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
f_check_install_packages() { 
  for PKG in $@ ; do 
    if ! dpkg-query -l $PKG >/dev/null ; then 
      echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
      sudo apt install -y $PKG 
    fi
  done
}
# f_check_install_packages curl git sudo
#
#
f_check_install_packages ca-certificates curl gnupg




# d240109-1600 JDG --- CHECK THIS ==> Debian Bookworm ALSO seems to have nodejs v18 ..
# https://packages.debian.org/bookworm/nodejs




# d23 ==> NEW: https://github.com/nodesource/distributions 

# start actual install:
#
#mkdir -p /etc/apt/keyrings

#NODE_MAJOR=16
#NODE_MAJOR=18
#NODE_MAJOR=20
NODE_MAJOR=22

apt-get install -y curl

#curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - 
#curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
#curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR.x | sudo -E bash -
#
#echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

cd ~
mkdir -pv ~/tmp/
cd ~/tmp/
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
bash nodesource_setup.sh
cd ~

apt update

apt install -y nodejs 

# Note: if npm gives problems you may need to just reinstall:
# 1.
# > sudo apt install --reinstall nodejs
# 2. 
# > sudo apt purge nodejs
# > sudo rm -rf /usr/lib/node_modules
# > sudo apt install nodejs
# > sudo npm install -g npm
# > sudo npm i nodemon -g
# > sudo npm i pm2 -g

#
npm i -g npm
npm i nodemon -g
npm i pm2 -g
sudo -u jdg pm2
sudo -u jdg pm2 startup
env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u jdg --hp /home/jdg
#
exit 0
#
#-eof

# --[CWD=~/opensyssetup/setup_scripts(git:main)]--[1702820591 14:43:11 Sun 17-Dec-2023 CET]--[jdg@deb12vm-mb18]--[os:Debian-12/bookworm,kernel:6.1.0-16-amd64,isa:x86_64]------
# > pm2 startup
# [PM2] Init System found: systemd
# [PM2] To setup the Startup Script, copy/paste the following command:
# sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u jdg --hp /home/jdg
# #( bash[PROMPT_COMMAND]: prev.cmd returned non-zero code: 1 )
# --[CWD=~/opensyssetup/setup_scripts(git:main)]--[1702820593 14:43:13 Sun 17-Dec-2023 CET]--[jdg@deb12vm-mb18]--[os:Debian-12/bookworm,kernel:6.1.0-16-amd64,isa:x86_64]------
# > sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u jdg --hp /home/jdg

#                         -------------

# __/\\\\\\\\\\\\\____/\\\\____________/\\\\____/\\\\\\\\\_____
#  _\/\\\/////////\\\_\/\\\\\\________/\\\\\\__/\\\///////\\\___
#   _\/\\\_______\/\\\_\/\\\//\\\____/\\\//\\\_\///______\//\\\__
#    _\/\\\\\\\\\\\\\/__\/\\\\///\\\/\\\/_\/\\\___________/\\\/___
#     _\/\\\/////////____\/\\\__\///\\\/___\/\\\________/\\\//_____
#      _\/\\\_____________\/\\\____\///_____\/\\\_____/\\\//________
#       _\/\\\_____________\/\\\_____________\/\\\___/\\\/___________
#        _\/\\\_____________\/\\\_____________\/\\\__/\\\\\\\\\\\\\\\_
#         _\///______________\///______________\///__\///////////////__


#                           Runtime Edition

#         PM2 is a Production Process Manager for Node.js applications
#                      with a built-in Load Balancer.

#                 Start and Daemonize any application:
#                 $ pm2 start app.js

#                 Load Balance 4 instances of api.js:
#                 $ pm2 start api.js -i 4

#                 Monitor in production:
#                 $ pm2 monitor

#                 Make pm2 auto-boot at server restart:
#                 $ pm2 startup

#                 To go further checkout:
#                 http://pm2.io/


#                         -------------

# [PM2] Init System found: systemd
# Platform systemd
# Template
# [Unit]
# Description=PM2 process manager
# Documentation=https://pm2.keymetrics.io/
# After=network.target

# [Service]
# Type=forking
# User=jdg
# LimitNOFILE=infinity
# LimitNPROC=infinity
# LimitCORE=infinity
# Environment=PATH=/home/jdg/opensyssetup/bin:/home/jdg/opensyssetup/mac/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
# Environment=PM2_HOME=/home/jdg/.pm2
# PIDFile=/home/jdg/.pm2/pm2.pid
# Restart=on-failure

# ExecStart=/usr/lib/node_modules/pm2/bin/pm2 resurrect
# ExecReload=/usr/lib/node_modules/pm2/bin/pm2 reload all
# ExecStop=/usr/lib/node_modules/pm2/bin/pm2 kill

# [Install]
# WantedBy=multi-user.target

# Target path
# /etc/systemd/system/pm2-jdg.service
# Command list
# [ 'systemctl enable pm2-jdg' ]
# [PM2] Writing init configuration in /etc/systemd/system/pm2-jdg.service
# [PM2] Making script booting at startup...
# [PM2] [-] Executing: systemctl enable pm2-jdg...
# Created symlink /etc/systemd/system/multi-user.target.wants/pm2-jdg.service → /etc/systemd/system/pm2-jdg.service.
# [PM2] [v] Command successfully executed.
# +---------------------------------------+
# [PM2] Freeze a process list on reboot via:
# $ pm2 save

# [PM2] Remove init script via:
# $ pm2 unstartup systemd
# --[CWD=~/opensyssetup/setup_scripts(git:main)]--[1702820602 14:43:22 Sun 17-Dec-2023 CET]--[jdg@deb12vm-mb18]--[os:Debian-12/bookworm,kernel:6.1.0-16-amd64,isa:x86_64]------
# > 
