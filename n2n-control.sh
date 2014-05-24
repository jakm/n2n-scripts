#!/bin/bash

EXEC=$(type /usr/sbin/edge | awk '{print $3}')
PROG=n2n
CONFIG=/etc/n2n.conf
PIDFILE=/var/run/${PROG}.pid
LOGFILE=/var/log/${PROG}.log

start() {
    if ! [ -x $EXEC ]; then
        echo The edge executable does not exist
        exit 2
    fi
    if ! [ -f $CONFIG ]; then
        echo Config file does not exist
        exit 2
    fi
    
    . $CONFIG

    USERID=$(id -u $USER)
    if [ $? != 0 ]; then
        echo User $USER does not exist
        exit 2
    fi

    GROUPID=$(id -g $GROUP)
    if [ $? != 0 ]; then
        echo Group $GROUP does not exist
        exit 2
    fi

    export N2N_KEY=$KEY
    nohup $EXEC -a $ADDRESS -m $MAC -c $COMMUNITY -l $SUPERNODE -u $USERID -g $GROUPID &> $LOGFILE &

    PID=$!

    if ! kill -0 $PID 2> /dev/null; then
        return 1
    fi

    echo $PID > $PIDFILE
    return 0
}

stop() {
    if [ -f $PIDFILE ]; then
        kill $(cat $PIDFILE) 2> /dev/null
        sleep 2
        kill -9 $(cat $PIDFILE) 2> /dev/null

        rm -f $PIDFILE
    fi
}

restart() {
    stop
    start
}

status_q() {
    [ -f $PIDFILE ] && kill -0 $(cat $PIDFILE) 2> /dev/null
    return $?
}

status() {
    if status_q; then
        echo $PROG is running
    else
        echo $PROG is stopped
    fi
}

case "$1" in
    start)
        status_q && exit 0
        $1
        ;;
    stop)
        status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    status)
        $1
        ;;
    *)
        echo "Usage: $(basename $0) [start|stop|restart|status]"
        exit 2
esac
