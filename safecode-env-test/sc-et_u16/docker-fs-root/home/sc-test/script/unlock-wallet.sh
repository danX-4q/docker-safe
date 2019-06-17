#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.env
cd -

##########

cleos-sc wallet unlock --password $(cat ${KEOSD_DIR}data/default.wltpwd)
