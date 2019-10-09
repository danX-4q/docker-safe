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

GIT_BRANCH=$(git branch -va | grep '^*' | awk '{print $2}')
GIT_HASH=$(git log ${GIT_BRANCH} -n1 | grep '^commit' | awk '{print $2}')

echo "${VAR_PREFIX}GIT_BRANCH=${GIT_BRANCH}" > ${EVN_FILE}
echo "${VAR_PREFIX}GIT_HASH=${GIT_HASH}" >> ${EVN_FILE}

docker-compose build
