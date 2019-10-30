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

TXID1=$(sh__get_txid)
#TXID2=$(sh__get_next_txid $TXID1)
#TXID3=$(sh__get_next_txid $TXID2)
#TXID4=$(sh__get_next_txid $TXID3)

#vtxo2prod
es__vtxo2prod "${TXID1} 0 5453 XbtvuNFJ6LjKfWYxENK8FYbGPpST7unLXH 0 2019-08-06T14:38:52" \
    "dan3prod"

#show info
#so__show_cctx
#show_currency_stats SAFE
#show_currency_balance eosio
#echo '================================='
