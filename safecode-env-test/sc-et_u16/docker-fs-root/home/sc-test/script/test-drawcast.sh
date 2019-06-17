#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.env
cd -

##########

cleos-sc push action safe.oracle rstchainpos '[]' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5453 + 0'
echo '================================='

#expr: success
TXID1=$(date | sha256sum | awk '{print $1}')
TXID2=$(echo $TXID1 | sha256sum | awk '{print $1}')
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":0},"nextpos":{"block_num":5454,"tx_index":2},"cctxes":[{"type":0,"account":"danx1","txid":"'${TXID1}'","outidx":0,"quantity":"5453.10000000 SAFE","detail":"nothing"},{"type":0,"account":"danx2","txid":"'${TXID2}'","outidx":1,"quantity":"5453.20000000 SAFE","detail":"nothing"}]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5454 + 2'
cleos-sc get table -r -l 5 safe.oracle global cctx
echo "${TXID1}-0 ${TXID2}-1"
echo '================================='


TXID3=$(echo $TXID2 | sha256sum | awk '{print $1}')
TXID4=$(echo $TXID3 | sha256sum | awk '{print $1}')
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5454,"tx_index":2},"nextpos":{"block_num":5455,"tx_index":0},"cctxes":[{"type":0,"account":"danx1","txid":"'${TXID3}'","outidx":2,"quantity":"5453.30000000 SAFE","detail":"nothing"},{"type":0,"account":"danx2","txid":"'${TXID4}'","outidx":3,"quantity":"5453.40000000 SAFE","detail":"nothing"}]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5455 + 0'
cleos-sc get table -r -l 5 safe.oracle global cctx
echo "${TXID3}-2 ${TXID4}-3"
echo '================================='


#failed
cleos-sc push action safe.oracle drawassets '[[["'${TXID1}'",0],["'${TXID2}'",1]]]' -p danx1
cleos-sc get table -r -l 5 safe.oracle global cctx
cleos-sc get currency stats eosio.token SAFE
cleos-sc get currency balance eosio.token eosio
cleos-sc get currency balance eosio.token danx1
cleos-sc get currency balance eosio.token danx2
echo '================================='

#success
cleos-sc push action safe.oracle drawassets '[[["'${TXID1}'",0]]]' -p danx1
#failed
cleos-sc push action safe.oracle drawassets '[[["'${TXID1}'",0],["'${TXID3}'",2]]]' -p danx1
#success
cleos-sc push action safe.oracle drawassets '[[["'${TXID3}'",2]]]' -p danx1
#success
cleos-sc push action safe.oracle drawassets '[[["'${TXID2}'",1],["'${TXID4}'",3]]]' -p danx2
#show info
cleos-sc get table -r -l 5 safe.oracle global cctx
cleos-sc get currency stats eosio.token SAFE
cleos-sc get currency balance eosio.token eosio
cleos-sc get currency balance eosio.token danx1
cleos-sc get currency balance eosio.token danx2
echo '================================='

