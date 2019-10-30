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
cd ${CONTRACTS_DIR}eosio.system/
cleos-sc set contract eosio ${PWD} -x 1000 || { echo "error when set eosio.system"; exit 1; }
