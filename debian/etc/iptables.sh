#!/bin/bash
#
#Tables: filter, nat, mangle, raw
##Chains: INPUT, FORWARD, OUTPUT, PREROUTING, POSTROUTING, 

# Configure default policies (-P)
iptables -P INPUT   ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT  ACCEPT

# Flush (-F) all specific rules
iptables -F INPUT
iptables -F FORWARD
iptables -F OUTPUT
iptables -F -t nat

# Table: filter
# stateful
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# allow localhost
iptables -t filter -A INPUT -i lo -j ACCEPT
# allow mgt via SSH
iptables -t filter -A INPUT -p tcp -m tcp --dport 2221 -m state --state NEW -j ACCEPT
# allow ping
iptables -t filter -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
# allow replies
iptables -t filter -A INPUT -p udp -m udp --dport 1024:65535 --sport 53 -j ACCEPT
iptables -t filter -A INPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT
iptables -t filter -A INPUT -p icmp -m icmp --icmp-type 3 -j ACCEPT
iptables -t filter -A INPUT -p icmp -m icmp --icmp-type 4 -j ACCEPT
iptables -t filter -A INPUT -p icmp -m icmp --icmp-type 11 -j ACCEPT
iptables -t filter -A INPUT -p icmp -m icmp --icmp-type 12 -j ACCEPT
#
iptables -t filter -A INPUT -s 172.16.40.0/21 -j DROP
iptables -t filter -A INPUT -s 172.17.40.0/21 -j DROP
iptables -t filter -A INPUT -j ACCEPT

# Table: nat
iptables -t nat -A POSTROUTING -s 2.1.1.0/24 -o eth0 -j SNAT --to-source 172.20.150.1
#-A PREROUTING -p tcp -d 80.69.65.224 --dport 1:1024 -j DNAT --to-destination 80.69.65.224:49382
#-A POSTROUTING -s 5.29.4.1             -j SNAT --to-source 2.10.40.17
