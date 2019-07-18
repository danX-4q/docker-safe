#!/bin/bash

zpath=$(cd `dirname $0`; pwd)
cd $zpath > /dev/null

##############################

#usage:
#    $1: dc-script global config file
#        default: ./dc.conf

set -x

DC_CONF=${1-"./dc.conf"}
. $DC_CONF || { echo "error when load $DC_CONF"; exit 1; }
cd "$DC_PRJ_ROOT_DIR" > /dev/null

##############################

./dc-build.sh "$DC_CONF"
docker-compose up -d
