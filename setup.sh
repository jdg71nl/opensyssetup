#!/bin/bash
#= setup.sh

if [ ! -d "$HOME/opensyssetup/" ]; then
  echo "# error: this setup.sh scripts can only be used if directory '$HOME/opensyssetup/' exists .. "
  exit 1;
fi

MYUID=$( id -u )
# 100x for user, 0 for root
echo "# UID is ${MYUID} "

#LOGNAME <== is bash built-in
# e.g.: "jdg"

IS_DEBIAN_DERIVATIVE="$(which dpkg 2>/dev/null)"
# for Debian derivatives: "/usr/bin/dpkg"

# - - - 
# determine platform:
case "$(uname -s)" in
  Darwin)
    PLAT='MacOS'
    ;;
  Linux)
    PLAT='Linux'
    ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    PLAT='Windows' 
    ;;
  *)
    PLAT='Unknown' 
    ;;
esac
echo "# detected platform ${PLAT} "
# usage:
# if [ "${PLAT}" == "Linux" ]; then
# fi

# - - - 
#
echo "# running $HOME/opensyssetup/bin/write_distro_file.sh .."
. $HOME/opensyssetup/bin/write_distro_file.sh

# - - - 
if [ "${IS_DEBIAN_DERIVATIVE}" ]; then
  echo "# manually install these packages: "
  echo "# > sudo apt install -y git curl htop lsof vim apt-transport-https ca-certificates curl gnupg lsb-release "
  echo
fi

if [ "${PLAT}" == "Linux" ]; then
  if [ "${MYUID}" == 0 ]; then
    SFILE="cp-jdg-Xauthority.sh"
    cd $HOME
    rm $SFILE
    ln -s ./opensyssetup/bin/$SFILE .
    echo "# created symlink ./opensyssetup/bin/$SFILE $SFILE"
  fi
fi

DIR="$HOME/syssetup"
if [ -L ${DIR} ]; then 
  rm ${DIR}
  echo "# removed symlink ${DIR} "
fi

FILE="$HOME/.bashrc"
if [ -f "${FILE}" ]; then
  if [ "${PLAT}" == "Linux" ]; then
    sed -i 's/^.*colorprompt.sh.*$//' ${FILE}
    sed -i 's/^.*syssetup.*$/# &/'    ${FILE}
    sed -i '/^(#\s*|\s*)$/d'          ${FILE}
    echo -e "\nsource \$HOME/opensyssetup/colorprompt.sh \n" >> $FILE
    # ln -sf /usr/local/opensyssetup/linux/etc/colorprompt.sh /etc/colorprompt.sh
    # echo -e "\n#\n. /etc/colorprompt.sh\n" >> ~/.bashrc
    # echo -e "\n#\n. /etc/colorprompt.sh\n" >> /etc/skel/.bashrc
    # echo -e "\n#\n. /etc/colorprompt.sh\n" >> /home/jdg/.bashrc 
    echo "# add source-command in ${FILE} "
  fi
fi

#FILE="$HOME/.profile"
FILE="$HOME/.bashrc"
if [ -f "${FILE}" ]; then
  if [ "${PLAT}" == "MacOS" ]; then
    sed -i "" 's/^.*colorprompt.sh.*$//' ${FILE}
    sed -i "" 's/^.*syssetup.*$/# &/'    ${FILE}
    sed -i "" '/^(#\s*|\s*)$/d'          ${FILE}
    echo -e "\nsource \$HOME/opensyssetup/colorprompt.sh \n" >> $FILE
    #
    echo "# add source-command in ${FILE} "
    #
    DIR="$HOME/bin"
    if [ -L ${DIR} ]; then 
      rm ${DIR}
      ln -s opensyssetup/mac/bin/ ${DIR}
      echo "# symlink opensyssetup/mac/bin/ to ${DIR} "
    fi
    #ln -sf /usr/local/opensyssetup/mac/bin/colorprompt.sh /etc/colorprompt.sh
    #echo "\n#\n. /etc/colorprompt.sh\n" >> /etc/profile
  fi
fi

ODIR="/usr/local/syssetup"
NDIR="/usr/local/_syssetup"
if [ -d "${ODIR}" ]; then
  if [ "${MYUID}" == 0 ]; then
    mv ${ODIR} ${NDIR}
    echo "# renamed ${ODIR} to ${NDIR} "
  fi
fi

# - - - 
if [ "${LOGNAME}" == "jdg" ]; then
  #
  git config --global user.name "John de Graaff"
  git config --global user.email john@de-graaff.net
  git config --global alias.ss "status -s"        # short status
  git config --global alias.logg "log --oneline --decorate --graph --all --pretty=format:'%C(auto)%h %aD %d %s'"
  git config --global alias.logn "log --oneline --decorate --graph --all --pretty=format:'%h - %ae - %ad : %s' --numstat"
  # will set in this file: ~/.gitconfig  
  # [user]
  #         name = John de Graaff
  #         email = john@de-graaff.net
  # [alias]
  #         ss = status -s
  #         logg = log --oneline --decorate --graph --all --pretty=format:'%C(auto)%h %aD %d %s'
  #         logn = log --oneline --decorate --graph --all --pretty=format:'%h - %ae - %ad : %s' --numstat
  echo "# set git config for user jdg "
fi

# - - - 
#-EOF
