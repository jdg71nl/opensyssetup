#!/bin/bash
ssh -p2221 root@flexvpn.onc.nl 'cd /var/lib/rancid/switches/configs/; tar czf - 172* | openssl base64' | openssl base64 -d | tar xvzf -

