#!/bin/bash
exit
touch -t 201101010000 /tmp/start
touch -t 201201010000 /tmp/stop
mkdir 2011
find . -maxdepth 1 -type f -name "SecureCRT*log" \( ! -newer /tmp/stop -prune \) -newer /tmp/start -exec mv "{}" 2011/ \;
tar vczf SecureCRT-jdgncnl-logs-2011.tgz 2011/

