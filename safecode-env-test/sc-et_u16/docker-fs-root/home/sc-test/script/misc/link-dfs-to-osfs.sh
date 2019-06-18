#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

cd ../../../bankledger
#now change dir to .../docker-fs-root/home/bankledger

function link_dir()
{
    tdir=$1
    [ -e "$tdir" ] && { echo "error: ${PWD}/${tdir} has exists, please check it."; exit 1; }
    ln -s "/home/bankledger/${tdir}"
}

link_dir eos/
link_dir eosio.cdt/
link_dir eosio.contracts/
