#!/bin/sh

# example:
# echo_sendmail.sh "To: notification.jdg@de-graaff.net\nFrom: ns1\nSubject: crontab message\n \nMessages= ping succeeded"

# crontab example:
# 00 * * * * root ping6 -c1 -W1 -q 2a00:1188:0004::1201 ; if [ "$?" -eq "0" ]; then echo_sendmail.sh "To: notification.jdg@de-graaff.net\nFrom: ns1\nSubject: crontab message\n \nMessages= ping 2a00:1188:0004::1201 success" ; fi

LINE=$1
TO=$(echo -e $LINE | egrep -i '^to:' | sed 's/to: //i')
echo -e "$LINE" 
echo "sendmail $TO ..."
#echo -e "$LINE" | sendmail $TO
echo -e "$LINE" | sendmail -t
logger "$0: $LINE"

