#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.env
cd -

##########

BLKNUM=$2
TXINDEX=$3

cleos-sc push action safe.oracle reset "[[${BLKNUM},${TXINDEX}]]" -p safe.oracle
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv

