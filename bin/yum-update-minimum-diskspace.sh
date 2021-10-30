#! /bin/bash

yum -q check-update > /root/check-update
for i in `awk '{print $1}' < /root/check-update`
do
yum -y update $i

#yum clean all
yum clean packages

done
rm /root/check-update

