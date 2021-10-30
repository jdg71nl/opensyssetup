#!/bin/sh

# ------+++------
# settings:

DATE=`date +d%y%m%d-%Hh%Mm%Ss`
USER="root"
PASS="pwd"
DB="postfix"
DIR="/mail/backup"
FILE="mysql_autodump_bredero.sql"

# ------+++------
# script:

cd $DIR
cat >$FILE <<EOT
-- mysql creation script (cmd: $0, date: $DATE, dir: $DIR, file: $FILE)

USE $DB;

EOT

# mysqlcc
# -t, --no-create-info
# -d, --no-data
# -c, --complete-insert
# -p, --password[=name]
# -e, --extended-insert
# --opt
# --skip-opt

mysqldump $DB -u $USER --password=$PASS -c --skip-opt >> $FILE
gzip -f $FILE

# ------+++------
