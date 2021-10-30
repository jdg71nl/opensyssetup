#!/bin/bash
#= md5sum-create-checkfile.sh

FILES=$1
if [ -z "${FILES}" ]; then
  FILES="*"
fi

CHECKFILE="md5sum-checkfile.txt"
#
# man bash:   -f file    True if file exists and is a regular file.
#
if [ -f "${CHECKFILE}" ]; then
  echo "file '${CHECKFILE}' exists, exiting!"
  exit 1
fi

#echo "# md5sum-create-checkfile.sh #> 'md5sum ${FILES} > ${CHECKFILE}' # test using: #> 'md5sum -c ${CHECKFILE}' " > ${CHECKFILE}
#md5sum ${FILES} >> ${CHECKFILE}

MFILE=`md5sum ${FILES}`
echo "# md5sum-create-checkfile.sh #> 'md5sum ${FILES} > ${CHECKFILE}' # test using: #> 'md5sum -c ${CHECKFILE}' " > ${CHECKFILE}
echo "${MFILE}" >> ${CHECKFILE}

#
