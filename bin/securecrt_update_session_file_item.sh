#!/bin/bash
# securecrt_update_session_file_item.sh
# (c)2016 John de Graaff @ De Graaff Innovations VOF <john@dgi-vof.com>

FILE="$1"
FIND="$2"
NEW="$3"

#if grep -Fq $FIND "$FILE"
#then
#	echo perl -pi -e "s/^.*?$FIND.+$/$NEW/" "$FILE"
#else
#	echo ex -sc "a|$NEW" -cx "$FILE"
#fi

echo ex -sc "a|$NEW" -cx "$FILE"
echo ex -sc "a|$NEW" -cx "$FILE"

