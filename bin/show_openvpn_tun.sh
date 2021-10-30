#!/bin/bash

fif () { echo "# bash-function 'fif':"; /usr/bin/find . -maxdepth 2 -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }

cd /etc/openvpn/
( \
fif dev '*.conf' | perl -ne '$_ =~ /\/([^\/]*).*?dev (.*)/;            printf "%-16s snif-it  : tethereal -n -i %s\n",$1,$2;' ;\
find -type d -maxdepth 2 -name '*_*' | perl -ne '$_ =~ /.\/(.*)/;    printf "%-16s log-file : o /var/log/openvpn-%s.log\n",$1,$1;' ;\
fif management '*.conf' | perl -ne '$_ =~ /.\/(.*)\/.*?127.0.0.1 (.*)/;printf "%-16s mangement: telnet 127.0.0.1 %s\n",$1,$2;' ;\
) | sort
