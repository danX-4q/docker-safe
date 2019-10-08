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
    
    echo '{"txid":"'${txid}'","outidx":'${outidx}',"quantity":"'${quantity}'","from":["'${from}'"],"tp":"'${tp}'","type":'$type'}'
}

##############################


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

