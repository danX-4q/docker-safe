#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

tdir="../../../bankledger/"

apt-get install -y "${tdir}eos/build/packages/eosio_1.6.0-1_amd64.deb"
apt-get install -y "${tdir}eosio.cdt/build/packages/eosio.cdt-1.4.1.x86_64.deb"
