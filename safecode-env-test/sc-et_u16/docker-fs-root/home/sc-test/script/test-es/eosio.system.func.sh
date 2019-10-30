#!/bin/bash

##############################

function __parm_to_obj__sf5key()
{
    local atom_id=$1
    local next_block_num=$2
    local next_tx_index=$3
    
    echo '{"atom_id":'${atom_id}',"next_block_num":'${next_block_num}',"next_tx_index":'${next_tx_index}'}'
}

function __parm_to_obj__txokey()
{
    local txid=$1
    local outidx=$2

    echo '{"txid":"'${txid}'","outidx":'${outidx}'}'
}

function __parm_to_obj__sfreginfo()
{
    local sc_pubkey=$1
    local dvdratio=$2

    echo '{"sc_pubkey":"'${sc_pubkey}'","dvdratio":'${dvdratio}'}'
}


function __parm_to_obj__txo()
{
    local txid=$1
    local outidx=$2
    local quantity=$3
    local from=$4
    local type=$5
    local tp=$6
    
    echo '{"txid":"'${txid}'","outidx":'${outidx}',"quantity":"'${quantity}'","from":["'${from}'"],"tp":"'${tp}'","type":'$type'}'
}

##############################

function sh__get_txid()
{
    local txid=$(date | sha256sum | awk '{print $1}')
    echo "${txid}"
}

function sh__get_next_txid()
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

##############################

function es__vtxo2prod()
{
    local txo="$1"
    local producer="$2"

    local txo_obj=$(__parm_to_obj__txo $txo)

    #do use "${txo_obj}"!!!
    local json=$(cleos-sc -v push action eosio vtxo2prod \
        '{"txo":'${txo_obj}',"producer":'${producer}'}' \
        -j -p safe.oracle)
    echo "eosio::vtxo2prod result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::vtxo2prod output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}

function es__sf5regprod()
{
    local sfkey="$1"
    local rptxokey="$2"
    local ri="$3"
    local caller="$4"

    local sf5key_obj=$(__parm_to_obj__sf5key $sfkey)
    local txokey_obj=$(__parm_to_obj__txokey $rptxokey)
    local sfreginfo_obj=$(__parm_to_obj__sfreginfo $ri)

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio sf5regprod \
        '{"sfkey":'${sf5key_obj}',"rptxokey":'${txokey_obj}',"ri":'${sfreginfo_obj}'}' \
        -j -p ${caller})

    echo "eosio::sf5regprod by ${caller} result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::sf5regprod output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}
