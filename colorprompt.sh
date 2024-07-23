#===============================================================
# $HOME/opensyssetup/colorprompt.sh
# Author: John @ de-Graaff .net
#===============================================================

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

export PATH=$HOME/opensyssetup/bin:$HOME/opensyssetup/mac/bin:$PATH

# https://code.visualstudio.com/docs/setup/mac
#
# --[CWD=~/opensyssetup(git:main)]--[1705867071 20:57:51 Sun 21-Jan-2024 CET]--[jdg@MB18-jdg71nl]--[os:MacOS--13.6.3,isa:x86_64]------
# > lt /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code
# -rwxr-xr-x  1 jdg  staff   1.0K Jan 18 15:28 /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code
#
#export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
#
# above gives errors on non-Mac platforms
# better create symlink:
# > cd ~
# > ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code .

# jdg-tokenme:
alias sti='sudo -u tokenme -i' 

#===============================================================
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
# 172800    2 day  (48 hours)

#TMOUT=43200
TMOUT=172800

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
#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
# d231117 https://forums.raspberrypi.com/viewtopic.php?t=273633
# or ... just leave it all alone (in this script, leave to OS):
#unset LC_ALL

#===============================================================
# ALIASES AND FUNCTIONS
#===============================================================

alias o='less -iS'
alias path='echo -e ${PATH//:/\\n}'
alias cls='clear'

alias hig='history | grep'
#
#alias ng='lsof -i -n -P | grep'
#alias ng='lsof -i -n -P +c0 | egrep' # cando? include COMMAND in egrep?? > lsof -i -n -P +c0 | egrep "COMMAND|LISTEN"
# https://stackoverflow.com/questions/7181620/how-do-i-create-an-alias-where-the-arguments-go-in-the-middle
alias ng='f(){ lsof -i -n -P +c0 | egrep "PID|$1" ; unset -f f; }; f'
#ng () { lsof -i -n -P +c0 | egrep "PID|$1" }
alias ng_sudo='f(){ sudo lsof -i -n -P +c0 | egrep "PID|$1" ; unset -f f; }; f'
#
alias psg='ps aux | grep'
alias psg_sudo='sudo ps aux | grep'
#
alias fm='/usr/bin/find . \( -path "*.svn*" -prune \) -o \( -path "*/proc/*" -prune \) -o \( -type f -printf "%010T@ [%Tc] (%10s Bytes) %p\n" \) | sort -n | tail'
#alias ifc="/sbin/ifconfig | egrep 'encap|addr|MTU'"
#alias ifc='/sbin/ifconfig | egrep -i "encap|addr|mtu|inet|ether"'
alias ifc='echo "# ip addr show | egrep -i \"mtu|ether|inet\" .." && ip addr show | egrep -i "mtu|ether|inet"'
alias cdp='echo "change dir to: `pwd -P` ..";cd "`pwd -P`"'
#
#alias dusort='du -sbx * .??* | convertsize.pl | sort'
#alias fusort='find . -maxdepth 2 -type f -size +2048k -printf "%s\t%p\n" | convertsize.pl | sort'
alias dusort='find . -maxdepth 1 -type d -exec du -sbx "{}" \;  | convertsize.pl | append_slash.pl | sort'
# idea 'du -hxd' from: https://www.nikouusitalo.com/blog/fixing-raspberry-pi-vnc-cannot-currently-show-the-desktop-but-its-not-resolution-or-hdmi_force_hotplug/
alias dusort2='f_dusort2(){ sudo du -hxd 1 $1 | sort -h ; unset -f f_dusort2; }; f_dusort2'
alias duasort='find . -type d -exec du -sbx "{}" \;  | convertsize.pl | append_slash.pl | sort'
# mac
alias dusortm="du -skx * | $HOME/opensyssetup/mac/bin/convertsize.mac.pl | sort"
#alias duasortm='find . -type d -exec du -sx "{}" \;  | convertsize.pl | append_slash.pl | sort'
alias duasortm='find . -type d -exec du -sx "{}" \;  | $HOME/opensyssetup/mac/bin/convertsize.mac.pl  | append_slash.pl | sort'
# needs gfind from MacPorts: sudo port install findutils
#
alias fmm='gfind . \( -path "*.svn*" -prune \) -o \( -path "*/proc/*" -prune \) -o \( -type f -printf "%010T@ [%Tc] (%10s Bytes) %p\n" \) 
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
alias lsp='ls -d -1 $PWD/*'            # ls with full path

#alias vi='$HOME/bin/syssetup/vi'
#alias joe='$HOME/bin/syssetup/joe'
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
#ffm ()   { echo "# bash-function, see 'type ff':"; find . -iname '*'$1'*'; }
ffm ()   { echo "# bash-function, see 'type ffm':"; gfind . -iname '*'$1'*'; }

# fifm on basis of MacPorts (problems?!?):
#> port install findutils
#> port contents findutils
#  /opt/local/bin/gfind
#  /opt/local/bin/gxargs
#fifm ()  { echo "# bash-function, see 'type fifm':"; find . -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"; }
#
# fifm on basis of brew:
# brew install findutils
fifm ()  { echo "# bash-function, see 'type fifm':"; gfind . -xtype f -iname '*'$2'*' -print0 | gxargs -0i grep -sinH "$1" "{}"; }
#
# alt:
# > brew install ffind
# > brew install rargs
fifm2 ()  { echo "# bash-function, see 'type fifm':"; ffind . -xtype f -iname '*'$2'*' -print0 | rargs -0 egrep -sinH "$1" "{}"; }

# -i causes Less to search '/' with case-insensitive
# -S chop long-lines
# -F exit if one-screen
LESS='-i -S'

# https://superuser.com/questions/1251360/messed-layout-in-htop
# "I solved this problem by adding an alias for htop in ~/.bashrc: alias htop='TERM=xterm-color htop' "
alias htop='TERM=xterm-color htop'

#===============================================================
# Exec scripts at start Shell:
#===============================================================

if [ -r ~/opensyssetup/bin/oss-check-repo.sh ]; then
  ~/opensyssetup/bin/oss-check-repo.sh
fi

if [ -r ~/opensyssetup/bin/write_distro_file.sh ]; then
  ~/opensyssetup/bin/write_distro_file.sh
fi

#===============================================================
# DISTRO info
#===============================================================

#DISTROFILE="/etc/distro.info"
DISTROFILE="$HOME/distro.info"
[[ -f $DISTROFILE ]] && source $DISTROFILE
[[ -z $DISTRO_TYPE ]] && DISTRO_TYPE="Unknown-Distro"
#
export DISTRO_TYPE=$DISTRO_TYPE
#
if [ ! -z "$JINFO_PLATFORM" ]; then
  export JINFO_PLATFORM="$JINFO_PLATFORM"
  export JINFO_HARDWARE="$JINFO_HARDWARE"
  export JINFO_ISA="$JINFO_ISA"
  export JINFO_OS="$JINFO_OS"
  export JINFO_VERSION="$JINFO_VERSION"
  export JINFO_CODENAME="$JINFO_CODENAME"
  export JINFO_KERNEL="$JINFO_KERNEL"
fi
#

#===============================================================
# Shell prompt
#===============================================================

# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/index.html

# idea from: https://david.newgas.net/return_code/
#export PROMPT_COMMAND='ret=$?; if [ $ret -ne 0 ] ; then echo -e "returned \033[01;31m$ret\033[00;00m"; fi'
export PROMPT_COMMAND='ret=$?; if [ $ret -ne 0 ] ; then echo -e "\n#( bash[PROMPT_COMMAND]: prev.cmd returned non-zero code: \033[01;31m$ret\033[00;00m )"; else echo; fi'

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
#[ -r /usr/local/syssetup/git-completion.bash ] && source /usr/local/syssetup/git-completion.bash
#[ -f /usr/local/syssetup/git-prompt.sh ] && source /usr/local/syssetup/git-prompt.sh
[ -r $HOME/opensyssetup/git-completion.bash ] && source $HOME/opensyssetup/git-completion.bash
[ -f $HOME/opensyssetup/git-prompt.sh ] && source $HOME/opensyssetup/git-prompt.sh
#
RED='\e[1;31m' ; GREEN='\e[1;32m' ; YELLOW='\e[1;33m' ; BLUE='\e[1;34m' ; CYAN='\e[1;36m' ; NOCOLOR='\e[0m'
nothingnessssssssxssssssssssssss=""
#
[   -f $HOME/opensyssetup/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${YELLOW}"'$(__git_ps1 "(git:%s)")'"${CYAN}]--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
[ ! -f $HOME/opensyssetup/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${CYAN}]${$nothingnessssssssxssssssssssssss}--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
#
#: # d240723 new fixed-length-truncated-path. idea from: https://www.gilesorr.com/bashprompt/prompts/twtty.html 
#: TERMWIDTH=${COLUMNS}
#: let promptsize=$(echo -n "--(${usernam}@${hostnam}:${cur_tty})---(${PWD})--" | wc -c | tr -d " ")
#: let fillsize=${TERMWIDTH}-${promptsize}
#: fill=""
#: while [ "$fillsize" -gt "0" ]; do 
#:   fill="${fill}-"
#:   let fillsize=${fillsize}-1
#: done
#: if [ "$fillsize" -lt "0" ]l then
#:   let cut=3-${fillsize}
#:   newPWD="...$(echo -n $PWD | sed -e "s/\(^.\{$cut\}\)\(.*\)/\2/")"
#: fi
#: #
#: [   -f $HOME/opensyssetup/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${YELLOW}"'$(__git_ps1 "(git:%s)")'"${CYAN}]--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
#: [ ! -f $HOME/opensyssetup/git-prompt.sh ] && export PS1="${CYAN}--[CWD=${RED}\w${CYAN}]${$nothingnessssssssxssssssssssssss}--[\D{%s} \t \D{%a %d-%b-%Y %Z}]--[${RED}\u${CYAN}@\h]--[${YELLOW}$DISTRO_TYPE${CYAN}]------${NOCOLOR}\n> "
#: #

#===============================================================
# Mac exports

# https://support.apple.com/en-us/102360
# "To silence this warning, you can add this command to ~/.bash_profile or ~/.profile: "
export BASH_SILENCE_DEPRECATION_WARNING=1

#===============================================================
#===============================================================


