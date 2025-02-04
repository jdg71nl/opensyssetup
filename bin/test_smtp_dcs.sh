#!/bin/bash

BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`

host="mail.whserver.nl"
port="587"
user="user"
pass="some"

echo "user = $user"
echo "pass = $pass"

# https://halon.io/blog/how-to-test-smtp-servers-using-the-command-line

user_b64=$(echo -n "$user" | base64)
pass_b64=$(echo -n "$pass" | base64)

echo "user_b64 = $user_b64"
echo "pass_b64 = $pass_b64"

echo "# after TLS connect:"
echo "# type> AUTH LOGIN "
echo "# type> (user_b64)"
echo "# type> (pass_b64)"
echo "#"
echo "# to send an emaiL:"
echo "# type> RCPT TO: john@de-graaff.net"
echo "# type> DATA"
echo "# type> Subject: Test email Subject"
echo "# type> Test email Body"
echo "# type> ."
echo "# ~~~~~~~~~~~~~~~~~~~~"

echo "# > openssl s_client -connect $host:$port -starttls smtp "
#openssl s_client -connect $host:$port -starttls smtp 
openssl s_client -quiet -connect $host:$port -starttls smtp 

#-eof

