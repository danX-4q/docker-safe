#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

tdir="../../../bankledger/"

apt-get install -y "${tdir}safecode/build/packages/eosio_1.8.1-1_amd64.deb"
apt-get install -y "${tdir}safecode.cdt/build/packages/eosio.cdt_1.6.2-1_amd64.deb"
