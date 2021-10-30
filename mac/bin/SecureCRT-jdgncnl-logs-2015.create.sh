#!/bin/bash
exit
touch -t 201501010000 /tmp/start
touch -t 201601010000 /tmp/stop
mkdir 2015
find . -maxdepth 1 -type f -name "SecureCRT*log" \( ! -newer /tmp/stop -prune \) -newer /tmp/start -exec mv "{}" 2015/ \;
tar vczf SecureCRT-jdg-logs-2015.tgz 2015/

