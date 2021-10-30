#!/bin/bash

cat /etc/issue.base > /etc/issue
echo "# Interfaces:" >> /etc/issue
/usr/local/syssetup/bin/print_ifconfig.sh >> /etc/issue
echo "" >> /etc/issue

