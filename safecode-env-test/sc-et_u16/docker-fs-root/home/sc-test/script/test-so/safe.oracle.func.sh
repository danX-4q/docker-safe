#!/bin/bash

function so__show_globalkv()
{
    cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
}

function so__reset()
{
    block_num=$1
    tx_index=$2

    cleos-sc push action safe.oracle reset "[[${block_num},${tx_index}]]" -p safe.oracle
    echo "safe.oracle::reset result: $?"
}

function get_txid()
{
    txid=$(date | sha256sum | awk '{print $1}')
    echo "${txid}"
}

function so__push0cctx()
{
    cur_block_num=$1
    cur_tx_index=$2
    next_block_num=$3
    next_tx_index=$4

    cleos-sc push action safe.oracle pushcctxes '{"curpos":{"block_num":'${cur_block_num}',"tx_index":'${cur_tx_index}'},"nextpos":{"block_num":'${next_block_num}',"tx_index":'${next_tx_index}'},"cctxes":[]}' -p safe.oracle
    echo "safe.oracle::pushcctxes result: $?"
}
