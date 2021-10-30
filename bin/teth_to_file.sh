#!/bin/bash

ARG="$1 $2 $3 $4 $5 $6 $7 $8 $9"
DATE=`date +d%y%m%d-%Hh%Mm%Ss`
echo "tethereal $ARG -w $DATE_'$ARG'.cap"
tethereal $ARG -w $DATE_'$ARG'.cap
