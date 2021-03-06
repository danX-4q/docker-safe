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

cleos-sc create account eosio eosio.bpay $K0_PUB
cleos-sc create account eosio eosio.msig $K0_PUB
cleos-sc create account eosio eosio.names $K0_PUB
cleos-sc create account eosio eosio.ram $K0_PUB
cleos-sc create account eosio eosio.ramfee $K0_PUB
cleos-sc create account eosio eosio.saving $K0_PUB
cleos-sc create account eosio eosio.stake $K0_PUB
cleos-sc create account eosio eosio.vpay $K0_PUB
cleos-sc create account eosio eosio.rex $K0_PUB

##############################

cleos-sc create account eosio safe.ssm $K0_PUB
cleos-sc create account eosio safe.account $K0_PUB

##############################

CONTRACTS_DIR="${PWD}/../../../bankledger/safecode.contracts/build/contracts/"

##########
cd ${CONTRACTS_DIR}eosio.msig/
cleos-sc set contract eosio.msig ${PWD} || { echo "error when set eosio.msig"; exit 1; }

##########
cd ${CONTRACTS_DIR}eosio.system/
cleos-sc set contract eosio ${PWD} -x 1000 || { echo "error when set eosio.system"; exit 1; }

##########
cleos-sc push action eosio init '[0, "8,SAFE"]' -p eosio@active
cleos-sc push action eosio setpriv '["eosio.msig", 1]' -p eosio@active
