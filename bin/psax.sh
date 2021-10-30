#!/bin/bash
 
# Displays which PROCESSOR a pid is currently running on :)
  
/usr/bin/uptime
COLUMNS=80 ps ax -o pid,user,ni,%cpu,psr,%mem,args --sort -%cpu|head -n 22
/usr/bin/free

