#!/bin/bash

iptables -P INPUT   ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT  ACCEPT

iptables -F INPUT 
iptables -F FORWARD 
iptables -F OUTPUT 
iptables -F -t nat

iptables -t nat -A POSTROUTING -s 2.1.1.0/24 -o eth0 -j SNAT --to-source 172.20.150.1

