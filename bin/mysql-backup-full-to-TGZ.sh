#!/bin/bash

HOST="$1"

if [[ -z "$HOST" ]]; then
	echo "Usage: $0 <HOST>"
	echo "       will create a TGZ with GZIP'd dump of ALL databases MySQL on HOST (hostname)"
	exit 1;
fi

#DATE=`date +d%y%m%d-%Hh%Mm%Ss`
DATE=`date +d%y%m%d-%H%M%S`
FILE="mysqldump_${HOST}_$DATE.sql"

echo "creating file '$FILE' ..."
cat >$FILE <<EOT
-- mysqldump (date in YYMMDD-HHMMSS: $DATE)
EOT

echo "mysqldump ..."
# mysqlcc
# -t, --no-create-info
# -d, --no-data
# -c, --complete-insert
# -p, --password[=name]
echo "please provide the MySQL root pwd:"
mysqldump --all-databases -u root -p -c >> $FILE

echo "gziping file to $FILE.gz"
gzip -f $FILE

echo "done!"

