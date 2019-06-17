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

#exp: failed
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":0},"nextpos":{"block_num":5453,"tx_index":0},"cctxes":[]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: exception; table: 5453 + 0'
echo '================================='

#exp: success
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":0},"nextpos":{"block_num":5453,"tx_index":1},"cctxes":[]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5453 + 1'
echo '================================='

#exp: failed
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":0},"nextpos":{"block_num":5453,"tx_index":2},"cctxes":[]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: exception; table: 5453 + 1'
echo '================================='

#exp: success
cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":5453,"tx_index":1},"nextpos":{"block_num":5453,"tx_index":3},"cctxes":[]}' -p safe.oracle
echo "action result: $?"
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
echo 'action: done; table: 5453 + 3'
echo '================================='

