#!/bin/sh

DBFILE=$1
TBL=$2
SORT=$3


if [[ -z "$SORT" ]]; then
	echo "Usage: $0 <dbfile> <table> <column>";
	echo
	exit
fi

if [[ ! -f "$DBFILE" ]]; then
	echo "$0: file '$DBFILE' does not exit!"
	echo
	exit
fi

NOW=$( date )
SQL="SELECT * FROM $TBL ORDER BY $SORT;"
echo "$NOW $0: Running '$SQL' on SQLite database '$DBFILE'"
echo -e ".mode column\n.header on\nSELECT * FROM $TBL ORDER BY $SORT;" | sqlite3 "$DBFILE"

echo

