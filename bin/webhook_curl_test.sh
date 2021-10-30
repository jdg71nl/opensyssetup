#!/bin/bash
#
BASENAME=`basename $0`
usage() {
        echo "# usage: $BASENAME <DATA> <SECRET> <HOST>"
        echo "# - for GitHub use DATA = '{"source":"header","name":"X-Hub-Signature"}' "
        echo "# - $BASENAME '{"source":"header","name":"X-Hub-Signature"}' <SECRET> <HOST>"
        exit 1
}
if [[ -z "$3" ]]; then usage ; fi
#
#DATA='{"source":"header","name":"X-Hub-Signature"}'
DATA=$1
SECRET=$2
URL=$3
#
# idea from: https://stackoverflow.com/questions/35506005/emulate-github-hook-with-curl-with-secret
SHA=$(echo -n "${DATA}" | openssl dgst -sha1 -hmac "${SECRET}")
SIG=$(echo -n "${SHA}" | awk '{print $2}')
if [[ -z "${SIG}" ]]; then SIG=$(echo -n "${SHA}" | awk '{print $1}') ; fi
HEAD="X-Hub-Signature: sha1=${SIG}"
#
echo "> curl -v -X POST -H \"Content-Type: application/json\" -H \"${HEAD}\" --data '${DATA}' ${URL} "
curl -v -X POST -H "Content-Type: application/json" -H "${HEAD}" --data "${DATA}" ${URL}
#

