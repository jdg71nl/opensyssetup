#!/bin/bash
# from: http://www.cyberciti.biz/faq/unix-linux-shell-script-sorting-ip-addresses/
cat | sort -t . -k 3,3n -k 4,4n

