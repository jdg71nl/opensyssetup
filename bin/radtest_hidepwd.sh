#!/bin/bash

hide=`echo $2 | /usr/bin/tr '[:print:]' \*`

/usr/bin/radtest $1 $2 $3:$4 $5 $6 | /bin/sed "s/$2/$hide/"

