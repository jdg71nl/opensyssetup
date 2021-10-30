#!/bin/bash
#
# replace_hardlink_with_zerofile.sh by John de Graaff
# Replace a hardlink with a zero-size file with same name, permissions and time
#
# $1 is name of hard link
# Returns 0 on success, 1 otherwise
#
# Example: To replace all the hard links in a particular directory:
# find . -xdev -type f -links +2 -print0 | xargs -0 -n 1 replace_hardlink_with_zerofile.sh
#
# HINT: use fslint to merge duplicate files into hardlinks first

FILE="$1"
DATE=`date +d%y%m%d`
TIME=`date +d%y%m%d-%H%M%S`
LOGFILE="/tmp/replace_hardlink_with_zerofile.$DATE.log"

echo -n "See logfile in /tmp/replace_hardlink_with_zerofile*: processing '$FILE' ... "

echo "--" >> $LOGFILE
echo "Starting: $0 (PID:$$):" >> $LOGFILE
echo -n "TIME = $TIME, PWD = " >> $LOGFILE
pwd >> $LOGFILE

if test "$FILE" = ""
 then
	echo
	exit 0
fi

# Check that link exists
ls "$FILE" > /dev/null
if test $? -eq 0
then
	echo " File '$FILE' found. Processing ... " >> $LOGFILE
	else
	echo " Error: File '$FILE' not found. Exiting." >> $LOGFILE
	echo " Error!"
	exit 1
fi

# Check that link is NOT a directory
echo -n " Test that link is NOT a directory ... " >> $LOGFILE
linktype=`stat --format=%F "$FILE"`
if test "$linktype" = "directory"
 then
   echo " Link to directory, skipping." >> $LOGFILE
	echo " Skipping!"
   exit 0
 else
   echo " OK!" >> $LOGFILE
fi

# Check that link count is >=2
echo -n " Test that link count is more that 1 ... " >> $LOGFILE
linkcount=`stat --format=%h "$FILE"`
if test "$linkcount" = "1"
 then
   echo " Link count is 1, skipping." >> $LOGFILE
	echo " Skipping!"
   exit 0
 else
   echo " Link count is $linkcount, OK!" >> $LOGFILE
fi

TEMPFILE="${FILE}_$TIME"

# temp-move hard link
echo -n " Renaming hard link ... " >> $LOGFILE
mv "$FILE" "$TEMPFILE"
if test $? -eq 0
 then
   echo "Done." >> $LOGFILE
 else
   echo "Error!" >> $LOGFILE
	echo " Error!"
   exit 1
fi

# Create zero-size file
echo -n " Creating zero-file '$FILE' ... " >> $LOGFILE
touch --reference="$TEMPFILE" "$FILE" 
if test $? -eq 0
 then
   echo "Done." >> $LOGFILE
 else
   echo "Error creating zero-file, restoring hard link" >> $LOGFILE
	mv "$TEMPFILE" "$FILE"
	echo " Error!"
   exit 1
fi

# Setting permissions and ownership
echo -n " Setting permissions and ownership ... " >> $LOGFILE
chmod --reference="$TEMPFILE" "$FILE" && chown --reference="$TEMPFILE" "$FILE"
if test $? -eq 0
 then
   echo "Done." >> $LOGFILE
 else
   echo "Error!" >> $LOGFILE
	echo " Error!"
   exit 1
fi

# Removing hard link
echo -n " Unlinking hard link ... " >> $LOGFILE
unlink "$TEMPFILE"
if test $? -eq 0
 then
   echo "Done." >> $LOGFILE
 else
   echo "Error!" >> $LOGFILE
	echo " Error!"
   exit 1
fi

echo " Done!"
exit 0

