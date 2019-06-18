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

so__reset 5453 0
so__show_globalkv
echo 'action: done; table: 5453 + 0'
echo '================================='

TXID1=$(get_txid)
TXID2=$(get_next_txid $TXID1)
TXID3=$(get_next_txid $TXID2)
TXID4=$(get_next_txid $TXID3)

#expr: exception
so__push2cctx "5453 0" "5454 2" \
    "danx1 ${TXID1} 0 5453.10000000 SAFE" \
    "danx2 ${TXID1} 0 5453.20000000 SAFE"
so__show_globalkv
echo 'action: same txkey exception; table: 5453 + 0'
so__show_cctx
echo "check cctx by: ${TXID1}-0"
echo '================================='

#expr: success
so__push1cctx "5453 0" "5455 0" \
    "danx1 ${TXID2} 0 5453.30000000 SAFE"
so__show_globalkv
echo 'action: done; table: 5455 + 0'
so__show_cctx
echo "check cctx by: ${TXID2}-0"
echo '================================='

#expr: exception
so__push1cctx "5455 0" "5456 0" \
    "danx1 ${TXID2} 0 5453.30000000 SAFE"
so__show_globalkv
echo 'action: repeat txid exception; table: 5455 + 0'
so__show_cctx
echo "check cctx by: ${TXID2}-0"
echo '================================='

#expr: success
so__push1cctx "5455 0" "5456 0" \
    "danx1 ${TXID2} 1 5453.30000000 SAFE"
so__show_globalkv
echo 'action: done; table: 5456 + 0'
so__show_cctx
echo "check cctx by: ${TXID2}-1"
echo '================================='

#failed
so__draw2asset "${TXID2} 0" "${TXID2} 0" danx1
echo 'action: same txkey exception'
so__show_cctx
echo "check cctx by: ${TXID2}-0"
echo '================================='

#success
so__draw2asset "${TXID2} 0" "${TXID2} 1" danx1
echo 'action: done'
so__show_cctx
echo "check cctx by: ${TXID2}-0       ${TXID2}-1"
echo '================================='

#failed
so__draw1asset "${TXID2} 1" danx1
echo 'action: repeat draw exception'
echo '================================='

#show info
so__show_cctx
show_currency_stats SAFE
show_currency_balance eosio
show_currency_balance danx1
echo '================================='
