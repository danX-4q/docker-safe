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

. safe.oracle.func.sh

##############################

TXID1=$(sh__get_txid)
TXID2=$(sh__get_next_txid $TXID1)

#reset
so__setchainpos 5453 0
so__show_globalkv
echo 'action: done; table: 5453 + 0'
echo '================================='

#exp: success
so__push0cctx "5453 0" "5454 0"
so__show_globalkv
echo 'action: done; table: 5454 + 0'
echo '================================='

#expr: success
so__push2cctx "5454 0" "5454 2" \
    "danx ${TXID1} 0 5453.10000000 SAFE" \
    "danx ${TXID2} 1 5453.20000000 SAFE"
so__show_globalkv
echo 'action: done; table: 5454 + 2'
so__show_cctx
echo "check cctx by: ${TXID1}-0 ${TXID2}-1"
echo '================================='

#show info
cleos__gc_stats SAFE
cleos__gc_balance eosio
cleos__gc_balance danx
echo '================================='
