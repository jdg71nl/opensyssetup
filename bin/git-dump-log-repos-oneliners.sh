#!/bin/bash
#= git-dump-log-repos-oneliners.sh 
# 2022(c) John@de-Graaff.net

MONTH=$1
if [ $MONTH == "" ]; then
  echo "# provde month in YYY-MM format .."
  exit 1
fi
echo "# month = $MONTH"

# MY_ARGS=$( ./month-to-since-before.pl $1 )
MY_ARGS=$( month-to-since-before.pl $1 )
# echo "${MY_ARGS}" ; exit

# idea from: https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in
# sentence="this is a story"
# stringarray=($sentence)
# echo ${stringarray[0]}

ARG_ARRAY=($MY_ARGS)
SINCE=${ARG_ARRAY[0]}
BEFORE=${ARG_ARRAY[1]}
echo "# calc => SINCE=$SINCE BEFORE=$BEFORE"

ALLFILE="git-log-oneline-numstat--repo--ALL--month-$MONTH.csv"
rm -f $ALLFILE
touch $ALLFILE

for REPO in TokenMe-* SUM4 ; do 
  # echo "REPO='$REPO'" 
  # FILE="git-log-oneline-numstat--repo--$REPO--since-$SINCE--before-$BEFORE"
  FILE="git-log-oneline-numstat--repo--$REPO--month-$MONTH"
  # echo "FILE='$FILE'" 
  #
  TXT="$FILE.txt"
  # echo "TXT='$TXT'" 
  #
  echo "# > cd $REPO ..."
  cd $REPO
  #
  echo "# > git log --oneline --all --pretty=format:'\"epoch:%at\",\"time:%ad\",\"repo:REPONAME\",\"abbrev-hash:%h\",\"committer:%ae\",\"subject:%s\"' --numstat --since=\"$SINCE\" --before=\"$BEFORE\" > ../$TXT"
  git log --oneline --all --pretty=format:'"epoch:%at","time:%ad","repo:REPONAME","abbrev-hash:%h","committer:%ae","subject:%s"' --numstat --since="$SINCE" --before="$BEFORE" > ../$TXT
  cd -
  #
  # -s == size, so if >0 then not empty:
  if [ -s $TXT ]; then
    #
    SMASH="${FILE}-smash.csv"
    # echo "SMASH='$SMASH'" 
    #
    echo "# smashing ..."
    cat $TXT | sed "s/REPONAME/$REPO/" | perl -e 'my $LAST="", $ADD="", $REM="", $FILE=""; while (my $LINE=<STDIN>) { chomp($LINE); next if ($LINE eq ""); if ($LINE =~ /^"/) {$LAST=$LINE; ($ADD,$REM,$FILE) = ("","",""); } else {($ADD,$REM,$FILE) = split /\s/, $LINE; print "$LAST,\"added:$ADD\",\"removed:$REM\",\"file:$FILE\"\n"; } }' > $SMASH
    #
    # append ALL file ...
    echo "# > cat $SMASH > $ALLFILE ..."
    cat $SMASH >> $ALLFILE
    #
  fi
  rm $TXT
  #
  echo "# done. "
  echo
  #
done

#-EOF

