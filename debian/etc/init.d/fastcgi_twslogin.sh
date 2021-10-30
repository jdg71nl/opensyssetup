#!/bin/bash
### BEGIN INIT INFO
# Provides:          fastcgitwslogin
# Required-Start:    $syslog $remote_fs $network lighttpd
# Required-Stop:     $syslog $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the FastCGI web server TWSlogin
### END INIT INFO

# example from:
# http://wiki.catalystframework.org/wiki/deployment/lighttpd_fastcgi

# APP_USER must exist and have a valid shell (i.e. /bin/bash)
APP_NAME=twslogin
APP_PATH=/home/jdgncnl/SSHFS/TWSLogin
#APP_USER=twslogin_user
APP_USER=jdgncnl
FCGI_TCP_CONNECTION=127.0.0.1:55901
PID_PATH=/var/run/$APP_NAME.prod.pid
LOG_FILE="$APP_PATH"/log/twslogin-err.log
NPROC=1

case $1 in
start)
    if [ -r "$PID_PATH" ] && kill -0 $(cat "$PID_PATH") >/dev/null 2>&1
    then
        echo " FastCGI_Server $APP_NAME already running"
        exit 0
    fi

    echo -n "Starting FastCGI_Server $APP_NAME (${APP_NAME}_fastcgi.pl)..."

    touch "$PID_PATH"
    chown "$APP_USER" "$PID_PATH"

    cd "$APP_PATH"
    su -c "\"script/${APP_NAME}_fastcgi.pl\"\\
       --listen $FCGI_TCP_CONNECTION\\
       --pidfile \"$PID_PATH\"\\
       --nproc $NPROC\\
       --keeperr\\
       --daemon" "$APP_USER" 2>>"$LOG_FILE"

    # Wait for the app to start  
    TIMEOUT=10; while [ ! -r "$PID_PATH" ] && ! kill -0 $(cat "$PID_PATH")
    do
        echo -n '.'; sleep 1; TIMEOUT=$((TIMEOUT - 1))
        if [ $TIMEOUT = 0 ]; then
            echo " ERROR: TIMED OUT"; exit 0
        fi
    done
    echo " started."
    ;;

stop)
    echo -n "Stopping FastCGI_Server $APP_NAME: "
    if [ -r "$PID_PATH" ] && kill -0 $(cat "$PID_PATH") >/dev/null 2>&1
    then
        PID=`cat $PID_PATH`
        echo -n "killing $PID... "; kill $PID
        echo -n "OK. Waiting for the FastCGI server to release the
        port..."
        TIMEOUT=60
        while netstat -tnl | grep -q $FCGI_TCP_CONNECTION; do
            echo -n "."; sleep 1; TIMEOUT=$((TIMEOUT - 1))
            if [ $TIMEOUT = 0 ]; then
                echo " ERROR: TIMED OUT"; exit 0
            fi
        done
        echo " OK."
    else
        echo "FastCGI_Server $APP_NAME not running."
    fi
    ;;

restart|force-reload)
    $0 stop
    echo -n "A necessary sleep... "; sleep 2; echo "done."
    $0 start
    ;;

*)
    echo "Usage: $0 { stop | start | restart }"
    exit 1
    ;;
esac
