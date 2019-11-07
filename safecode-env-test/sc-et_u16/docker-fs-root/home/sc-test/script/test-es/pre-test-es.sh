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

[[ "$INCLUDE_CUFS" != "true" ]] && {
    cd ../test-utils/
    . contracts.utils.func.sh
    cd - > /dev/null
}

[[ "$INCLUDE_SOFS" != "true" ]] && {
    cd ../test-so/
    . safe.oracle.func.sh
    cd - > /dev/null
}

##############################

TXID1=$(sh__get_txid)
so__setchainpos 5453 0
so__push1cctx "5453 0" "5454 5" \
    "safe.account ${TXID1} 0 545300.10000000 SAFE"
so__draw1asset "${TXID1} 0" safe.account
cleos__gc_balance safe.account
echo '================================='

##############################

cleos-sc system newaccount safe.account bp3abcdefg11 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1.00000000 SAFE" -p safe.account@active
cleos-sc system newaccount safe.account bp3abcdefg12 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1.00000000 SAFE" -p safe.account@active
cleos-sc system newaccount safe.account bp3abcdefg13 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1.00000000 SAFE" -p safe.account@active
cleos-sc system newaccount safe.account bp3abcdefg14 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1.00000000 SAFE" -p safe.account@active
cleos-sc system newaccount safe.account bp3abcdefg15 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1.00000000 SAFE" -p safe.account@active


cleos-sc system newaccount safe.account voter3abcd11 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1000.00000000 SAFE" -p safe.account@active
cleos-sc system newaccount safe.account voter3abcd12 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1000.00000000 SAFE" -p safe.account@active
cleos-sc system newaccount safe.account voter3abcd13 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1000.00000000 SAFE" --transfer -p safe.account@active
cleos-sc system newaccount safe.account voter3abcd14 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1000.00000000 SAFE" --transfer -p safe.account@active
cleos-sc system newaccount safe.account voter3abcd15 $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1000.00000000 SAFE" --transfer -p safe.account@active
