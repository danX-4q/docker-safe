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
. eosio.conf
cd -

##############################

nodeos -c ${NODEOS_C_DIR}config.ini -d ${NODEOS_D_DIR} --genesis-json ${NODEOS_C_DIR}genesis.json
