#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.env
cd -

##########
#TXID=$(date | sha256sum | awk '{print $1}')

cleos-sc push action safe.oracle rstchainpos '[]' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5453 + 0'
echo '================================='

#exp: success
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":0},"nextpos":{"block_num":5454,"tx_index":0},"cctxes":[]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5454 + 0'
echo '================================='


#expr: success
TXID1=$(date | sha256sum | awk '{print $1}')
TXID2=$(echo $TXID1 | sha256sum | awk '{print $1}')
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5454,"tx_index":0},"nextpos":{"block_num":5454,"tx_index":2},"cctxes":[{"type":0,"account":"danx","txid":"'${TXID1}'","outidx":0,"quantity":"5453.10000000 SAFE","detail":"nothing"},{"type":0,"account":"danx","txid":"'${TXID2}'","outidx":1,"quantity":"5453.20000000 SAFE","detail":"nothing"}]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5454 + 2'
cleos-sc get table -r -l 5 safe.oracle global cctx
echo "${TXID1}-0 ${TXID2}-1"
echo '================================='


cleos-sc get currency stats eosio.token SAFE
cleos-sc get currency balance eosio.token eosio
cleos-sc get currency balance eosio.token danx
echo '================================='

