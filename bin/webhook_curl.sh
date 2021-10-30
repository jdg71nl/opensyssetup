#!/bin/bash
# https://stackoverflow.com/questions/35506005/emulate-github-hook-with-curl-with-secret
#
URL="http://vps4.dgt-bv.com:9922/hooks/dnsdeploy"
SECRET="DEk70-12tyZ"
DATA='{"source":"header","name":"X-Hub-Signature"}'
#
#SIG=$(echo -n "${DATA}" | openssl dgst -sha1 -hmac "${SECRET}" | awk '{print "X-Hub-Signature: sha1="$1}')
#SIG=$(echo -n "${DATA}" | openssl dgst -sha1 -hmac "${SECRET}" | awk '{print "X-Hub-Signature: sha1="$2}')
SHA=$(echo -n "${DATA}" | openssl dgst -sha1 -hmac "${SECRET}")
SIG=$(echo -n "${SHA}" | awk '{print $2}')
if [[ -z "${SIG}" ]]; then SIG=$(echo -n "${SHA}" | awk '{print $1}') ; fi
HEAD="X-Hub-Signature: sha1=${SIG}"
#
echo "> curl -v -X POST -H \"Content-Type: application/json\" -H \"${HEAD}\" --data '${DATA}' ${URL} "
curl -v -X POST -H "Content-Type: application/json" -H "${HEAD}" --data "${DATA}" ${URL}
#

