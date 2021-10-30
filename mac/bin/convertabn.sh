#!/bin/bash

FI="/tmp/convertabn.in.txt";
FO="/tmp/convertabn.out.txt";

touch $FI
touch $FO

cat $FI | perl -ne '$l=$_;$_=~/^(\d+)\t(\w+)\t(\d+)\t([\d,\-]+)\t([\d,\-]+)\t(\d+)\t([\d,\-]+)\t(.*)$/;$d=$3;$o=$8;$d=~/(\d{4})(\d{2})(\d{2})/;$dn="$3-$2-$1";$o=~/^\s?(\S+)\s/;$t=$1;print "$dn\t$t\n";#\t$l";' > $FO

