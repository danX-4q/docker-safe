#!/bin/bash

VAR_PREFIX="SSM_EDB__"
EVN_FILE="./docker-env.git"

GIT_BRANCH=$(git branch -va | grep '^*' | awk '{print $2}')
GIT_HASH=$(git log ${GIT_BRANCH} -n1 | grep '^commit' | awk '{print $2}')

echo "${VAR_PREFIX}GIT_BRANCH=${GIT_BRANCH}" > ${EVN_FILE}
echo "${VAR_PREFIX}GIT_HASH=${GIT_HASH}" >> ${EVN_FILE}

