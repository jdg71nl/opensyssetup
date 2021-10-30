#!/bin/bash

DB="$1"

if [[ -z "$DB" ]]; then
	echo "Usage: $0 <DB>"
	echo "       will create a TGZ with GZIP'd dump of Mysql DB"
	exit 1;
fi

#DATE=`date +d%y%m%d-%Hh%Mm%Ss`
DATE=`date +d%y%m%d-%H%M%S`
FILE="mysqldump_${DB}_$DATE.sql"

echo "creating file '$FILE' ..."
cat >$FILE <<EOT
-- mysqldump (date in YYMMDD-HHMMSS: $DATE)
USE $DB;
EOT

echo "mysqldump ..."
# mysqlcc
# -t, --no-create-info
# -d, --no-data
# -c, --complete-insert
# -p, --password[=name]
echo "please provide the MySQL root pwd:"
mysqldump $DB -u root -p -c >> $FILE

echo "gziping file to $FILE.gz"
gzip -f $FILE

echo "done!"

