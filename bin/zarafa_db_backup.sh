#!/bin/bash

TIME=`date +d%y%m%d-%Hh%Mm%Ss`
DIR="/data/zarafa/database"
FILE="$DIR/zarafa-TWS-NCBV-DBbackup.sql.gz"
DB="zarafa"

HEAD1="-- mysql creation script (cmd: $0, date: $TIME)"
HEAD2="USE $DB;"

# mysqlcc
# -t, --no-create-info
# -d, --no-data
# -c, --complete-insert
# -p, --password[=name]

#(echo $HEAD1; echo $HEAD2 ; mysqldump -u zarafa --password="zar4560zer2bud" --single-transaction -c $DB ) | /bin/gzip > $FILE
(echo $HEAD1; echo $HEAD2 ; mysqldump -u zarafa --password="zar4560zer2bud" -c $DB ) | /bin/gzip > $FILE

