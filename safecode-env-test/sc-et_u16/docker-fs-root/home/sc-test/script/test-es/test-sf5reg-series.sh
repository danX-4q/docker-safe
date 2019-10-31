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

TXID1="43e65f077ec87e621e2e093667c45787e3a1f2936a358ec4f934febbc05aeee5"
#TXID1=$(sh__get_txid)
TXID2=$(sh__get_next_txid $TXID1)
TXID3=$(sh__get_next_txid $TXID2)
TXID4=$(sh__get_next_txid $TXID3)
ATOMID=0

function case_001()
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
case_001

function case_002()
{
    ((ATOMID+=1))
    es__sf5regprod "$ATOMID 1 1" "$TXID2 0" "$K12_PUB 2 3386"

    #show info
    es__gt_global4vote
    es__gt_sf5producers
    echo "success"
    echo '================================='

    ((ATOMID+=1))
    es__sf5unregprod "$ATOMID 1 1" "$TXID2 0"
    es__gt_sf5producers
    echo "success, enable=false"
    echo '================================='

    PUBKEY_HASH=$(es__scpubkeyhash_value $K12_PUB)
    PUBKEY_SIG=$(curl__sign_digest $PUBKEY_HASH $K12_PUB | cut -d'"' -f 2)
    es__regproducer2 "$TXID2 0" "bp3abcdefg12" "${PUBKEY_SIG}"
    es__gt_sf5producers
    echo "success: regproducer ok but enable=false"
    echo '================================='
}
case_002

function case_003()
{
    ((ATOMID+=1))
    es__sf5updprodri "$ATOMID 1 1" "$TXID2 0" "1 20 1 33860"

    #show info
    es__gt_global4vote
    es__gt_sf5producers
    echo "success"
    echo '================================='
}
case_003
