#!/bin/bash
#= git-create-repo-user-git.sh 
# (c)2016 John de Graaff @ FairFlowTech

# usage from 'git client':
# ssh -t -p2221 jdg@vps3.fairflowlabs.com '/usr/local/syssetup/bin/git-create-repo-user-git.sh rtpc.git'
# ssh -t -p2221 jdg@vps5.dgt-bv.com '/usr/local/syssetup/bin/git-create-repo-user-git.sh rtpc.git'

USER="git"
DIR="/opt/git"
#GITHOST="vps5.dgt-bv.com"
GITHOST="jbase.j71.nl"
PORT="2221"
REPO="ssh://$USER@$GITHOST:$PORT$DIR"
#ORIG="vps5"
ORIG="jbase"
BIN="/home/jdg/opensyssetup/bin/git-create-repo-user-git.sh"

REPNAME="$1"
REPDIR="$DIR/$REPNAME.git"

#CMD="ssh -t -p $PORT jdg@$GITHOST 'REPO=\"RepoName\" ; /usr/local/syssetup/bin/git-create-repo-user-git.sh \$REPO' "
#CMD="ssh -t -p $PORT jdg@$GITHOST '/usr/local/syssetup/bin/git-create-repo-user-git.sh $REPNAME'"
#CMD="ssh -t -p $PORT jdg@$GITHOST '/usr/local/syssetup/bin/git-create-repo-user-git.sh repo-name '"
#CMD="ssh -t -p $PORT jdg@$GITHOST '/bin/bash -c \"/usr/local/syssetup/bin/git-create-repo-user-git.sh $REPNAME\" '"
#CMD="echo \"/usr/local/syssetup/bin/git-create-repo-user-git.sh $REPNAME\" | ssh -t -p $PORT jdg@$GITHOST '/bin/bash -l -s' "
CMD="ssh -t -p $PORT jdg@$GITHOST '$BIN repo-name-without-.git '"

BASENAME=`basename $0`
usage() {
	echo
	echo "Usage: $BASENAME <repo-name>.git":
	echo "  will create dir '/opt/git/repo-name.git/' and in it do 'git init --bare'"
	echo
	echo "  usage from 'git client':"
	echo "  $CMD "
	# echo "  ssh -t -p $PORT jdg@$GITHOST 'REPO=\"RepoName\" ; /usr/local/syssetup/bin/git-create-repo-user-git.sh repo-name '"
	echo
	#exit 1
}
error_usage()  { echo "# $BASENAME: Error - $1"; usage       ; }
error()        { echo "# $BASENAME: Error - $1"; exit 1      ; }
echo_msg_log() { echo "# $BASENAME: Error - $1"; logger "$1" ; }

if [[ ! -d "$DIR" ]]; then
	usage; 
	exit;
	#
	# echo "[running]> $CMD "
	# # $CMD
	# echo "/usr/local/syssetup/bin/git-create-repo-user-git.sh $REPNAME" | ssh -t -p $PORT jdg@$GITHOST '/bin/bash -l -s'
	# exit
fi


[[ "$REPNAME" == "" ]]              && error_usage "provide new Repo name (without .git)"
#[[ "$REPNAME" =~ "git" ]]          && error_usage "provide new repo name (WITHOUT .git)"
echo "$REPNAME" | egrep -iq "\.git" && error_usage "provide new repo name (without .GIT)"
[[ -d "$REPDIR" ]]                  && error "directory '$REPDIR' already exists!"

# > visudo
# #jdg
# %sudo ALL=NOPASSWD:/bin/mkdir
# %sudo ALL=NOPASSWD:/usr/bin/git

echo "# OK we're good, I got this command with correct params:"
echo "# /usr/local/syssetup/bin/git-create-repo-user-git.sh $REPNAME.git' ..."
#exit

echo "# > sudo -u $USER /bin/mkdir -pv \"$REPDIR\" ..."
sudo -u $USER /bin/mkdir -pv "$REPDIR"
[[ ! -d "$REPDIR" ]] && error "could not create directory '$REPDIR' !"

echo "# > cd \"$REPDIR\" ..."
cd "$REPDIR"

echo "# > sudo -u $USER /usr/bin/git init --bare ..."
sudo -u $USER /usr/bin/git init --bare

# jdg: cant do this in bare repo... https://git-scm.com/docs/git-init
#FILE="empty.txt"
#sudo -u $USER touch $FILE
#sudo -u $USER /usr/bin/git add $FILE
#sudo -u $USER /usr/bin/git commit -am 'initial commit'
#sudo -u $USER /usr/bin/git push

#
echo "# done!"
echo
echo "# next use these commands to add and setup remote:"
cat <<HERE
#
# Note that this remote-repo is empty, so a 'git clone' will warn.
# Best to do a small init commit:
#
git clone ssh://git@$GITHOST:2221/opt/git/$REPNAME.git 
touch README.txt
git add README.txt 
git commit -am "initial"
git push
#
git-show-repos.sh 
git remote add jbase ssh://git@$GITHOST:2221/opt/git/$REPNAME.git 
git push --set-upstream jbase main
git branch --set-upstream-to=jbase/main main
#
HERE
echo "# that's it folks!"

#
