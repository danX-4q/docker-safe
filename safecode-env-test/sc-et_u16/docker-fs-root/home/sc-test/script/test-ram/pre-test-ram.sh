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
cleos-sc push action eosio.token issue '[ "eosio", "4000000.00000000 SAFE", "memo" ]' -p eosio@active

##########
cleos-sc system newaccount eosio testramprice $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram "1.00000000 SAFE" -p eosio@active
#cleos-sc system newaccount eosio testramprice $K0_PUB --stake-net "10000.00000000 SAFE" --stake-cpu "10000.00000000 SAFE" --buy-ram-kbytes 1500000 -p eosio@active
cleos-sc transfer eosio testramprice "3500000.00000000 SAFE" "memo" -p eosio@active
