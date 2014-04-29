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

        unblock_ip $OPERATOR || die "Failed to block IP ($OPERATOR)"

    fi

}

unblock_ip () {

        IPTABLES=`which iptables`
        CHAIN_IP='INPUT'
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
        validate_ip $ARG
done