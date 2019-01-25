#!/bin/bash

EOS_VER="v1.6.0"
rm -rf eos-$EOS_VER eos-$EOS_VER.zip
git clone -b $EOS_VER --single-branch https://github.com/EOSIO/eos.git --recursive eos-$EOS_VER
zip -r eos-$EOS_VER.zip eos-$EOS_VER
md5sum eos-$EOS_VER.zip
