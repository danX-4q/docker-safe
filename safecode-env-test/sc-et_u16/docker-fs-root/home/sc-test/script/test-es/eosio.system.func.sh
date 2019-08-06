#!/bin/bash

##############################

function __parm_to_obj__txo()
{
    local txid=$1
    local outidx=$2
    local quantity=$3
    local from=$4
    local type=$5
    local tp=$6
    
    echo '{"txid":"'${txid}'","outidx":'${outidx}',"quantity":"'${quantity}'","from":"'${from}'","tp":"'${tp}'",}'
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
    cleos-sc push action eosio vtxo2prod \
        '{"txo":'${txo_obj}',"producer":'${producer}'}' \
        -p safe.oracle
    echo "eosio::vtxo2prod result: $?"

}
