#!/bin/sh
# from: http://www.linuxquestions.org/questions/linux-kernel-70/how-to-track-which-process-is-accessing-disk-505736/

case "$1" in 
	--pids) SEL=2;; 
	--procs) SEL=1;;
	--files|*) SEL=9;; # how come I can't use NF?
esac; 

#for tree in home proc dev usr var; do 
DIRS="home usr var tmp etc"
for tree in $DIRS; do 
	echo -n "/$tree: "; 
	lsof -w -n -a -d0-10 -a +D /$tree | grep '[0-9][urw]' 
#| awk --assign VAR="$SEL" '{print $VAR}'|sort|uniq 
# |xargs; 
done; 
exit 0

