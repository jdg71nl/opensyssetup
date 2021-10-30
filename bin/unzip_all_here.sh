#!/bin/bash
echo '# running... > for x in *.zip; do echo $x; unzip -o $x ; done'
for x in *.zip; do echo $x; unzip -o $x ; done
#-EOF
