#!/bin/bash
#= debian_install_default_apt.sh
# (c)2023 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
f_check_install_packages() { 
  for PKG in $@ ; do 
    if ! dpkg-query -l $PKG >/dev/null ; then 
      echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
      sudo apt install -y $PKG 
    fi
  done
}
# f_check_install_packages curl git sudo
#

#: OS=""
#: DEBDIST=""
#: if [ -e /etc/debian_version ]; then
#:   #
#:   #OS=$(cat /etc/issue | head -1 | awk '{ print tolower($1) }')
#:   OS=$(cat /etc/issue | head -1 | awk '{ print $1 }')
#:   #
#:   # OS="Debian"
#:   # OS="Ubuntu"
#:   #
#:   # some Debians have jessie/sid in their /etc/debian_version
#:   # while others have '6.0.7'
#:   if grep -q '/' /etc/debian_version; then
#:     DEBDIST=$(cut --delimiter='/' -f1 /etc/debian_version)
#:   else
#:     DEBDIST=$(cut --delimiter='.' -f1 /etc/debian_version)
#:   fi
#: fi
#: echo "# OS='$OS' DEBDIST='$DEBDIST' "
#: if [ $OS != "Debian" && $OS != "Raspbian" ] ; then
#:   echo "# Error: detected non-Debian, so exit ..."
#:   exit 1
#: fi

# NOTE: external variables are REMOVED by 'sudo' for security reasons.
#
#JINFO_PLATFORM="$(JINFO_PLATFORM)"
#JINFO_HARDWARE="$(JINFO_HARDWARE)"
#JINFO_ISA="$(JINFO_ISA)"
#JINFO_OS="$(JINFO_OS)"
#JINFO_VERSION="$(JINFO_VERSION)"
#JINFO_CODENAME="$(JINFO_CODENAME)"
#JINFO_KERNEL="$(JINFO_KERNEL)"
#
# so we reinvent them:
JINFO_OS=$(lsb_release -is)
JINFO_VERSION=$(lsb_release -rs)

if test ! -f /etc/debian_version ; then
  echo "# Error: detected non-Debian, so exit ..."
  exit 1
else
  echo "# found Debian-like OS, so proceeding ..."
  echo "# JINFO_OS=\"$JINFO_OS\" "
  echo "# JINFO_VERSION=\"$JINFO_VERSION\" "
fi

#
#: if [ $DEBDIST == "12" ]; then
#:   echo "# > apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat-openbsd arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog ... "
#:             apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat-openbsd arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog
#: else
#:   echo "# > apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat         arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog ... "
#:             apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat         arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog
#: fi
#
# example: ADD_PKG_LINES="pkg1 \n pkg2 "
ADD_PKG_LINES=""
#
# jdg: preferred way of testing in Bash ??:
# https://stackoverflow.com/questions/13408493/an-and-operator-for-an-if-statement-in-bash
# if test $JINFO_OS = "Ubuntu" && test $JINFO_VERSION = "23.10"; then echo "yes" ; else echo "no" ; fi
#
# jdg: more modern way:
# https://ioflood.com/blog/bash-if-and/
# if [[ $var -gt 10 && $var -lt 20 ]]; then echo "yes"; fi
#
# jdg:
# https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php
#
# d240128 jdg: fuck, above ALL fails and errors, I don't know why but [[ works:
#
# d240202 jdg: I found major bug: all above may just work IF the "$variable" is enclosed in parenthesis !!
#
#JINFO_OS="Debian"
#JINFO_VERSION="12"
#
#
if [ "$JINFO_OS" = "Ubuntu" ]; then
  echo "# adding specific package for: Ubuntu ..."
  ADD_PKG_LINES="netcat-openbsd"
elif [ "$JINFO_OS" = "Debian" -a "$JINFO_VERSION" = "12" ]; then
  echo "# adding specific package for: Debian 12 ..."
  ADD_PKG_LINES="netcat-openbsd"
else
  echo "# adding specific package for: \"other\" distro's ..."
  ADD_PKG_LINES="netcat"
fi
# d241001 disabled:
ADD_PKG_LINES=""
#
#
FILE="apt_default_list.txt"
#
PKG_STRING="$(echo -e $ADD_PKG_LINES | cat $FILE - | sort | tr '\n' ' ')"
#echo "# PKG_STRING=\"$PKG_STRING\""
#
echo "# apt install -y $PKG_STRING "
apt install -y $PKG_STRING 
#

# d231119 changes:
# Package netcat is a virtual package provided by:
#  netcat-openbsd 1.219-1
#  netcat-traditional 1.10-47
# You should explicitly select one to install.
# 
## also (manual?): 
#
# apt install -y ifupdown net-tools vlan bridge-utils
# DON'T?: apt remove dhcpcd5
#
# for: xeyes
# apt install -y x11-apps x11-utils 
#
# apt install -y build-essential 
# apt install -y build-essential dkms bc raspberrypi-kernel-headers
#
# apt install -y lshw hwinfo inxi
#
# apt install -y hostapd isc-dhcp-server dnsproxy
# apt install -y hostapd isc-dhcp-server dnsmasq-base
#
exit 0
#
#-eof















#!/bin/bash
# display every line executed in this bash script:

VERBOSE="N"
#VERBOSE="Y"
#set -o xtrace
#
if [ $VERBOSE == "Y" ]; then
  set -o xtrace
fi
#

echo_verbose() {
  if [ $VERBOSE == "Y" ]; then
    echo $1
  fi
}

BASENAME=$(basename $0)
#FILE="/etc/distro.info"
FILE="$HOME/distro.info"

# jdg: better not sudo here, as we want to write file to user-homedir..
## sudo
#MYID=$( id -u )
#if [ $MYID != 0 ]; then
#  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ;  # DONT USE $* !!
#  echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
#fi

# - - - - - - - - + + + - - - - - - - - 

write_distro()
{

  # https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
  # https://wuhrr.wordpress.com/2020/06/19/detect-os-and-distro-in-bash/
  # https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
  #
  #case "$(uname -s)" in
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

  # - - - - - - - - + + + - - - - - - - - 

  #HARD='Unknown' 
  HARD=""
  #
  if [ "${PLAT}" = "Linux" ]; then

    # https://raspberrytips.com/which-raspberry-pi-model/
    # cat /proc/cpuinfo | grep Model
    # Model : Raspberry Pi 4 Model B Rev 1.1
    #
    # cat /sys/firmware/devicetree/base/model
    # cat /proc/device-tree/model
    #
    # https://raspberrypi.stackexchange.com/questions/61699/which-model-raspberry-pi-i-am-running
    # https://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version/
    #
    RASPFILE="/proc/device-tree/model"
    # > cat /proc/device-tree/model
    # Raspberry Pi Model B Plus Rev 1.2
    # Raspberry Pi 3 Model B Rev 1.2
    if [[ -f ${RASPFILE} ]]; then
      #
      MODELSTRING="$( cat ${RASPFILE} | tr '\0' '\n' )"
      echo_verbose "## MODELSTRING='${MODELSTRING}'"
      #
      case "${MODELSTRING}" in
        "Raspberry Pi Zero W Rev 1.1")
          HARD='RPIZW-1.1'
          ;;
        "Raspberry Pi Model B Plus Rev 1.2")
          HARD='RPI1B+1.2'
          ;;
        "Raspberry Pi 2 Model B Rev 1.1")
          HARD='RPI2b-1.1'
          ;;
        "Raspberry Pi 3 Model B Rev 1.2")
          HARD='RPI3b-1.2'
          ;;
        "Raspberry Pi 3 Model B Plus Rev 1.3")
          HARD='RPI3b+1.3'
          ;;
        "Raspberry Pi 4 Model B Rev 1.2")
          HARD='RPI4b-1.2'
          ;;
        "Raspberry Pi 4 Model B Rev 1.3")
          HARD='RPI4b-1.3'
          ;;
        "Raspberry Pi 4 Model B Rev 1.4")
          HARD='RPI4b-1.4'
          ;;
        "Raspberry Pi 4 Model B Rev 1.5")
          HARD='RPI4b-1.5'
          ;;
        "Raspberry Pi 5 Model B Rev 1.0")
          HARD='RPI5b-1.0'
          ;;
        "long string")
          HARD='shortstring'
          ;;
        *)
          #HARD='Unkn' 
          #HARD=""
          HARD="${MODELSTRING}"
          ;;
      esac
    fi

    OS=$(lsb_release -is)
    # Debian

    VER=$(lsb_release -rs)
    # 8.7
    # 10

    # COD = Codename
    COD=$(lsb_release -cs)
    # jessie
    # buster

    KER=$(uname -r)
    # 4.19.0-14-amd64
    ISA=$(uname -m)
    # x86_64

    ## if Debian or derivative:
    #if [ $(which dpkg 2>/dev/null) ]; then   
    #  ARCH=",arch:$( dpkg --print-architecture )"
    #  ARCH=""
    #else
    #  ARCH=""
    #fi

    OSSTRING="os:${OS}-${VER}/${COD}"
    KERNSTRING=",kernel:${KER}${ARCH}"
  fi

  # - - - - - - - - + + + - - - - - - - - 

  # https://www.cyberciti.biz/faq/mac-osx-find-tell-operating-system-version-from-bash-prompt/
  # https://www.shell-tips.com/mac/find-macos-version/
  #
  # > sw_vers
  # ProductName:    macOS
  # ProductVersion: 11.2.3
  # BuildVersion:   20D91
  #
  # > system_profiler SPSoftwareDataType 
  # Software:
  #     System Software Overview:
  #       System Version: macOS 11.2.3 (20D91)
  #       Kernel Version: Darwin 20.3.0
  #       Boot Volume: Macintosh HD
  #       Boot Mode: Normal
  #       Computer Name: iMac19-jdg71nl
  #       User Name: John de Graaff (jdg)
  #       Secure Virtual Memory: Enabled
  #       System Integrity Protection: Enabled
  #       Time since boot: 9 days 1:05
  #
  # > vers=$(sw_vers -productVersion)
  # 11.2.3
  # > major=${vers%.*}
  # 11.2
  #
  if [ "${PLAT}" = "MacOS" ]; then
    #HARD="Mac"
    HARD=""
    #
    SWVERS=$(sw_vers -productVersion)
    MAJOR=${SWVERS%.*}
    #
    case "${MAJOR}" in
      "10.0")
        FRIENDLY="Cheetah"
        ;;
      "10.1")
        FRIENDLY="Puma"
        ;;
      "10.2")
        FRIENDLY="Jaguar"
        ;;
      "10.3")
        FRIENDLY="Panther"
        ;;
      "10.4")
        FRIENDLY="Tiger"
        ;;
      "10.5")
        FRIENDLY="Leopard"
        ;;
      "10.6")
        FRIENDLY="Snow Leopard"
        ;;
      "10.7")
        FRIENDLY="Lion"
        ;;
      "10.8")
        FRIENDLY="Mountain Lion"
        ;;
      "10.9")
        FRIENDLY="Mavericks"
        ;;
      "10.10")
        FRIENDLY="Yosemite"
        ;;
      "10.11")
        FRIENDLY="El Capitan"
        ;;
      "10.12")
        FRIENDLY="Sierra"
        ;;
      "10.13")
        FRIENDLY="High Sierra"
        ;;
      "10.14")
        FRIENDLY="Mojave"
        ;;
      "10.15")
        FRIENDLY="Catalina"
        ;;
      "11.0")
        FRIENDLY="Big Sur"
        ;;
      "11")
        FRIENDLY="Big Sur"
        ;;
      "11.1")
        FRIENDLY="Big Sur"
        ;;
      "11.2")
        FRIENDLY="Big Sur"
        ;;
      "11.3")
        FRIENDLY="Big Sur"
        ;;
      "11.4")
        FRIENDLY="Big Sur"
        ;;
      *)
        FRIENDLY=""
        ;;
    esac
    #
    OSSTRING="os:MacOS-${FRIENDLY}-${SWVERS}"
    KERNSTRING=""
    # following misreads on M1, see: https://forum.latenightsw.com/t/detect-arm64-or-intel-architecture/2803/2
    ISA=$(uname -m)
    # x86_64
    # alternative: check this file exists (only on M1):
    if [ -f /System/Library/Extensions/AppleARMPMU.kext/Contents/MacOS/AppleARMPMU ]; then
      ISA="arm64"
    fi 

  fi

  # - - - - - - - - + + + - - - - - - - - 

  # > lsb_release --help
  # Usage: lsb_release [options]
  #
  # Options:
  #   -h, --help         show this help message and exit
  #   -v, --version      show LSB modules this system supports
  #   -i, --id           show distributor ID
  #   -d, --description  show description of this distribution
  #   -r, --release      show release number of this distribution
  #   -c, --codename     show code name of this distribution
  #   -a, --all          show all of the above information
  #   -s, --short        show requested information in short format

  # > uname --help
  # Usage: uname [OPTION]...
  # Print certain system information.  With no OPTION, same as -s.
  #
  #   -a, --all                print all information, in the following order,
  #                              except omit -p and -i if unknown:
  #   -s, --kernel-name        print the kernel name
  #   -n, --nodename           print the network node hostname
  #   -r, --kernel-release     print the kernel release
  #   -v, --kernel-version     print the kernel version
  #   -m, --machine            print the machine hardware name
  #   -p, --processor          print the processor type (non-portable)
  #   -i, --hardware-platform  print the hardware platform (non-portable)
  #   -o, --operating-system   print the operating system
  #       --help     display this help and exit 
  #       --version  output version information and exit
  #
  # GNU coreutils online help: <https://www.gnu.org/software/coreutils/>
  # Full documentation at: <https://www.gnu.org/software/coreutils/uname>
  # or available locally via: info '(coreutils) uname invocation'

  # - - - - - - - - + + + - - - - - - - - 

  #DISTRO="$OS-$VER($COD)-$ARCH"
  #DISTRO="platform:$PLAT-dist:$OS-$VER/$COD-kernel:$KER-arch:$ARCH"
  #DISTRO="plat:$PLAT,dist:$OS-$VER/$COD,kernel:$KER,arch:$ARCH"
  #DISTRO="hw:${HARD},plat:${PLAT},dist:${OS}-${VER}/${COD},kernel:${KER},arch:${ARCH}"
  #DISTRO="hw:${HARD},${OSSTRING}${KERNSTRING},isa:${ISA}"
  HARDSTRING="$HARD"
  if [ ! -z "${HARDSTRING}" ]; then
    HARDSTRING="hw:${HARDSTRING},"
  fi
  #DISTRO="${HARD}${OSSTRING}${KERNSTRING},isa:${ISA}"
  #
  # --------->>>>> Now we can build the DISTRO-string !! <<<<<----------- :
  DISTRO="${HARDSTRING}${OSSTRING},isa:${ISA}"

  # Examples $DISTRO:
  # hw:RPI4b-1.5,os:Debian-11/bullseye,isa:aarch64
  # os:Debian-12/bookworm,isa:x86_64
  # hw:RPI5b-1.0,os:Ubuntu-23.10/mantic,isa:aarch64

  export JINFO_PLATFORM="$PLAT"
  export JINFO_HARDWARE="$HARD"
  export JINFO_ISA="$ISA"
  export JINFO_OS="$OS"
  export JINFO_VERSION="$VER"
  export JINFO_CODENAME="$COD"
  export JINFO_KERNEL="$KER"

  echo "# JINFO_PLATFORM=\"$JINFO_PLATFORM\""
  echo "# JINFO_HARDWARE=\"$JINFO_HARDWARE\""
  echo "# JINFO_ISA=\"$JINFO_ISA\""
  echo "# JINFO_OS=\"$JINFO_OS\""
  echo "# JINFO_VERSION=\"$JINFO_VERSION\""
  echo "# JINFO_CODENAME=\"$JINFO_CODENAME\""
  echo "# JINFO_KERNEL=\"$JINFO_KERNEL\""

  # /etc/distro.info
  # used by: $ HOME/syssetup/colorprompt.sh
  cat <<HERE >$FILE
#= $HOME/distro.info
# used by: $HOME/opensyssetup/colorprompt.sh
DISTRO_TYPE="$DISTRO"
#
JINFO_PLATFORM="$JINFO_PLATFORM"
JINFO_HARDWARE="$JINFO_HARDWARE"
JINFO_ISA="$JINFO_ISA"
JINFO_OS="$JINFO_OS"
JINFO_VERSION="$JINFO_VERSION"
JINFO_CODENAME="$JINFO_CODENAME"
JINFO_KERNEL="$JINFO_KERNEL"
#
HERE

  echo_verbose "## new file '$FILE' written."
  echo_verbose "#> cat $FILE : "
  if [ $VERBOSE == "Y" ]; then
    cat $FILE
  fi
}

# - - - - - - - - + + + - - - - - - - - 

unknown_os ()
{
  echo_verbose "## unknown os/dist ..."
  exit 1
}

detect_os ()
{
  if [[ ( -z "${os}" ) && ( -z "${dist}" ) ]]; then
    # some systems dont have lsb-release yet have the lsb_release binary and
    # vice-versa
    if [ -e /etc/lsb-release ]; then
      . /etc/lsb-release

      if [ "${ID}" = "raspbian" ]; then
        os=${ID}
        dist=$(cut --delimiter='.' -f1 /etc/debian_version)
      else
        os=${DISTRIB_ID}
        dist=${DISTRIB_CODENAME}

        if [ -z "$dist" ]; then
          dist=${DISTRIB_RELEASE}
        fi
      fi

    elif [ $(which lsb_release 2>/dev/null) ]; then
      dist=$(lsb_release -c | cut -f2)
      os=$(lsb_release -i | cut -f2 | awk '{ print tolower($1) }')

    elif [ -e /etc/debian_version ]; then
      # some Debians have jessie/sid in their /etc/debian_version
      # while others have '6.0.7'
      os=$(cat /etc/issue | head -1 | awk '{ print tolower($1) }')
      if grep -q '/' /etc/debian_version; then
        dist=$(cut --delimiter='/' -f1 /etc/debian_version)
      else
        dist=$(cut --delimiter='.' -f1 /etc/debian_version)
      fi

    else
      unknown_os
    fi
  fi

  if [ -z "$dist" ]; then
    unknown_os
  fi

  # remove whitespace from OS and dist name
  os="${os// /}"
  dist="${dist// /}"

  echo_verbose "## Detected operating system as os="$os" dist="$dist" ."
}

main ()
{
  #echo "## running $BASENAME ..."
  # detect_os
  write_distro

  echo_verbose "## done! "
}

main

# RPI-Zero:
# DISTRO_TYPE="hw:Still-Unknown,os:Raspbian-10/buster,kernel:5.10.17+,arch:armhf,isa:armv6l"

#

