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
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
usage() {
  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
  echo "# usage:   $BASENAME { db_name } { pg_pwd } { db_user } { db_pwd } " 1>&2 
  echo "# example: $BASENAME   db_jser    my_pg_pwd  jser_user   my_db_pwd " 1>&2 
  exit 1
}
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

DB_NAME="$1"
PG_PWD="$2"
DB_USER="$3"
DB_PWD="$4"
if [ -z "$DB_PWD" ]; then usage ; fi

echo "# "
echo "# DB_NAME=$DB_NAME "
echo "# PG_PWD=$PG_PWD"
echo "# DB_USER=$DB_USER "
echo "# DB_PWD=$DB_PWD "
echo "# "
echo "# Are you sure you want to create these PostgreSQL settings ? (Y) (ctrl-c to abort) "

read

#if which psql >/dev/null ; then f_echo_exit1 "# 'postgres' is already installed " ; fi

f_check_install_packages postgresql adminer

PGVER=$( find /etc/postgresql -type f -name postgresql.conf | perl -pe 's/^.*?(\d+).*$/$1/' )
# > echo "-$PGVER-"
# -12-

# instead of typing pwd at command: > passwd postgres 
# we do:
#
HASH=$(echo "$PG_PWD" | openssl passwd -5 -salt $(openssl rand -base64 29 | tr -d "=+/" | cut -c1-25) -stdin)
echo "postgres:${HASH}" | chpasswd -e

#sudo -s -u postgres -D /var/lib/postgresql -- psql -c "ALTER USER postgres WITH PASSWORD '$PG_PWD';"
#sudo -s -u postgres -D /var/lib/postgresql -- psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PWD';"
#sudo -s -u postgres -D /var/lib/postgresql -- psql -c "CREATE DATABASE $DB_NAME;"
#sudo -s -u postgres -D /var/lib/postgresql -- psql -c "GRANT ALL ON DATABASE $DB_NAME TO $DB_USER;"
#sudo -s -u postgres -D /var/lib/postgresql -- psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"

sudo -u postgres -H -- psql -c "ALTER USER postgres WITH PASSWORD '$PG_PWD';"
sudo -u postgres -H -- psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PWD';"
sudo -u postgres -H -- psql -c "CREATE DATABASE $DB_NAME;"
sudo -u postgres -H -- psql -c "GRANT ALL ON DATABASE $DB_NAME TO $DB_USER;"
sudo -u postgres -H -- psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"

#su - postgres psql -c "ALTER USER postgres WITH PASSWORD '$PG_PWD';"
#su - postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PWD';"
#su - postgres psql -c "CREATE DATABASE $DB_NAME;"
#su - postgres psql -c "GRANT ALL ON DATABASE $DB_NAME TO $DB_USER;"
#su - postgres psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"


cat >> /etc/postgresql/$PGVER/main/postgresql.conf <<HERE

# jdg
listen_addresses = '*'

HERE

#host    all             all             127.0.0.1/32            scram-sha-256
#host    all             all             ::1/128                 scram-sha-256

perl -i -pe 's/^(host\s+all\s+all\s+127.0.0.1.*)$/#$1/' /etc/postgresql/$PGVER/main/pg_hba.conf
perl -i -pe 's/^(host\s+all\s+all\s+::1\/128.*)$/#$1/' /etc/postgresql/$PGVER/main/pg_hba.conf

cat >> /etc/postgresql/$PGVER/main/pg_hba.conf <<HERE

# jdg
host    all             all             0.0.0.1/0             md5
host    all             all             ::0/0                 md5

HERE

service postgresql restart

a2enconf adminer

systemctl reload apache2

echo "# done. "
 
LOCALHOST="127.0.0.1"

. ~/opensyssetup/bin/set_env_ip_addresses.sh
#
echo "# check ops ==> http://$LOCALHOST/adminer/?pgsql=$LOCALHOST&username=$DB_USER&db=$DB_NAME&ns=public "
if [ -n "$JINFO_IP_eth0" ]; then echo "# check ops ==> http://$JINFO_IP_eth0/adminer/?pgsql=$JINFO_IP_eth0&username=$DB_USER&db=$DB_NAME&ns=public " ; fi
if [ -n "$JINFO_IP_eth1" ]; then echo "# check ops ==> http://$JINFO_IP_eth1/adminer/?pgsql=$JINFO_IP_eth1&username=$DB_USER&db=$DB_NAME&ns=public " ; fi
if [ -n "$JINFO_IP_wlan0" ]; then echo "# check ops ==> http://$JINFO_IP_wlan0/adminer/?pgsql=$JINFO_IP_wlan0&username=$DB_USER&db=$DB_NAME&ns=public " ; fi
if [ -n "$JINFO_IP_wlan1" ]; then echo "# check ops ==> http://$JINFO_IP_wlan1/adminer/?pgsql=$JINFO_IP_wlan1&username=$DB_USER&db=$DB_NAME&ns=public " ; fi
if [ -n "$JINFO_IP_tun21" ]; then echo "# check ops ==> http://$JINFO_IP_tun21/adminer/?pgsql=$JINFO_IP_tun21&username=$DB_USER&db=$DB_NAME&ns=public " ; fi


cat >/dev/null <<HERE
#cat <<HERE

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
# connection_string: "postgresql://$DB_USER:mypwd@127.0.0.1:5432/$DB_NAME"
> 
psql -c "CREATE USER $DB_USER WITH PASSWORD 'mypwd';"
# psql -c "ALTER USER $DB_USER WITH PASSWORD 'mypwd2';"
psql -c "CREATE DATABASE $DB_NAME;"
psql -c "GRANT ALL ON DATABASE $DB_NAME TO $DB_USER;"
psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"

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
# check operation on: http://172.16.222.132/adminer/?pgsql=172.16.222.132&username=$DB_USER&db=$DB_NAME&ns=public 

HERE

#
exit 0
#
#-eof

