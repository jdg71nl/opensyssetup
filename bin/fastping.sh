#!/bin/sh
CMD="fping -e -p50 -l $1"
echo "CMD: $CMD"
$CMD

