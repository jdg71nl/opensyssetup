#!/bin/bash
infile="$1"
outfile="$1.renattach"
[[ -f "$infile" ]] || echo "not a regular file '$infile'"
[[ -f "$infile" ]] || exit 1
cat "$infile" | renattach -ad > "$outfile"
touch --reference="$infile" "$outfile"
chmod --reference="$infile" "$outfile"
chown --reference="$infile" "$outfile"
mv "$outfile" "$infile"
# possible usage: 
# find -type f -name "[0-9][0-9]*" -size +100k -exec ls -altrhp {} \; -exec /usr/local/bin/syssetup/strip_attachments.sh "{}" \;

