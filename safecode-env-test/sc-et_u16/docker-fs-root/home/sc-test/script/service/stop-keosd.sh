#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################
PP=$(pidof keosd)
[[ $PP != "" ]] && kill $PP

