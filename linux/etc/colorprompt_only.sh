#===============================================================
# /etc/colorprompt.sh
#===============================================================

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
# DISTRO info
#===============================================================

# # /etc/distro.info 
# # read by: /etc/colorprompt.sh 
# DISTRO_TYPE="Debian5"

DISTROFILE="/etc/distro.info"
[[ -f $DISTROFILE ]] && source $DISTROFILE
[[ -z $DISTRO_TYPE ]] && DISTRO_TYPE="Unknown-Distro"
export DISTRO_TYPE=$DISTRO_TYPE

#===============================================================
# Shell prompt
#===============================================================

PS1="${cyan}--[CWD=${red}\w${cyan}]--[\t \D{%a %d-%b-%Y %Z}]--[${red}\u${cyan}@\h]--[${yellow}$DISTRO_TYPE${cyan}]------${NOCOLOR}\n> "

#===============================================================
# Timeout
# - seconds after BASH shell will exit (for serial consoles)
#===============================================================

# note: apparently "system1>ssh system2" will timeout system1 ....
# so only apply to serial consoles

# seconds   time
# 900	      15 min
# 1800      30 min
# 3600      1 hour
# 14400     4 hours
# 28800     8 hours
# 86400     1 day (24 hours)

TMOUT=14400

#===============================================================
# FTP Passive
#===============================================================

FTP_PASSIVE=1

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
alias fm='/usr/bin/find . \( -path "*.svn*" -prune \) -o \( -path "*/proc/*" -prune \) -o \( -type f -printf "%010T@ [%Tc] (%10s Bytes) %p\n" \) | sort -n | tail'
alias ifc="/sbin/ifconfig | egrep 'encap|addr|MTU'"
alias cdp='echo "change dir to: `pwd -P`";cd `pwd -P`'
alias dusort='du -sbx * .??* | convertsize.pl | sort'
alias fusort='find -maxdepth 2 -type f -size +2048k -printf "%s\t%p\n" | convertsize.pl | sort'
alias pt='perltidy -b -i=3 --cuddled-else'
alias lsofg="lsof | egrep '(REG|DIR)' | grep"
alias route6="route -A inet6 -n"

alias du='du -h'
alias df='df -kh'

alias lt='ls -altr -hp'             # sort by date-reverse (youngest at bottom)
alias ltd='find . -type d -maxdepth 1 -printf "%4m %3n %8u %8g %5s %t %f/\n"'

#alias vi='/usr/local/bin/syssetup/vi'
#alias joe='/usr/local/bin/syssetup/joe'
#alias vi="/usr/bin/vim"
#alias vi='vim'
#alias gv='gvim -reverse'

if [[ -f "/usr/bin/vim" ]]; then
 alias vi="/usr/bin/vim"
fi

ff ()   { echo "# bash-function 'ff':";  /usr/bin/find . -iname '*'$1'*'; }
ff2 ()  { echo "# bash-function 'ff2':"; /usr/bin/find . ! -ipath '*.svn*' -iname '*'$1'*'; }
fif ()  { echo "# bash-function 'fif':"; /usr/bin/find . -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
fif2 () { echo "# bash-function 'fif':"; /usr/bin/find . -xtype f ! -ipath '*.svn*' -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
# Mac: fif () { echo "# bash-function 'fif':"; /usr/bin/find . -type f -iname '*'$2'*' -print0 | xargs -0 grep -sinH "$1" "{}"; }

# -i causes Less to search '/' with case-insensitive
# -S chop long-lines
# -F exit if one-screen
LESS='-i -S'

#===============================================================
#===============================================================
