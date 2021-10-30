#!/bin/bash
#
BASENAME=`basename $0`
usage() {
        echo "# usage: $BASENAME <FILE>"
        exit 1
}
if [[ -z "$1" ]]; then usage ; fi
#
DATA='{"source":"header","name":"X-Hub-Signature"}'
SECRET=""
URL=""
#
source $1
#
if [ -z "$URL" -o -z "$SECRET" ]; then echo "ERROR loading params from file $1" ; exit ; fi
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

