#!/bin/bash

die () {

    echo "Error: $1"
    exit 1

}

unblock_ip () {

        IPTABLES=`which iptables`
        CHAIN_IP='FORWARD'
        CHAIN_DROP='LOGDROP'
        ACTION='DROP'
        IP=$1

        validate_chain $CHAIN_IP || die "No iptables chain $CHAIN_IP"
        validate_chain $CHAIN_DROP || die "Failed to vailidate the existence of $CHAIN_DROP"

        echo "Remove iptables rules for $1"

        $IPTABLES -D $CHAIN_IP -s $IP -j $CHAIN_DROP
        $IPTABLES -D $CHAIN_IP -d $IP -j $CHAIN_DROP

}

validate_chain () {

    IPTABLES=`which iptables`
    CHAIN=$1

    $IPTABLES -n --list $CHAIN >/dev/null 2>&1

}


for ARG in "$@"
do
        unblock_ip $ARG
done