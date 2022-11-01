#!/bin/bash
# git-show-repos.sh
# (c)2016 John de Graaff @ FairFlowTech

# usage from 'git client':
# ssh -t -p2221 jdg@vps3.fairflowlabs.com '/usr/local/syssetup/bin/git-show-repos.sh'
# ssh -t -p2221 jdg@vps5.dgt-bv.com '/usr/local/syssetup/bin/git-show-repos.sh'

USER="git"
DIR="/opt/git"
#HOST="vps5.dgt-bv.com"
HOST="jbase.j71.nl"
PORT="2221"
REPO="ssh://$USER@$HOST:$PORT$DIR"
#ORIG="vps5"
ORIG="jbase"
BIN="/home/jdg/opensyssetup/bin/git-show-repos.sh"
#CMD="ssh -t -p $PORT jdg@$HOST '/usr/local/syssetup/bin/git-show-repos.sh' "
CMD="ssh -t -p $PORT jdg@$HOST '$BIN' "

BASENAME=`basename $0`
usage() {
	echo
        echo "Usage: $BASENAME ":
        echo "  will show all current git repos in the /opt/git/ folder."
	echo
	echo "  usage from 'git client':"
	echo "  $CMD "
	# echo "  ssh -t -p $PORT jdg@$HOST '/usr/local/syssetup/bin/git-show-repos.sh'"
	echo
        exit 1
}
error_usage()  { echo "$BASENAME: Error - $1"; usage       ; }
error()        { echo "$BASENAME: Error - $1"; exit 1      ; }
echo_msg_log() { echo "$BASENAME: Error - $1"; logger "$1" ; }

if [[ ! -d "$DIR" ]]; then
	#usage; exit;
	$CMD
	exit
fi

cd $DIR
# find . -maxdepth 1 -type d -name '*.git' -print | sed 's/\.\///' | sed 's/\.git//' | xargs -i echo -e "git clone --origin vps3 ssh://git@vps3.fairflowlabs.com:2221/opt/git/{}.git \t\t\t ./{}/" | sort

#find . -maxdepth 1 -type d -name '*.git' -print | sed 's/\.\///' | sed 's/\.git//' | xargs -i echo -e "git clone --origin $ORIG $REPO/{}.git \t\t\t ./{}/" | sort
find . -maxdepth 1 -type d -name '*.git' -print | sed 's/\.\///' | sed 's/\.git//' | xargs -i echo -e "git clone --origin $ORIG $REPO/{}.git \t ./{}/" | sort | sed 's/\.\/web--/\.\//g' | sed 's/--web\//\//g'

find . -maxdepth 1 -type d -name '*.git' -print | sed 's/\.\///' | sed 's/\.git//' | xargs -i echo -e "git remote add $ORIG $REPO/{}.git " | sort

