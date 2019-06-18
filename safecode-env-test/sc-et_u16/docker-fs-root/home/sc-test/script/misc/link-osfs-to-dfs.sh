#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

tdir="${PWD}/../../../sc-test/"

cd /home
ln -s "${tdir}"
