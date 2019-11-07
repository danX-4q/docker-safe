#!/bin/bash

[[ "$INCLUDE_CUFS" != "true" ]] && {
    cd ../test-utils/
    . contracts.utils.func.sh
    cd - > /dev/null
}

export INCLUDE_ESFS="true"

##############################

function es__gt_global4vote()
{
    cleos-sc get table eosio eosio global4vote
}

function es__gt_sf5producers()
{
    cleos-sc get table eosio eosio sf5producers
}

function es__gt_voters()
{
    cleos-sc get table eosio eosio voters
}

function es__gt_sc5voters()
{
    cleos-sc get table eosio eosio sc5voters
}

##############################

function __es__parm_to_obj__sf5key()
{
    local atom_id=$1
    local next_block_num=$2
    local next_tx_index=$3
    
    echo '{"atom_id":'${atom_id}',"next_block_num":'${next_block_num}',"next_tx_index":'${next_tx_index}'}'
}

function __es__parm_to_obj__txokey()
{
    local txid=$1
    local outidx=$2

    echo '{"txid":"'${txid}'","outidx":'${outidx}'}'
}

function __es__parm_to_obj__sfreginfo()
{
    local sc_pubkey=$1
    local dvdratio=$2
    local location=$3

    echo '{"sc_pubkey":"'${sc_pubkey}'","dvdratio":'${dvdratio}',"location":'${location}'}'
}

function __es__parm_to_obj__sfupdinfo()
{
    local has__dvdratio=$1
    local dvdratio=$2
    local has__location=$3
    local location=$4

    echo '{"has__dvdratio":"'${has__dvdratio}'","dvdratio":'${dvdratio}',"has__location":"'${has__location}'","location":'${location}'}'
}

function __es__parm_to_obj__txo()
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

function es__sf5regprod()
{
    local sfkey="$1"
    local rptxokey="$2"
    local ri="$3"
    local caller="safe.ssm"

    local sf5key_obj=$(__es__parm_to_obj__sf5key $sfkey)
    local txokey_obj=$(__es__parm_to_obj__txokey $rptxokey)
    local sfreginfo_obj=$(__es__parm_to_obj__sfreginfo $ri)

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

function es__scpubkeyhash()
{
    local pubkey=$1
    local caller=eosio

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio sf5pubkhash \
        '["'${pubkey}'"]' -j -p ${caller})

    echo "eosio::sf5pubkhash by ${caller} result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::sf5pubkhash output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}

function es__scpubkeyhash_value()
{
    local pubkey=$1
    local caller=eosio

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio scpubkeyhash \
        '["'${pubkey}'"]' -j -p ${caller})

    [[ "$json" != "" ]] && {
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e |
        grep 'eosio.system::scpubkeyhash>' | cut -d'>' -f2
    }
}

function es__regproducer2()
{
    local rptxokey="$1"
    local account="$2"
    local newsig="$3"
    local caller=$account

    local txokey_obj=$(__es__parm_to_obj__txokey $rptxokey)

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio regproducer2 \
        '{"rptxokey":'${txokey_obj}',"account":"'${account}'","newsig":"'${newsig}'"}' \
        -j -p ${caller})

    echo "eosio::regproducer2 by ${caller} result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::regproducer2 output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}

function es__sf5unregprod()
{
    local sfkey="$1"
    local rptxokey="$2"
    local caller="safe.ssm"

    local sf5key_obj=$(__es__parm_to_obj__sf5key $sfkey)
    local txokey_obj=$(__es__parm_to_obj__txokey $rptxokey)

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio sf5unregprod \
        '{"sfkey":'${sf5key_obj}',"rptxokey":'${txokey_obj}'}' \
        -j -p ${caller})

    echo "eosio::sf5unregprod by ${caller} result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::sf5unregprod output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}

function es__sf5updprodri()
{
    local sfkey="$1"
    local rptxokey="$2"
    local updri="$3"
    local caller="safe.ssm"

    local sf5key_obj=$(__es__parm_to_obj__sf5key $sfkey)
    local txokey_obj=$(__es__parm_to_obj__txokey $rptxokey)
    local sfupdinfo_obj=$(__es__parm_to_obj__sfupdinfo $updri)

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio sf5updprodri \
        '{"sfkey":'${sf5key_obj}',"rptxokey":'${txokey_obj}',"updri":'${sfupdinfo_obj}'}' \
        -j -p ${caller})

    echo "eosio::sf5updprodri by ${caller} result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::sf5updprodri output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}

function es__sc5vote()
{
    local voter="$1"
    local producer="$2"
    local caller=$voter

    #do use "${xxx_obj}"!!!
    local json=$(cleos-sc -v push action eosio sc5vote \
        '{"voter":"'${voter}'","producer":"'${producer}'"}' \
        -j -p ${caller})

    echo "eosio::sc5vote by ${caller} result: $?"
    [[ "$json" != "" ]] && {
        echo "eosio::sc5vote output: "
        echo $json | jq '.["processed"]["action_traces"][0]["console"]' | xargs echo -e
    }
}
