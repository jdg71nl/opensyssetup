#!/bin/bash
PATH=/usr/local/syssetup/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

TIME=$(((RANDOM%29+1)*60)) 
echo sleeping $TIME seconds...
sleep $TIME

