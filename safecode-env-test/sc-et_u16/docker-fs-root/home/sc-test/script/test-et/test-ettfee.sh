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

. eosio.token.func.sh

##############################


#show info
cleos__gc_stats SAFE
cleos__gc_balance eosio
echo '================================='

cleos-sc transfer eosio danx "1.00000000 SAFE"

cleos__gc_stats SAFE
cleos__gc_balance eosio
cleos__gc_balance danx
cleos__gc_balance safe.ettfee
echo '================================='
