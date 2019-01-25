#!/bin/bash

ROOT_DIR=/
MAIN_DIR_NAME="sc-edb"

#######################################
#######################################
#######################################
#section:

if [[ "${DOCKER_ONBUILD}"=="true" ]]
then
	ROOT_DIR=/
	find ${ROOT_DIR}/home/ | grep  -E '.gitkeep|.gitignore' | xargs rm -rf
	find ${ROOT_DIR}/home/ -name '*.sh' | xargs chmod +x
	find ${ROOT_DIR}/usr/local/bin/ | xargs chmod +x
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
#section: check vscode deb package

VSCODE_DEB_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/code_1.30.2-1546901646_amd64.deb"
[ -f $VSCODE_DEB_FILE ] && 
[ "1db1e99da33252f633046344cd940fbc" == $(md5sum $VSCODE_DEB_FILE | awk '{print $1}') ] ||
{ echo "$0 said: code_*.deb error"; exit 1; }

#######################################
#######################################
#######################################
#section: check eos source package

EOS_SOURCE_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos_v1.6.0.zip"
[ -f $EOS_SOURCE_FILE ] && 
[ "59e74e79722e25ebda4b7ebdfc434265" == $(md5sum $EOS_SOURCE_FILE | awk '{print $1}') ] ||
{ echo "$0 said: eos_*.zip error"; exit 1; }

#######################################
#######################################
#######################################
#section: replace os's default sources.list

[ -f /etc/apt/sources.list ] && mv /etc/apt/sources.list /etc/apt/sources.list_os.nouse
mv /etc/apt/sources.list.d/aliyun-mirror.list /etc/apt/sources.list ||
{ echo "$0 said: error when replace /etc/apt/sources.list"; exit 1; }

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
apt-get install -y "${VSCODE_DEB_FILE}" ||
{ echo "$0 said: error when apt-get install ..."; exit 1; }

#######################################
#######################################
#######################################
#section: install eos-build-depends

cd "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/" &&
unzip eos_v1.6.0.zip &&
cd eos-1.6.0/ &&
./eosio_build.sh &&
./eosio_install.sh ||
{ echo "$0 said: error when build from source ..."; exit 1; }

#######################################
#######################################
#######################################
#section: 

apt -y autoremove && 
apt-get clean  && 
rm -rf "${VSCODE_DEB_FILE}" &&
rm -rf "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-1.6.0/" ||
{ echo "$0 said: error when apt clean ..."; exit 1; }

#######################################
#######################################
#######################################
#section: ending

echo
echo "##########"
echo "$0 said: run ok."
echo "##########"
echo 
