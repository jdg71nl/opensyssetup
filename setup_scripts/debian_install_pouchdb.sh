#!/bin/bash
#= debian_install_pouchdb.sh
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
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo ";; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query "; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
# MYUID=$( id -u )
# if [ $MYUID != 0 ]; then
#   # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
#   # $* is a single string, whereas $@ is an actual array.
#   echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
# fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
#
# check node:
# > which pm2
# /usr/bin/pm2 -> ../lib/node_modules/pm2/bin/pm2
# /usr/lib/node_modules/pm2/bin/pm2
#
# check pouchdb:
# > which pouchdb-server 
# /usr/bin/pouchdb-server -> ../lib/node_modules/pouchdb-server/bin/pouchdb-server
# /usr/lib/node_modules/pouchdb-server/bin/pouchdb-server
#
# check PouchDB/CouchDB port 5984:
# if lsof -Pi :5984 -sTCP:LISTEN -t >/dev/null ; then echo "# true" ; else echo "# false" ; fi
#

# sudo npm install -g pouchdb-server
# # launch example
# # pouchdb-server --port 5984 --host 0.0.0.0 --dir /home/jdg/dev/dcs-rpi-linuxsrv/local_dbs/pouchdb/var/
# NODE_ENV=development pouchdb-server --port 5984 --host 0.0.0.0 --dir /home/jdg/dev/dcs-rpi-linuxsrv/local_dbs/pouchdb/var/

FILE="run_debug.sh"
cat <<EOF > $FILE
#!/bin/bash
NODE_ENV=development pouchdb-server --port 5984 --host 0.0.0.0 --dir /home/jdg/dev/dcs-rpi-linuxsrv/local_dbs/pouchdb/var/
#
EOF
chmod +x $FILE

FILE="pm2_start.sh"
cat <<EOF > $FILE
#!/bin/bash
BASENAME=`basename $0`
SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
cd $SCRIPT_PATH
NODE_ENV=production pouchdb-server --port 5984 --host 0.0.0.0 --dir /home/jdg/dev/dcs-rpi-linuxsrv/local_dbs/pouchdb/var/
#
EOF
chmod +x $FILE

FILE="start.sh"
cat <<EOF > $FILE
#!/bin/bash
BASENAME=`basename $0`
SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
cd $SCRIPT_PATH
pm2 start -n pouchdb pm2_start.sh
#
EOF
chmod +x $FILE

FILE="stop.sh"
cat <<EOF > $FILE
#!/bin/bash
BASENAME=`basename $0`
SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
cd $SCRIPT_PATH
pm2 stop pouchdb
#
EOF
chmod +x $FILE

FILE="restart.sh"
cat <<EOF > $FILE
#!/bin/bash
BASENAME=`basename $0`
SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
cd $SCRIPT_PATH
pm2 restart pouchdb
#
EOF
chmod +x $FILE

FILE="list.sh"
cat <<EOF > $FILE
#!/bin/bash
pm2 list
#
EOF
chmod +x $FILE

#
exit 0
#
#-eof