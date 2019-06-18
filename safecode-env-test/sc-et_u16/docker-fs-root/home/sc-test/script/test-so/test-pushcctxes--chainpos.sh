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

. safe.oracle.func.sh

##############################

so__reset 5453 0
so__show_globalkv
echo 'action: done; table: 5453 + 0'
echo '================================='

#exp: failed
so__push0cctx "5453 0" "5453 0"
so__show_globalkv
echo 'action: exception; table: 5453 + 0'
echo '================================='

#exp: success
so__push0cctx "5453 0" "5453 1"
so__show_globalkv
echo 'action: done; table: 5453 + 1'
echo '================================='

#exp: failed
so__push0cctx "5453 0" "5453 2"
so__show_globalkv
echo 'action: exception; table: 5453 + 1'
echo '================================='

#exp: success
so__push0cctx "5453 1" "5453 3"
so__show_globalkv
echo 'action: done; table: 5453 + 3'
echo '================================='
