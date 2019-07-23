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
cd ${CONTRACTS_DIR}eosio.bios/
cleos-sc set contract eosio ${PWD} || { echo "error when set eosio.bios"; exit 1; }

##########
cleos-sc create account eosio eosio.token $K0_PUB
cd ${CONTRACTS_DIR}eosio.token/
cleos-sc set contract eosio.token ${PWD} || { echo "error when set eosio.token"; exit 1; }
cleos-sc push action eosio.token create '["eosio","4500000.00000000 SAFE"]' -p eosio.token@active

##########
cleos-sc create account eosio safe.oracle $K0_PUB
cd ${CONTRACTS_DIR}safe.oracle/
cleos-sc set contract safe.oracle ${PWD} || { echo "error when set safe.oracle"; exit 1; }

##########
cleos-sc create account eosio danx $K0_PUB
cleos-sc create account eosio danx1 $K0_PUB
cleos-sc create account eosio danx2 $K0_PUB

