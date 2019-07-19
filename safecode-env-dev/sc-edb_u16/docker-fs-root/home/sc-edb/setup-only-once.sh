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
	find ${ROOT_DIR}/usr/local/bin/ -name *.conf | xargs chmod -x
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
#section: check eosio-build-depends-packages

EBD_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eosio-v1.8.1-dependencise.tar.gz"
function check_eosio_build_depends_packages()
{
	[ -f $EBD_FILE ] && 
	[ "372c0c1d46fc249a4857b613ac01b01a" == $(md5sum $EBD_FILE | awk '{print $1}') ] ||
	{ echo "$0 said: check $EBD_FILE error"; exit 1; }
}
check_eosio_build_depends_packages

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
#add-apt-repository -y ppa:bitcoin/bitcoin &&
apt-get update &&

{ 
sed -e 's|#.*$||g' ${APT_PACK_LIST_FILE} | xargs apt-get install -y; 
sed -e 's|#.*$||g' ${APT_PACK_LIST_FILE} | xargs apt-get install -y;
sed -e 's|#.*$||g' ${APT_PACK_LIST_FILE} | xargs apt-get install -y;
} ||
{ echo "$0 said: error when apt-get install ..."; exit 1; }

#######################################
#######################################
#######################################
#section: install vscode

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg ||
{ echo "$0 said: error when get microsoft.gpg"; exit 1; }
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list ||
{ echo "$0 said: error when config vscode.list"; exit 1; }
apt-get update &&
apt-get install -y code ||
{ echo "$0 said: error when install vscode"; exit 1; }

#######################################
#######################################
#######################################
#section: install vscode extensions

sc-edb--code--install-extension

#######################################
#######################################
#######################################
#section: install eosio-build-depends

function install_eosio_build_depends()
{
	cd "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/" &&
	tar xzf "$EBD_FILE" -C / ||
	{ echo "$0 said: error when install eosio depends ..."; exit 1; }
}
install_eosio_build_depends

#######################################
#######################################
#######################################
#section: 

apt -y autoremove && 
apt-get clean  && 
rm -rf "${EBD_FILE}" ||
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
