#!/bin/bash

##############################

function __parm_to_obj__chainpos()
{
    local block_num=$1
    local tx_index=$2

    echo '{"block_num":'${block_num}',"tx_index":'${tx_index}'}'
}

function __parm_to_obj__tx()
{
    local account=$1
    local txid=$2
    local outidx=$3
    local quantity=$4
    local token=$5
    
    local asset="$4 $5"
    echo '{"type":0,"account":"'${account}'","txid":"'${txid}'","outidx":'${outidx}',"quantity":"'${asset}'","detail":"nothing"}'
}

function __parm_to_obj__txkey()
{
    local txid=$1
    local outidx=$2

    echo '["'${txid}'",'${outidx}']'
}

##############################

function get_txid()
{
    local txid=$(date | sha256sum | awk '{print $1}')
    echo "${txid}"
}

function get_next_txid()
{
    local txid=$1
    local new_txid=$(echo $txid | sha256sum | awk '{print $1}')
    echo "${new_txid}"
}

##############################

function show_currency_stats()
{
    local token=$1
    cleos-sc get currency stats eosio.token $token
}

function show_currency_balance()
{
    local account=$1
    cleos-sc get currency balance eosio.token $account
}

function so__show_globalkv()
{
    cleos-sc get table -r -l 1 safe.oracle safe.oracle globalkv
}

function so__show_cctx()
{
    cleos-sc get table -r -l 5 safe.oracle global cctx
}

##############################

function so__setchainpos()
{
    local block_num=$1
    local tx_index=$2

    cleos-sc push action safe.oracle setchainpos "[[${block_num},${tx_index}]]" -p safe.oracle
    echo "safe.oracle::setchainpos result: $?"
}

function so__push0cctx()
{
    local cpos="$1"
    local npos="$2"

    local cpos_obj=$(__parm_to_obj__chainpos $cpos)  #do not use "$x"
    local npos_obj=$(__parm_to_obj__chainpos $npos)  #do not use "$x"

    cleos-sc push action safe.oracle pushcctxes \
        '{"curpos":'${cpos_obj}',"nextpos":'${npos_obj}',"cctxes":[]}' -p safe.oracle
    echo "safe.oracle::pushcctxes result: $?"
}

function so__push1cctx()
{
    local cpos="$1"
    local npos="$2"
    local tx1="$3"

    local cpos_obj=$(__parm_to_obj__chainpos $cpos) #do not use "$x"
    local npos_obj=$(__parm_to_obj__chainpos $npos) #do not use "$x"
    local tx1_obj=$(__parm_to_obj__tx $tx1)         #do not use "$x"

    #do use "${tx1_obj}"!!!
    cleos-sc push action safe.oracle pushcctxes \
        '{"curpos":'${cpos_obj}',"nextpos":'${npos_obj}',"cctxes":['"${tx1_obj}"']}' \
        -p safe.oracle
    echo "safe.oracle::pushcctxes result: $?"
}

function so__push2cctx()
{
    local cpos="$1"
    local npos="$2"
    local tx1="$3"      #caller use: "danx1 ${TXID1} 0 5453.10000000 SAFE"
    local tx2="$4"      #caller use: "danx1 ${TXID1} 0 5453.10000000 SAFE"

    local cpos_obj=$(__parm_to_obj__chainpos $cpos) #do not use "$x"
    local npos_obj=$(__parm_to_obj__chainpos $npos) #do not use "$x"
    local tx1_obj=$(__parm_to_obj__tx $tx1)         #do not use "$x"
    local tx2_obj=$(__parm_to_obj__tx $tx2)         #do not use "$x"

    #do use "${tx1_obj}" and "${tx2_obj}"!!!
    cleos-sc push action safe.oracle pushcctxes \
        '{"curpos":'${cpos_obj}',"nextpos":'${npos_obj}',"cctxes":['"${tx1_obj}"','"${tx2_obj}"']}' \
        -p safe.oracle
    echo "safe.oracle::pushcctxes result: $?"
}

function so__draw1asset()
{
    local txk1="$1"
    local account="$2"
    local txk1_obj=$(__parm_to_obj__txkey $txk1)    #do not use "$x"

    cleos-sc push action safe.oracle drawassets \
        '[['${txk1_obj}']]' -p ${account}
}

function so__draw2asset()
{
    local txk1="$1"
    local txk2="$2"
    local account="$3"
    local txk1_obj=$(__parm_to_obj__txkey $txk1)    #do not use "$x"
    local txk2_obj=$(__parm_to_obj__txkey $txk2)    #do not use "$x"

    cleos-sc push action safe.oracle drawassets \
        '[['${txk1_obj}','${txk2_obj}']]' -p ${account}
}
