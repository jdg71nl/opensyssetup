#===============================================================
# /etc/colorprompt.sh
#
# Author: John de Graaff
#
# ---===>>> ESXi version <<<====----
#
# source file: /usr/local/syssetup/bin/colorprompt_esx.sh
#===============================================================

#===============================================================
# ESX message
#===============================================================

echo "#"
echo "# How to get rsync:"
echo "# - From MacOS-JDG go to this path:"
echo "# - cd /Volumes/JDG-ENCRYPT/NCBV/Office/TWS-NCBV\ Netwerk\ en\ Server/ESX-server/"
echo "# - scp rsync-static-stripped root@172.16.0.30:"
echo "#"

#===============================================================
# Definitions
#===============================================================

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
green='\e[0;32m'
GREEN='\e[1;32m'
yellow='\e[0;33m'
YELLOW='\e[1;33m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NOCOLOR='\e[0m'              # No Color
# --&#62; Nice. Has the same effect as using "ansi.sys" in DOS.

#===============================================================
# PATH
#===============================================================

# mac
export PATH=/usr/local/syssetup/bin/:$PATH

#===============================================================
# DISTRO info
#===============================================================

DISTRO_TYPE="ESX"
export DISTRO_TYPE=$DISTRO_TYPE

#===============================================================
# Shell prompt
#===============================================================

PS1="${cyan}--[CWD=${red}\w${cyan}]--[${red}\u${cyan}@\h]--[${yellow}$DISTRO_TYPE${cyan}]------${NOCOLOR}\n> "

#===============================================================
# Timeout
# - seconds after BASH shell will exit (for serial consoles)
#===============================================================

TMOUT=14400

#===============================================================
# FTP Passive
#===============================================================

FTP_PASSIVE=1

#===============================================================
# Proxy
#===============================================================

#ftp_proxy=http://proxy.minvenw.nl:80/
#http_proxy=http://proxy.minvenw.nl:80/

#===============================================================
# ENVIRONMENT
#===============================================================

EDITOR=vi
VISUAL=vi

#===============================================================
# ALIASES AND FUNCTIONS
#===============================================================

alias o='less -iS'
alias path='echo -e ${PATH//:/\\n}'
alias cls='clear'

alias hig='history | grep'
alias ng='lsof -i -n -P | grep'
alias psg='ps aux | grep'
#mac function -> alias fm='/usr/bin/find . \( -path '*.svn*' -prune \) -o \( -path '*/proc/*' -prune \) -o \( -type f -printf "%010T@ [%Tc] %p\n" \) | sort -n | tail'
alias cdp='echo "change dir to: `pwd -P`";cd `pwd -P`'
alias dusort='du -skx * .??* | convertsize.mac.pl | sort'
alias fusort='find -maxdepth 2 -type f -size +2048k -printf "%s\t%p\n" | convertsize.pl | sort'
alias pt='perltidy -b -i=3 --cuddled-else'

alias du='du -h'
alias df='df -kh'

alias lt='ls -altr -hp'             # sort by date-reverse (youngest at bottom)
alias ltd='find . -type d -maxdepth 1 -printf "%4m %3n %8u %8g %5s %t %f/\n"'

alias vi='vim'
alias gv='gvim -reverse'

# mac
alias ifc='ifconfig | egrep "mtu|inet"'
alias route='netstat -rn'


ff ()   { echo "# bash-function 'ff':";  /usr/bin/find . -iname '*'$1'*'; }
#fif ()  { echo "# bash-function 'fif':"; /usr/bin/find . -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }

# Mac: 
fif () { echo "# bash-function 'fif':"; /usr/bin/find . -type f -iname '*'$2'*' -print0 | xargs -0 grep -sinH "$1" "{}"; }
fm ()  { /usr/bin/find . \( -path *.svn* -prune \) -o \( -path */proc/* -prune \) -o \( -type f -iname '*'$1'*' -exec stat -f "%m%t%Sm - %z bytes - %N" "{}" \; \) | sort -n | tail -n60 ;}

# -i causes Less to search '/' with case-insensitive
# -S chop long-lines
# -F exit if one-screen
LESS='-i -S'

#===============================================================
