#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.conf
cd -

nodeos -c ${NODEOS_DIR}config/config.ini -d ${NODEOS_DIR}data --genesis-json ${NODEOS_DIR}config/genesis.json
