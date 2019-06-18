#!/bin/bash

set -x

NM=${3-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.env
cd -

##########

BLKNUM=$1
TXINDEX=$2

cleos-sc push action safe.oracle reset "[[${BLKNUM},${TXINDEX}]]" -p safe.oracle
cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv

