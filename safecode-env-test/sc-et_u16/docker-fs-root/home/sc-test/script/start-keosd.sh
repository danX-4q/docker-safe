#!/bin/bash

set -x

NM=${1-"a"}
CUR_PWD="$PWD"

cd $NM
. eosio.conf
cd -

keosd -c ${KEOSD_DIR}config/config.ini -d ${KEOSD_DIR}data/ &

