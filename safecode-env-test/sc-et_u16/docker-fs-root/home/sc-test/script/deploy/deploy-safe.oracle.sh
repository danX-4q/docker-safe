#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.env
cd -

##########
cd ${CONTRACTS_DIR}sc.eosio.token/
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
