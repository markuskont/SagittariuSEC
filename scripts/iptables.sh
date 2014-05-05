#!/bin/bash

die () {

    echo "Error: $1"
    exit 1

}

block_ip () {

    IPTABLES=`which iptables`
    CHAIN_IP='FORWARD'
    CHAIN_DROP='LOGDROP'
    ACTION='DROP'
    IP=$1

    validate_chain $CHAIN_IP || die "No iptables initial chain $CHAIN_IP"
    validate_chain $CHAIN_DROP || create_chain $CHAIN_DROP $CHAIN_IP || die "Failed to create $CHAIN_DROP"

    echo "Add iptables rules for $1"

    $IPTABLES -I $CHAIN_IP 1 -s $IP -j $CHAIN_DROP
    $IPTABLES -I $CHAIN_IP 2 -d $IP -j $CHAIN_DROP

}

validate_chain () {

    IPTABLES=`which iptables`
    CHAIN=$1

    $IPTABLES -n --list $CHAIN >/dev/null 2>&1

}

create_chain () {

    IPTABLES=`which iptables`
    CHAIN=$1
    FORWARD=$2

    echo "No iptables chain $CHAIN, creating new"

    $IPTABLES -N $CHAIN
    $IPTABLES -A $FORWARD -j $CHAIN
    $IPTABLES -I $CHAIN 1 -m limit --limit 2/min -j LOG --log-prefix "iptables-$CHAIN-drop: " --log-level 5
    $IPTABLES -I $CHAIN 2 -j DROP

}

for ARG in "$@"
do
        block_ip $ARG
done