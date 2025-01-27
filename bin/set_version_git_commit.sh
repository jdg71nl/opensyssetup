#!/bin/bash
#= version_git_commit.sh| updated: d250125
# (c)2025 John @ de-Graaff .net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
# https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-read
# 
# - - - - - - = = = - - - - - - . 
echo "# "
VERSION_FILE="./VERSION"
VERSION_CUR=$(head -n1 $VERSION_FILE)
echo    "# Current version:             ==> $VERSION_CUR "
#
# - - - - - - = = = - - - - - - . 
echo "# "
counter=0
until [[ "$VERSION_NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ || $counter -gt 5 ]]
do
  read -p "Enter new version (ENTER to keep): " VERSION_NEW
  if [ -z "$VERSION_NEW" ]; then
    VERSION_NEW=$VERSION_CUR
  fi 
  if [[ ! "$VERSION_NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "# Error: no valid SEMVER a.b.c version string entered -- try again!"
  fi
  ((counter++))
done
if [[ ! "$VERSION_NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "# Error: no valid SEMVER a.b.c version string entered (aborting)"
  exit 1
fi
echo    "# New version:                 ==> $VERSION_NEW "
#
# - - - - - - = = = - - - - - - . 
echo "# "
counter=0
until [[ "$HOURS" =~ ^[0-9]+$ || $counter -gt 5 ]]
do
  read -p "Enter hours worked (integer): " HOURS
  if [[ ! "$HOURS" =~ ^[0-9]+$ ]]; then
    echo "# Error: no valid integer number entered -- try again!"
  fi
  ((counter++))
done
if [[ ! "$HOURS" =~ ^[0-9]+$ ]]; then
  echo "# Error: no valid integer number entered (aborting)"
  exit 1
fi
#
# - - - - - - = = = - - - - - - . 
echo "# "
counter=0
until [[ -n "$MSG" || "$ACCEPT" =~ ^[yY][es|ES]?$ || $counter -gt 5 ]]
do
  read -p "Enter a commit-MESSAGE: " MSG
  if [[ -z "$MSG" ]]; then
    echo "# Error: Empty string entered -- try again!"
  else
    #
    echo "# "
    echo "# the MESSAGE is: $MSG"
    echo "# "
    read -p "# Are you happy with this MESSAGE (y/n) (type 'n' to restart) ?" ACCEPT
    if [[ "$ACCEPT" =~ ^[nN][oO]?$ ]]; then
      MSG=""
    fi
  fi
  # 
  ((counter++))
done
if [[ -z "$MSG" ]]; then
  echo "# Error: Empty string entered (aborting)"
  exit 1
fi
#
# - - - - - - = = = - - - - - - . 
echo "# "
# 
COMMIT_MSG="[$VERSION_NEW] {$HOURS} $MSG ."
#
counter=0
until [[ "$ACCEPT" =~ ^[yY][es|ES]?$ || $counter -gt 5 ]]
do
  read -p "# Accept (y/n) this commit-msg: ==> $COMMIT_MSG " ACCEPT
  if [[ "$ACCEPT" =~ ^[yY](es|ES)?$ ]]; then
    break
  fi
  if [[ "$ACCEPT" =~ ^[nN][oO]?$ ]]; then
    break
  fi
  echo "# Error: type y(es) to continue ..."
  ((counter++))
done
#
if [[  "$ACCEPT" =~ ^[yY][es|ES]?$ ]]; then
  echo "# Ok, let's go ..."
  #
  echo "# "
  echo "# echo \"$VERSION_NEW\" > $VERSION_FILE"
  echo $VERSION_NEW > $VERSION_FILE
  #
  echo "# "
  echo "# > git commit -am \"$COMMIT_MSG\" " 
  git commit -am "$COMMIT_MSG"
  #
  echo "# "
  echo "# Done! "
fi
#
#-eof
