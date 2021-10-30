#!/bin/bash

R=$1;
P=$(( $R - 1 ));
#echo $P;

svn diff -r $P:$R | egrep -v '^[+|-]{3} ' | egrep '^[+|-]' | wc -l

