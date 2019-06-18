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

#expr: exception
TXID1=$(get_txid)

so__push2cctx "5453 0" "5454 2" \
    "danx1 ${TXID1} 0 5453.10000000 SAFE" \
    "danx2 ${TXID1} 0 5453.20000000 SAFE"
so__show_globalkv

echo 'action: same txkey exception; table: 5453 + 0'
so__show_cctx
#echo "${TXID1}-0"
echo '================================='
exit 0
#expr: success
TXID2=$(get_next_txid $TXID1)
TXID3=$(get_next_txid $TXID2)
TXID4=$(get_next_txid $TXID3)

cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":0},"nextpos":{"block_num":5455,"tx_index":0},"cctxes":[{"type":0,"account":"danx1","txid":"'${TXID2}'","outidx":0,"quantity":"5453.30000000 SAFE","detail":"nothing"}]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5455 + 0'
cleos-sc get table -r -l 5 safe.oracle global cctx
echo "${TXID2}-0"
echo '================================='


#expr: failed
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5455,"tx_index":0},"nextpos":{"block_num":5456,"tx_index":0},"cctxes":[{"type":0,"account":"danx1","txid":"'${TXID2}'","outidx":0,"quantity":"5453.30000000 SAFE","detail":"nothing"}]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: exception; table: 5455 + 0'
cleos-sc get table -r -l 5 safe.oracle global cctx
echo "${TXID2}-0"
echo '================================='


#expr: success
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5455,"tx_index":0},"nextpos":{"block_num":5456,"tx_index":0},"cctxes":[{"type":0,"account":"danx1","txid":"'${TXID2}'","outidx":1,"quantity":"5453.30000000 SAFE","detail":"nothing"}]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5456 + 0'
cleos-sc get table -r -l 5 safe.oracle global cctx
echo "${TXID2}-1"
echo '================================='

#failed
cleos-sc push action safe.oracle drawassets '[[["'${TXID2}'",0],["'${TXID2}'",0]]]' -p danx1
cleos-sc get table -r -l 5 safe.oracle global cctx
echo '================================='

#success
cleos-sc push action safe.oracle drawassets '[[["'${TXID2}'",0],["'${TXID2}'",1]]]' -p danx1
cleos-sc get table -r -l 5 safe.oracle global cctx
echo '================================='

#failed
cleos-sc push action safe.oracle drawassets '[[["'${TXID2}'",1]]]' -p danx1

#show info
cleos-sc get table -r -l 5 safe.oracle global cctx
cleos-sc get currency stats eosio.token SAFE
cleos-sc get currency balance eosio.token eosio
cleos-sc get currency balance eosio.token danx1
echo '================================='

