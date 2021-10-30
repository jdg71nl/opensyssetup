#!/bin/bash

FILE="$1"

if [[ -z "$FILE" ]]; then
	echo "Usage: $0 <DB>"
	echo "       will restore the MySQL database from mysqldump.TGZ"
	exit 1;
fi

if [[ ! -f "$FILE" ]]; then
	echo "cannot read file '$FILE' !"
	exit 1;
fi

echo "extracting file '$FILE' to MySQL ..."
echo "please provide the MySQL root pwd:"
zcat $FILE | mysql -u root -p

echo "done!"

