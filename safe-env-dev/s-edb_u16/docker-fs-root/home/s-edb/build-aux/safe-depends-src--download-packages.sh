#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################

#apt-get install -y curl librsvg2-bin libtiff-tools bsdmainutils cmake imagemagick libcap-dev libz-dev libbz2-dev python-setuptools &&

cd /home/bankledger/safe/depends && {
    make download || make download || make download || make download
}

echo -e 'please check download files at /home/bankledger/safe/depends/sources/'
