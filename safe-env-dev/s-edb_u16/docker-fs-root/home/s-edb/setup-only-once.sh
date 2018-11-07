#!/bin/bash

ROOT_DIR=/
MAIN_DIR_NAME="s-edb"

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
#section: replace os's default sources.list

[ -f /etc/apt/sources.list ] && mv /etc/apt/sources.list /etc/apt/sources.list.nouse

#######################################
#######################################
#######################################
#section:

APT_PACK_LIST_FILE=${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/apt-pack-list
#APT_CACHE_TAR_FILE=${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/cache.apt.archives.*.tar

#>>>>>>>>>>
#tar xvf ${APT_CACHE_TAR_FILE} -C / &&
#i have test this, but when apt-get install os will download all packages again

apt-get update &&
apt-get install -y software-properties-common &&
add-apt-repository -y ppa:bitcoin/bitcoin &&
apt-get update &&

{ 
sed -e 's|#.*$||g' ${APT_PACK_LIST_FILE} | xargs apt-get install -y; 
sed -e 's|#.*$||g' ${APT_PACK_LIST_FILE} | xargs apt-get install -y;
sed -e 's|#.*$||g' ${APT_PACK_LIST_FILE} | xargs apt-get install -y;
} && 
apt -y autoremove && 
apt-get clean ||
{ echo "$0 said: error when apt-get install ..."; exit 1; }

#######################################
#######################################
#######################################
#section: 

update-alternatives --set x86_64-w64-mingw32-g++  /usr/bin/x86_64-w64-mingw32-g++-posix &&
update-alternatives --set i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-posix ||
{ echo "$0 said: error when update-alternatives xxx-w64-mingw32-g++"; exit 1; }

#######################################
#######################################
#######################################
#section: ending

echo
echo "##########"
echo "$0 said: run ok."
echo "##########"
echo 
