#!/bin/bash
#= Drop_File_Rename_Proper.sh
#
# Create Automator script Drop_File_Showpath.app using "Run Shell Script" and copy/paste there contents of this .sh file

function do_print {
  echo "# Drop_File_Rename_Proper TYPE=$1 FILENAME='$2' "
}

for FILENAME in "$@" ; do
  #
	if [[ -d "${FILENAME}" ]]; then
		do_print "d" "${FILENAME}"
	elif [[ -f "${FILENAME}" ]]; then
		do_print "f" "${FILENAME}"
  else
		do_print "?" "${FILENAME}"
	fi ;
  #
	# break;
done ;

#-EOF
