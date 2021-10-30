#!/bin/bash

IFACES=`ifconfig | grep ^eth | perl -pe 's/^(eth[0-9]\:?[0-9]?).*$/$1/'`
for i in $IFACES; do
	#perl -ne "printf(\\"%-8s\\",$i);"
	echo -ne "$i\t"
	ifconfig "$i" | grep 'inet addr' | perl -ne '$_=~/inet addr:\s*([\d\.]+).*?Mask:\s*([\d\.]+)/;$ip=$1;$nm=$2;printf("IP=%-15s NM=%-15s\n",$ip,$nm);'
done

