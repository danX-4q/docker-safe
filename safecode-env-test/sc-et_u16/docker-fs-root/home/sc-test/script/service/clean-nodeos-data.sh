#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.conf
cd -

./stop-nodeos.sh
rm -rf ${NODEOS_DIR}data/*
