#!/bin/bash
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 12 ; }
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
if which psql >/dev/null ; then f_echo_exit1 "# 'postgres' is already installed " ; fi

exit 123

#cat >/dev/null <<HERE
cat <<HERE

>
sudo apt -y install postgresql adminer

>
sudo passwd postgres
New password: 
Retype new password: 
passwd: password updated successfully

# do as user 'postgres':
> 
su - postgres

> 
psql -c "ALTER USER postgres WITH PASSWORD 'your-password';"
ALTER ROLE

# optional: create new user and database
# connection_string: "postgresql://jser_user:mypwd@127.0.0.1:5432/db_jser"
> 
psql -c "CREATE USER jser_user WITH PASSWORD 'mypwd';"
# psql -c "ALTER USER jser_user WITH PASSWORD 'mypwd2';"
psql -c "CREATE DATABASE db_jser;"
psql -c "GRANT ALL ON DATABASE db_jser TO jser_user;"
psql -c "ALTER DATABASE db_jser OWNER TO jser_user;"

# ^d (exit shell as user postgres)

# add_to_bottom:
> 
# sudo vi /etc/postgresql/13/main/postgresql.conf
sudo vi /etc/postgresql/15/main/postgresql.conf

# jdg
listen_addresses = '*'

# add_to_bottom:
> 
# sudo vi /etc/postgresql/13/main/pg_hba.conf
sudo vi /etc/postgresql/15/main/pg_hba.conf

# jdg
host    all             all             0.0.0.1/0             md5
host    all             all             ::0/0                 md5

> 
sudo service postgresql restart

> 
sudo a2enconf adminer

> 
sudo systemctl reload apache2

# done!
# check operation on: http://172.16.222.132/adminer/?pgsql=172.16.222.132&username=jser_user&db=db_jser&ns=public 

HERE

#
exit 0
#
#-eof
