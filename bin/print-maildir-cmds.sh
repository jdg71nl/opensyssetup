#!/bin/bash

FOLDER="zzz_Archive.Inbox-2007-09"
MAILDIR="/mail/mailbox/john_imap@smallbizconcepts.nl/"
SFOLDER="zzz_Archive.Inbox-2007-Q3"
START="2007-09-01"
STOP="2007-10-01"

echo cd "$MAILDIR"
echo /usr/lib/courier-imap/bin/maildirmake -f "$FOLDER" "$MAILDIR"
echo chown -R postfix.postfix ."$FOLDER"
echo echo "INBOX.$FOLDER" \>\> "$MAILDIR"/courierimapsubscribed
echo touch -d $START /tmp/start
echo touch -d $STOP /tmp/stop
echo cd ".$SFOLDER/cur/"
echo find -maxdepth 1 -type f -name "[0-9][0-9]*" \\\( ! -newer /tmp/stop -prune \\\) -newer /tmp/start -printf \"%010T@ [%Tc] %p\n\" \| sort
echo find -maxdepth 1 -type f -name "[0-9][0-9]*" \\\( ! -newer /tmp/stop -prune \\\) -newer /tmp/start -printf \"%010T@ [%Tc] %p\n\" -exec mv "{}" "$MAILDIR/.$FOLDER/cur/" \;
echo find -maxdepth 1 -type f -name "[0-9][0-9]*" \\\( ! -newer /tmp/stop -prune \\\) -newer /tmp/start -printf \".\" -exec mv "{}" "$MAILDIR/.$FOLDER/cur/" \;



