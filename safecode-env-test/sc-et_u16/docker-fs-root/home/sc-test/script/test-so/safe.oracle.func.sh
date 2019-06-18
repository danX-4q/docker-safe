#!/bin/bash

##############################

function __parm_to_obj__chainpos()
{
    block_num=$1
    tx_index=$2

    echo '{"block_num":'${block_num}',"tx_index":'${tx_index}'}'
}

function __parm_to_obj__tx()
{
    account=$1
    txid=$2
    outidx=$3
    quantity=$4
    token=$5

    echo '{"type":0,"account":"'${account}'","txid":"'${txid}'","outidx":'${outidx}',"quantity":"'${quantity}'" "'${token}'","detail":"nothing"}'
}



##############################

function so__show_globalkv()
{
    cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
}

function so__show_cctx()
{
    cleos-sc get table -r -l 5 safe.oracle global cctx
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

function get_next_txid()
{
    txid=$1
    new_txid=$(echo $txid | sha256sum | awk '{print $1}')
    echo "${new_txid}"
}

function so__push0cctx()
{
    cpos="$1"
    npos="$2"

    cpos_obj=$(__parm_to_obj__chainpos $cpos)  #do not use "$x"
    npos_obj=$(__parm_to_obj__chainpos $npos)  #do not use "$x"

    cleos-sc push action safe.oracle pushcctxes \
        '{"curpos":'${cpos_obj}',"nextpos":'${npos_obj}',"cctxes":[]}' -p safe.oracle
    echo "safe.oracle::pushcctxes result: $?"
}

#$3: "danx1 ${TXID1} 0 5453.10000000 SAFE"
function so__push2cctx()
{
    cpos="$1"
    npos="$2"
    tx1="$3"
    tx2="$4"

    cpos_obj=$(__parm_to_obj__chainpos $cpos)   #do not use "$x"
    npos_obj=$(__parm_to_obj__chainpos $npos)   #do not use "$x"
    tx1_obj=$(__parm_to_obj__tx $tx1)           #do not use "$x"
    tx2_obj=$(__parm_to_obj__tx $tx2)           #do not use "$x"

    cleos-sc push action safe.oracle pushcctxes \
        "{'curpos':${cpos_obj},'nextpos':${npos_obj},'cctxes':[${tx1_obj},${tx2_obj}]}" -p safe.oracle
    echo "safe.oracle::pushcctxes result: $?"
}
