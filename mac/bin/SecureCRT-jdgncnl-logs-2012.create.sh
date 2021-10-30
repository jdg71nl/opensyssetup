#!/bin/bash
exit
touch -t 201201010000 /tmp/start
touch -t 201301010000 /tmp/stop
mkdir 2012
find . -maxdepth 1 -type f -name "SecureCRT*log" \( ! -newer /tmp/stop -prune \) -newer /tmp/start -exec mv "{}" 2012/ \;
tar vczf SecureCRT-jdgncnl-logs-2012.tgz 2012/

