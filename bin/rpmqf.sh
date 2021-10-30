#!/bin/bash
FILE=`whereis -b $1 | sed 's/^.*: //'`
CMD="rpm -qf $FILE $2 $3 $4 $5"
echo "# whereis found: $FILE"
echo "# running: $CMD"
$CMD

