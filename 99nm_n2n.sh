#!/bin/bash

IF=$1
STATUS=$2

CONFIG=/etc/nm_n2n.conf

[ -f $CONFIG ] && . $CONFIG || exit 1

get_ip_addr() {
    local ADDR=$(ip addr show ${IF} | \
        grep -P 'inet (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}) brd' | \
        awk '{print $2}')
    echo $ADDR
}

get_network_addr() {
    local IP_ADDR=$(get_ip_addr)
    local NET_ADDR=$(ipcalc -b ${IP_ADDR} | grep Network | awk '{print $2}')
    echo $NET_ADDR
}

is_iface_for_n2n() {
    echo $IFACES | grep -q -P "(^|,)${IF}(,|$)"
    return $?
}

is_home_network() {
    local NET_ADDR=$(get_network_addr)
    echo $HOME_NETWORKS | grep -q -P "(^|,)${NET_ADDR}(,|$)"
    return $?
}

if is_iface_for_n2n; then
    if [ "$STATUS" = "up" ]; then
        if ! is_home_network; then
            /usr/local/sbin/n2n-control start &> $LOGFILE
        fi
    elif [ "$STATUS" = "down" ]; then
        /usr/local/sbin/n2n-control stop &> $LOGFILE
    fi
fi

exit 0
