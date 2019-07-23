#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################

#usage:
#    $1: node name, which will be used to get node config 
#        at dir ../node/$1/eosio.conf(or eosio.env)

set -x

NM=${1-"a"}
N_C_DIR="../node/${NM}/"

cd $N_C_DIR
. eosio.env
cd -

##############################

CONTRACTS_DIR="${PWD}/../../../bankledger/safecode.contracts/build/contracts/"

##########
cd ${CONTRACTS_DIR}eosio.token/
cleos-sc set contract eosio.token ${PWD} eosio.token.wasm eosio.token.abi || { echo "error when set eosio.token"; exit 1; }

##########
cd ${CONTRACTS_DIR}safe.oracle/
cleos-sc set contract safe.oracle ${PWD} || { echo "error when set safe.oracle"; exit 1; }

##########
#cleos-sc set account permission eosio.token active \
#    '{"threshold": 1,"keys": [{"key":"'$K0_PUB'", "weight":1}],"accounts": [{"permission":{"actor":"safe.oracle","permission":"eosio.code"},"weight":1}]}'  owner -p eosio.token

#cleos-sc set account permission eosio active \
#    '{"threshold": 1,"keys": [{"key":"'$K0_PUB'", "weight":1}],"accounts": [{"permission":{"actor":"safe.oracle","permission":"eosio.code"},"weight":1}]}'  owner -p eosio

cleos-sc set account permission eosio.token crosschain \
    '{"threshold": 1,"keys": [],"accounts": [{"permission":{"actor":"safe.oracle","permission":"eosio.code"},"weight":1}]}' active -p eosio.token

cleos-sc set account permission eosio crosschain \
    '{"threshold": 1,"keys": [],"accounts": [{"permission":{"actor":"safe.oracle","permission":"eosio.code"},"weight":1}]}' active -p eosio

cleos-sc set action permission eosio.token eosio.token castcreate crosschain -p eosio.token@active
cleos-sc set action permission eosio eosio.token castissue crosschain -p eosio@active
cleos-sc set action permission eosio eosio.token casttransfer crosschain -p eosio@active
