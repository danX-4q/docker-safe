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

TXID1=$(get_txid)
TXID2=$(get_next_txid $TXID1)
TXID3=$(get_next_txid $TXID2)
TXID4=$(get_next_txid $TXID3)

#reset
so__reset 5453 0
so__show_globalkv
echo 'action: done; table: 5453 + 0'
echo '================================='

#expr: success
so__push2cctx "5453 0" "5454 2" \
    "danx1 ${TXID1} 0 5453.10000000 SAFE" \
    "danx2 ${TXID2} 1 5453.20000000 SAFE"
so__show_globalkv
echo 'action: done; table: 5454 + 2'
so__show_cctx
echo "check cctx by: ${TXID1}-0 ${TXID2}-1"
echo '================================='

#expr: success
so__push2cctx "5454 2" "5455 0" \
    "danx1 ${TXID3} 2 5453.30000000 SAFE" \
    "danx2 ${TXID4} 3 5453.40000000 SAFE"
so__show_globalkv
echo 'action: done; table: 5455 + 0'
so__show_cctx
echo "check cctx by: ${TXID3}-2 ${TXID4}-3"
echo '================================='

#failed
so__draw2asset "${TXID1} 0" "${TXID2} 1" danx1
echo 'action: permission exception'
echo '================================='

#success
so__draw1asset "${TXID1} 0" danx1
echo 'action: done'
so__show_cctx
echo "check cctx by: ${TXID1}-0 status=1"
echo '================================='

#failed
so__draw2asset "${TXID1} 0" "${TXID3} 2" danx1
echo 'action: repeat draw exception'
echo '================================='

#success
so__draw1asset "${TXID3} 2" danx1
echo 'action: done'
so__show_cctx
echo "check cctx by: ${TXID3}-2 status=1"
echo '================================='

#success
so__draw2asset "${TXID2} 1" "${TXID4} 3" danx2
echo 'action: done'
so__show_cctx
echo "check cctx by: ${TXID2}-1 ${TXID4}-3 status=1"
echo '================================='

#show info
so__show_cctx
show_currency_stats SAFE
show_currency_balance eosio
show_currency_balance danx1
show_currency_balance danx2
echo '================================='
