#!/bin/bash
# dig +short +trace -tNS dales.com
DOM=$1
echo "# will run dig to find authorative NS via root/TLD delegation trace"
CMD="dig +short +trace -tNS $DOM"
echo $CMD
$CMD

