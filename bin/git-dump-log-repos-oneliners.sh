#!/bin/bash
#= git-dump-log-repos-oneliners.sh 
# 2024(c) John@de-Graaff.net
#
# find bash bug using:
# set -x
#
MONTH=$1
# WRONG, USE PARENTHESIS AROUND VARIABLE , THIS GIVES ERROR ==> if [ $MONTH = "" ]; then
# CORRECT ==> if [ "$MONTH" = "" ]; then
# BETTER:
if [ -z "$MONTH" ]; then
  echo "# provde month in YYYY-MM format .."
  exit 1
fi
echo "# month = $MONTH"

# pop/remove first argument in $@ :
shift
REPOS_LIST="$@"
if [ -z "$REPOS_LIST" ]; then
  echo "# provde a list of 1 or more space-separated repo_names .."
  exit 1
fi
echo "# REPOS_LIST = $REPOS_LIST"
# exit 0

# NOTE: need DatTime package in Perl
# git-dump-month-to-since-before.pl
# sudo apt install -y libdatetime-perl

# MY_ARGS=$( ./git-dump-month-to-since-before.pl $1 )
MY_ARGS=$( git-dump-month-to-since-before.pl $MONTH )
# echo "${MY_ARGS}" ; exit

# idea from: https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in
# sentence="this is a story"
# stringarray=($sentence)
# echo ${stringarray[0]}

ARG_ARRAY=($MY_ARGS)
SINCE=${ARG_ARRAY[0]}
BEFORE=${ARG_ARRAY[1]}
echo "# calc => SINCE=$SINCE BEFORE=$BEFORE"

# GITLOGDIR="git_log"
GITLOGDIR="git_log_jdg_repo/git_log"
mkdir -pv $GITLOGDIR/$MONTH

ALLFILE="git-log-oneline-numstat--repo--ALL--month-$MONTH.csv"
echo "# ALLFILE=$ALLFILE "
rm -f ./$GITLOGDIR/$MONTH/$ALLFILE
touch ./$GITLOGDIR/$MONTH/$ALLFILE

# for REPO in TokenMe-* SUM4 ; do 
#for REPO in TokenMe-Dashboard-Server TokenMe-API-Server TokenMe-Architecture ; do 
for REPO in $REPOS_LIST ; do 

  echo "# - - - - - - = = = - - - - - - " 
  echo "START for-loop iteration: REPO='$REPO'" 
  # FILE="git-log-oneline-numstat--repo--$REPO--since-$SINCE--before-$BEFORE"
  FILE="git-log-oneline-numstat--repo--$REPO--month-$MONTH"
  # echo "FILE='$FILE'" 
  #
  TXT="$FILE.txt"
  echo "TXT='$TXT'" 
  #
  echo "# > cd $REPO ..."
  cd $REPO
  #
  echo "# > git log --oneline --all --pretty=format:'\"epoch:%at\",\"time:%ad\",\"repo:REPONAME\",\"abbrev-hash:%h\",\"committer:%ae\",\"subject:%s\"' --numstat --since=\"$SINCE\" --before=\"$BEFORE\" > ../$GITLOGDIR/$MONTH/$TXT "
            git log --oneline --all --pretty=format:'"epoch:%at","time:%ad","repo:REPONAME","abbrev-hash:%h","committer:%ae","subject:%s"'             --numstat --since="$SINCE" --before="$BEFORE" > ../$GITLOGDIR/$MONTH/$TXT
  #
  cd -
  #
  # -s == size, so if >0 then not empty:
  if [ -s ./$GITLOGDIR/$MONTH/$TXT ]; then
    #
    SMASH="${FILE}-smash.csv"
    # echo "SMASH='$SMASH'" 
    #
    echo "# smashing ..."
    cat ./$GITLOGDIR/$MONTH/$TXT | sed "s/REPONAME/$REPO/" \
    | git-dump-smash.pl \
    > ./$GITLOGDIR/$MONTH/$SMASH
    #
    # | perl -e 'my $LAST="", $ADD="", $REM="", $FILE=""; while (my $LINE=<STDIN>) { chomp($LINE); next if ($LINE eq ""); if ($LINE =~ /^"/) {$LAST=$LINE; ($ADD,$REM,$FILE) = ("","",""); } else {($ADD,$REM,$FILE) = split /\s/, $LINE; print "$LAST,\"added:$ADD\",\"removed:$REM\",\"file:$FILE\"\n"; } }' \
    #
    # append ALL file ...
    echo "# > cat ./$GITLOGDIR/$MONTH/$SMASH >> ./$GITLOGDIR/$MONTH/$ALLFILE ..."
    cat ./$GITLOGDIR/$MONTH/$SMASH >> ./$GITLOGDIR/$MONTH/$ALLFILE
    #
  fi
  #
  # rm ./$GITLOGDIR/$MONTH/$TXT
  #
  echo "END for-loop iteration: REPO='$REPO'" 
  echo
  # 
  #
done
#
echo "# done. "
echo
#
#-EOF

