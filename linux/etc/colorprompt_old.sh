#===============================================================
# /etc/colorprompt.sh
#
# Author: John de Graaff
#
# source file: /usr/local/syssetup/linux/etc/colorprompt.sh
#===============================================================

# INSTALL
#
# # on Redhat/CentOS:
# ln -sf /usr/local/syssetup/linux/etc/colorprompt.sh /etc/colorprompt.sh
# ln -sf /etc/colorprompt.sh /etc/profile.d/colorprompt.sh
# #or: /bin/cp -af /usr/local/syssetup/linux/etc/colorprompt.sh /etc/colorprompt.sh
#
# # on Debian/Ubuntu/MacOS:
# ln -sf /usr/local/syssetup/linux/etc/colorprompt.sh /etc/colorprompt.sh
# echo -e "\n#\n. /etc/colorprompt.sh\n" >> ~/.bashrc 
# echo -e "\n#\n. /etc/colorprompt.sh\n" >> /etc/skel/.bashrc 
# #or: /bin/cp -af /usr/local/syssetup/linux/etc/colorprompt.sh /etc/colorprompt.sh

/usr/bin/logger "start colorprompt.sh as user '$USER'"

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

#export PATH=/usr/local/syssetup/bin:$PATH
export PATH=/usr/local/syssetup/bin:~/syssetup/bin:$PATH

#===============================================================
# DISTRO info
#===============================================================

DISTROFILE="/etc/distro.info"
[[ -f $DISTROFILE ]] && source $DISTROFILE
[[ -z $DISTRO_TYPE ]] && DISTRO_TYPE="Unknown-Distro"
export DISTRO_TYPE=$DISTRO_TYPE

#===============================================================
# Shell prompt
#===============================================================

# version 1:
#
# --[22:26:19 jdegraaff@multi-delft-01]-------------------------------------------
# /etc/profile.d>
#
#PS1="${cyan}--[\t \u@\h]-------------------------------------------${NOCOLOR}\n\w> "

# version 2:
#
# --[CWD=/etc/profile.d]--[22:25:37]--[root@multi-delft-01]------
# >
#
#PS1="${cyan}--[CWD=${red}\w${cyan}]--[\t]--[${red}\u${cyan}@\h]------${NOCOLOR}\n> "
#PS1="${cyan}--[CWD=${red}\w${cyan}]--[\t \d]--[${red}\u${cyan}@\h]------${NOCOLOR}\n> "
#PS1="${cyan}--[CWD=${red}\w${cyan}]--[\t \d]--[${red}\u${cyan}@\h:$DISTRO_TYPE]------${NOCOLOR}\n> "
#PS1="${cyan}--[CWD=${red}\w${cyan}]--[\t \d]--[${red}\u${cyan}@\h]--[${yellow}$DISTRO_TYPE${cyan}]------${NOCOLOR}\n> "

#PS1="${cyan}--[CWD=${red}\w${cyan}]--[\t \D{%a %d-%b-%Y %Z}]--[${red}\u${cyan}@\h]--[${yellow}$DISTRO_TYPE${cyan}]------${NOCOLOR}\n> "

# git completion and prompt:
[ -r /usr/local/syssetup/git-completion.bash ] && source /usr/local/syssetup/git-completion.bash
[ -f /usr/local/syssetup/git-prompt.sh ] && source /usr/local/syssetup/git-prompt.sh
RED='\e[1;31m' ; GREEN='\e[1;32m' ; YELLOW='\e[1;33m' ; BLUE='\e[1;34m' ; CYAN='\e[1;36m' ; NOCOLOR='\e[0m'
[ -f /usr/local/syssetup/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${YELLOW}"'$(__git_ps1 "(git:%s)")'"${CYAN}]--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
[ ! -f /usr/local/syssetup/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${CYAN}]--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
#

# IDEA (from Daniel Demirdag @TWS):
#declare -x SSH_CONNECTION="172.16.53.1 53289 172.16.53.146 22"

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
# 43200     12 hours
# 86400     1 day (24 hours)

TMOUT=43200

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

# https://blogs.agilefaqs.com/2014/01/12/fixing-perl-warning-setting-locale-failed-on-mac-osx/
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
#alias ifc="/sbin/ifconfig | egrep 'encap|addr|MTU'"
#alias ifc='/sbin/ifconfig | egrep -i "encap|addr|mtu|inet|ether"'
alias ifc='ip addr show | egrep -i "mtu|ether|inet"'
alias cdp='echo "change dir to: `pwd -P` ..";cd "`pwd -P`"'
#alias dusort='du -sbx * .??* | convertsize.pl | sort'
#alias fusort='find . -maxdepth 2 -type f -size +2048k -printf "%s\t%p\n" | convertsize.pl | sort'
alias dusort=' find . -maxdepth 1 -type d -exec du -sbx "{}" \;  | convertsize.pl | append_slash.pl | sort'
alias duasort='find . -type d -exec du -sbx "{}" \;  | convertsize.pl | append_slash.pl | sort'
# mac
alias dusortm="du -skx * | /usr/local/syssetup/mac/bin/convertsize.mac.pl | sort"
#alias duasortm='find . -type d -exec du -sx "{}" \;  | convertsize.pl | append_slash.pl | sort'
alias duasortm='find . -type d -exec du -sx "{}" \;  | /usr/local/syssetup/mac/bin/convertsize.mac.pl  | append_slash.pl | sort'
# needs gfind from MacPorts: sudo port install findutils
alias fmm='/opt/local/bin/gfind . \( -path "*.svn*" -prune \) -o \( -path "*/proc/*" -prune \) -o \( -type f -printf "%010T@ [%Tc] (%10s Bytes) %p\n" \) 
| sort -n | tail'
#
alias fusort=' find . -maxdepth 1 -type f -size +1024k -printf "%s\t%p\n" | convertsize.pl | sort'
alias fuasort='find . -type f -size +1024k -printf "%s\t%p\n" | convertsize.pl | sort'
alias pt='perltidy -b -i=3 --cuddled-else'
alias lsofg="lsof | egrep '(REG|DIR)' | grep"
alias route6="route -A inet6 -n"

alias du='du -h'
alias df='df -kh'

alias lt='ls -altr -hp'                # sort by date-reverse (youngest at bottom)
alias ltt='ls -altr -hp | tail -n30'   # lt with tail
alias ltd='find . -type d -maxdepth 1 -printf "%4m %3n %8u %8g %5s %t %f/\n"'

#alias vi='/usr/local/bin/syssetup/vi'
#alias joe='/usr/local/bin/syssetup/joe'
#alias vi="/usr/bin/vim"
#alias vi='vim'
#alias gv='gvim -reverse'

if [[ -f "/usr/bin/vim" ]]; then
 alias vi="/usr/bin/vim"
fi

alias curl-cat="curl -fsL"
alias curl-save="curl -fsLO"

ff ()   { echo "# bash-function, see 'type ff':";  /usr/bin/find . -iname '*'$1'*'; }
ff2 ()  { echo "# bash-function, see 'type ff2':"; /usr/bin/find . ! -ipath '*.svn*' -iname '*'$1'*'; }
fif ()  { echo "# bash-function, see 'type fif':"; /usr/bin/find . -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
fif2 () { echo "# bash-function, see 'type fif2':"; /usr/bin/find . -xtype f ! -ipath '*.svn*' -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
# Mac: fif () { echo "# bash-function, see 'type fif':"; /usr/bin/find . -type f -iname '*'$2'*' -print0 | xargs -0 grep -sinH "$1" "{}"; }
#ffm ()   { echo "# bash-function, see 'type ff':";  /opt/local/libexec/gnubin/find . -iname '*'$1'*'; }
ffm ()   { echo "# bash-function, see 'type ffm':";  /usr/local/bin/gfind . -iname '*'$1'*'; }

# fifm on basis of MacPorts (problems?!?):
#> port install findutils
#> port contents findutils
#  /opt/local/bin/gfind
#  /opt/local/bin/gxargs
#fifm ()  { echo "# bash-function, see 'type fifm':"; /opt/local/libexec/gnubin/find . -xtype f -iname '*'$2'*' -print0 | /opt/local/libexec/gnubin/xargs -0i grep -sinH "$1" "{}"; }
#
# fifm on basis of brew:
# brew install findutils
fifm ()  { echo "# bash-function, see 'type fifm':"; /usr/local/bin/gfind . -xtype f -iname '*'$2'*' -print0 | /usr/local/bin/gxargs -0i grep -sinH "$1" "{}"; }

# -i causes Less to search '/' with case-insensitive
# -S chop long-lines
# -F exit if one-screen
LESS='-i -S'

#===============================================================
#===============================================================



