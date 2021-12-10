#!/bin/bash

BASENAME=$(basename $0)
#FILE="/etc/distro.info"
FILE="$HOME/distro.info"

# jdg: better not sudo here, as we want to write file to user-homedir..
## sudo
#MYID=$( id -u )
#if [ $MYID != 0 ]; then
#  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 1 ;  # DONT USE $* !!
#  echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
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
      echo "## MODELSTRING='${MODELSTRING}'"
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
        "long string")
          HARD='shortstring'
          ;;
        *)
          #HARD='Unkn' 
          HARD=""
          ;;
      esac
    fi

    OS=$(lsb_release -is)
    # Debian
    VER=$(lsb_release -rs)
    # 8.7
    # 10
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
      *)
        FRIENDLY=""
        ;;
    esac
    #
    OSSTRING="os:MacOS-${FRIENDLY}-${SWVERS}"
    KERNSTRING=""
    ISA=$(uname -m)
    # x86_64
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
  if [ ! -z "${HARD}" ]; then
    HARD="hw:${HARD},"
  fi
  DISTRO="${HARD}${OSSTRING}${KERNSTRING},isa:${ISA}"

  cat <<HERE >$FILE
# /etc/distro.info
# used by: $ HOME/syssetup/colorprompt.sh
DISTRO_TYPE="$DISTRO"
HERE

  echo "## new file '$FILE' written."
  echo "#> cat $FILE : "
  cat $FILE
}

# - - - - - - - - + + + - - - - - - - - 

unknown_os ()
{
  echo "## unknown os/dist ..."
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

  echo "## Detected operating system as os="$os" dist="$dist" ."
}

main ()
{
  #echo "## running $BASENAME ..."
  # detect_os
  write_distro
  echo "## done! "
}

main

# RPI-Zero:
# DISTRO_TYPE="hw:Still-Unknown,os:Raspbian-10/buster,kernel:5.10.17+,arch:armhf,isa:armv6l"

#

