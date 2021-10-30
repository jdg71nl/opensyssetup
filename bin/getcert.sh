#!/bin/bash
#= getcert.sh 
# (c)2021 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ certname, e.g. sum4-anchor1.vpnsostarknl ] " 1>&2
  exit 1
}
#
NAME=$1
# bash test: -z string-zero, -n string-non-zero
[[ -z ${NAME} ]] && usage
#
CMD="scp -P48722 jdg@vpn.sostark.nl:getcert/${NAME}.* . "
echo "# running command > ${CMD} "
${CMD}
#-EOF
