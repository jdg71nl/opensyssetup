#!/bin/bash
#= nis.sh
# descr: nis = npm install save
#
echo "# > npm install --save $@ ..."
npm install --save $@
#
# alt for dev-dependencies: npm install --save-dev $@
#
#-eof
