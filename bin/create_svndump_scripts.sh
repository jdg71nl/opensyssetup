#!/bin/bash

REPO=`echo $1 | perl -pe 's/[\s\.\/]//g'`

SVNDIR="/var/svn_repos"
REPODIR="$SVNDIR/$REPO/"

if [[ "$REPO"  == "" ]]; then
	echo "provide a directory!"
	exit
fi

if [[ ! -d "$REPODIR" ]]; then
	echo "'$REPODIR' is not a directory!"
	exit
fi

DATE=`date +%Y%m%d`
GZ="d$DATE.$REPO.svndump.gz"
DUMP="dump.$REPO.svndump.sh"
RESTORE="restore.$REPO.svndump.sh"

cd $SVNDIR

echo "#!/bin/bash" > $DUMP
echo "svnadmin dump $REPODIR | gzip -c > $GZ" >> $DUMP
chmod +x $DUMP

echo "#!/bin/bash" > $RESTORE
echo "svnadmin create $REPODIR" >> $RESTORE
echo "zcat $GZ | svnadmin load $REPODIR" >> $RESTORE
chmod +x $RESTORE

# example: 
#
# find . -maxdepth 1 -type d | grep './' | sed 's/.\///' | xargs -i /usr/local/syssetup/bin/create_svndump_scripts.sh {}
# for x in dump.*.sh; do echo $x; . $x; done
# tar czvf d20090201.svndump.scripts.gz *sh
#
# for x in restore.*.sh; do echo $x; . $x; done


