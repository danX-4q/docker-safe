#!/bin/bash

[[ "$INCLUDE_CUFS" != "true" ]] && {
    cd ../test-utils/
    . contracts.utils.func.sh
    cd - > /dev/null
}

export INCLUDE_ETFS="true"

##############################
