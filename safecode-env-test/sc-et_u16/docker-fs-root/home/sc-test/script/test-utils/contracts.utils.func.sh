#!/bin/bash

export INCLUDE_CUFS="true"

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

function curl__sign_digest()
{
    local digest=$1
    local pubkey=$2

    curl --request POST \
      --url http://127.0.0.1:${KEOSD_PORT}/v1/wallet/sign_digest \
      --header 'content-type: application/json' \
      -d '["'${digest}'","'${pubkey}'"]'
}

##############################

function cleos__gc_stats()
{
    local token=$1
    cleos-sc get currency stats eosio.token $token
}

function cleos__gc_balance()
{
    local account=$1
    cleos-sc get currency balance eosio.token $account
}
