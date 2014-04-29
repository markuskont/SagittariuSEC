#!/bin/bash

die () {

    echo "Error: $1"
    exit 1

}

validate_ip () {

    OPERATOR=$1
    REGEX='^([0-9]{1,3}\.){3}[0-9]{1,3}$';

    if ! [[ $OPERATOR =~ $REGEX ]]
    then

        echo 'Input does not conform to IPv4 address standard'

    else

        block_ip $OPERATOR || die "Failed to block IP ($OPERATOR)"

    fi

}

block_ip () {

    IPTABLES=`which iptables`
    CHAIN_IP='INPUT'
    CHAIN_DROP='LOGDROP'
    ACTION='DROP'
    IP=$1

    validate_chain $CHAIN_IP || die "No iptables chain $CHAIN_IP"
    validate_chain $CHAIN_DROP || create_chain $CHAIN_DROP || die "Failed to create $CHAIN_DROP"

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
        validate_ip $ARG
done