#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################

#usage:
#    $1: node name, which will be used to get node config 
#        at dir ../node/$1/eosio.conf(or eosio.env)

set -x

NM=${1-"a"}
N_C_DIR="../node/${NM}/"

cd $N_C_DIR
. eosio.env
cd -

. eosio.system.func.sh

##############################

TXID1="61f26590407dfe55dbcaea8a43b0dc6a322bbd9efef270c78480b0387a11e271"
#TXID1=$(sh__get_txid)
TXID2=$(sh__get_next_txid $TXID1)
TXID3=$(sh__get_next_txid $TXID2)
TXID4=$(sh__get_next_txid $TXID3)
ATOMID=0

function __es__func_regprods()
{
    es__sf5regprod "$ATOMID 1 1" "$TXID1 0" "$K11_PUB 1 3386"

    #show info
    es__gt_global4vote
    es__gt_sf5producers
    echo '================================='

    PUBKEY_HASH=$(es__scpubkeyhash_value $K11_PUB)
    PUBKEY_SIG=$(curl__sign_digest $PUBKEY_HASH $K11_PUB | cut -d'"' -f 2)
    es__regproducer2 "$TXID1 0" "bp3abcdefg11" "${PUBKEY_SIG}"
    #show info
    es__gt_sf5producers
    echo '================================='
}
__es__func_regprods

function case_001()
{
    es__sc5vote voter3abcd13 bp3abcdefg11
    es__gt_voters
    es__gt_sc5voters

}
case_001


