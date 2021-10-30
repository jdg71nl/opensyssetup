#!/bin/bash

##### v1.0.0
##### written by Daniel Roesen <droesen@entire-systems.com>

##### Configuration (change as needed) ######################

CONFIG=/etc/redir-wrapper.conf	# our configuration file
REDIR=redir					# redir executable name
PING=ping

REDIR_PATH=/usr/bin			# path where redir resides
if [ ! -f "$REDIR_PATH/$REDIR" ]; then
	REDIR_PATH=/usr/sbin
fi
if [ ! -f "$REDIR_PATH/$REDIR" ]; then
	echo "error bin not found '$REDIR_PATH/$REDIR'"
	exit 1
fi

##### End of user configuration #############################

MYNAME=`basename $0`                    # name of this script

#ALSOCON="-s "
LOGCRITIC="logger $ALSOCON -p daemon.crit   -t ${MYNAME}[$$]"
LOGERROR="logger  $ALSOCON -p daemon.err    -t ${MYNAME}[$$]"
LOGNOTICE="logger $ALSOCON -p daemon.notice -t ${MYNAME}[$$]"

OPTTEMP=/tmp/${MYNAME}-options          # name of the temporary option file
IFS=${IFS}:                             # append ":" to the IFS
RET=0                                   # return-code

#############################################################

killall -q redir			# shutdown any running redirectors
rm -f $OPTTEMP				# remove temporary file

# run stop from init, then kill above and exit here
if [ "$1" == "kill" -o "$1" == "stop" ]; then
	$LOGNOTICE "stopped all redirectors ..."
	exit 0
fi

###
### reading the config file
###

if [ ! -f $CONFIG ]; then
	$LOGCRITIC "$CONFIG not found, no redirectors started!"
	exit 1
fi

###
### get default options
###

grep "^option " $CONFIG | while read JUNK OPTNAME OPTPARAM
do
	case $OPTNAME in
		debug)      echo -n " --debug" >>$OPTTEMP ;;
		timeout)    echo -n " --timeout="$OPTPARAM >>$OPTTEMP ;;
		syslog)     echo -n " --syslog" >>$OPTTEMP ;;
		identity)   echo -n " --bind_addr=$OPTPARAM" >>$OPTTEMP ;;
		ftp)        echo -n " --ftp" >>$OPTTEMP ;;
		transproxy) echo -n " --transproxy" >>$OPTTEMP ;;
		*)          $LOGERROR "unknown option \"$OPTNAME\", ignored."
		RET=1
		;;
	esac
done

###
### start redirectors
###

grep "^redir" $CONFIG | while read JUNK NAME FROMADDR FROMPORT TOADDR TOPORT OPTIONS
do
	# build argument list
	if [ "${FROMADDR}" == "*" ]
	then
		REDIR_ARGS=""
	else
		REDIR_ARGS="--laddr=${FROMADDR}"
	fi
	REDIR_ARGS=$REDIR_ARGS" --lport=${FROMPORT}"
	REDIR_ARGS=$REDIR_ARGS" --caddr=${TOADDR} --cport=${TOPORT}"
	REDIR_ARGS=$REDIR_ARGS"`cat ${OPTTEMP}` ${OPTIONS}"
	REDIR_ARGS=$REDIR_ARGS" --name=${REDIR}-${NAME}"
	
	# start the redirector
	$LOGNOTICE "starting redirector \"${NAME}\"..."
	# log action
	$REDIR_PATH/$REDIR $REDIR_ARGS &
	
#	MYPID=$!
#
#	ps $! >/dev/null
#
#	if [ $? = "0" ]
#	then
#	    $LOGNOTICE "...succeeeded!"
#	else
#	    $LOGCRITIC "redirector \"${NAME}\" failed!"
#	    RET=1
#	fi

done

### remove temporary files
rm $OPTTEMP                         # remove temporary option file

exit $RET

