#!/bin/bash

ROOT_DIR=/
MAIN_DIR_NAME="s-ed"

#######################################
#######################################
#######################################
#section:

if [[ "${DOCKER_ONBUILD}"=="true" ]]
then
        ROOT_DIR=/
        find ${ROOT_DIR}/home/ | grep  -E '.gitkeep|.gitignore' | xargs rm -rf
        find ${ROOT_DIR}/home/ -name '*.sh' | xargs chmod +x
else
        ROOT_DIR="${PWD}/"
        mkdir -p ${ROOT_DIR}/home/${MAIN_DIR_NAME} ||
        { echo "$0 said: error when 'mkdir ${ROOT_DIR}/home/${MAIN_DIR_NAME}'"; exit 1; }
fi

cd ${ROOT_DIR}/home/${MAIN_DIR_NAME} ||
{ echo "$0 said: error when 'cd ${ROOT_DIR}/home/${MAIN_DIR_NAME}'"; exit 1; }

#######################################
#######################################
#######################################
#section:

DEPENDS_GZ_FILE=${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/depends.*.tar.gz
MACOSX_SDK_FILE=${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/MacOSX*-SDKs.tar.gz

tar xzvf ${DEPENDS_GZ_FILE} &&
rm -rf depends_bin &&
mv depends depends_bin &&
cd depends_bin &&
tar xzvf ${MACOSX_SDK_FILE} &&
make HOST=x86_64-pc-linux-gnu -j4 &&
#make HOST=x86_64-w64-mingw32 -j4 &&
#make HOST=i686-w64-mingw32 -j4 &&
#make HOST=x86_64-apple-darwin11 ||
#{ echo "$0 said: error when make HOST=xxx"; exit 1; }

#######################################
#######################################
#######################################

echo 
echo "##########"
echo "$0 said: run ok."
echo "##########"
echo
