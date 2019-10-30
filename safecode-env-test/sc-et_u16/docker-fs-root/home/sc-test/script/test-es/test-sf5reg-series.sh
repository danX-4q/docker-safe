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
#TXID2=$(sh__get_next_txid $TXID1)
#TXID3=$(sh__get_next_txid $TXID2)
#TXID4=$(sh__get_next_txid $TXID3)

ATOMID=0
es__sf5regprod "$ATOMID 1 1" "$TXID1 0" "$K11_PUB 5"

#show info
es__gt_global4vote
es__gt_sf5producers
echo '================================='

PUBKEY_HASH=$(es__scpubkeyhash_value $K11_PUB)
PUBKEY_SIG=$(curl__sign_digest $PUBKEY_HASH $K11_PUB | cut -d'"' -f 2)
es__regproducer2 "$TXID1 0" "bp3abcdefg11" "${PUBKEY_SIG}"
