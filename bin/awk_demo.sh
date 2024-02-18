#!/bin/bash

# https://medium.com/@wujido20/a-friendly-introduction-to-awk-command-8cc6487f5d2a
# 
# BEGIN {FS=”,”};                         change the field separator to a comma.
# NR > 1 && $2 >= 30                      skips the first line (the header of the CSV) and checks if the person is old enough.
# {print “Name: “$1”, Proffesion: “$4}    prints line in the required format.
#
# we can also use awk -F ',' '...' instead of the BEGIN section.

cat <<HERE | awk 'BEGIN {FS=","}; NR > 1 && $2 >= 30 {print "Name: "$1", Proffesion: "$4}' -
Name,Age,City,Occupation
John,30,New York,Software Engineer
Alice,25,San Francisco,Data Analyst
Michael,42,Chicago,Marketing Manager
Julia,36,Los Angeles,Product Manager
HERE

# https://www.markhneedham.com/blog/2013/06/26/unixawk-extracting-substring-using-a-regular-expression-with-capture-groups/

# my choice, use sed:
#
# > ip -o -4 addr show eth0
# 2: eth0    inet 10.77.66.191/24 brd 10.77.66.255 scope global dynamic noprefixroute eth0\       valid_lft 862017sec preferred_lft 862017sec
#
# > ip -o -4 addr show eth0 | awk '{print $4}'
# 10.77.66.191/24
#
ip -o -4 addr show eth0 | awk '{print $4}' | sed 's/\/.*$//'

export JINFO_IP_eth0=$( ip -o -4 addr show eth0 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_eth1=$( ip -o -4 addr show eth1 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_wlan0=$( ip -o -4 addr show wlan0 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_wlan1=$( ip -o -4 addr show wlan1 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_tun21=$( ip -o -4 addr show tun21 | awk '{print $4}' | sed 's/\/.*$//' )

#-eof

