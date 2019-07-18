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
#section: check eos-build-depends-packages

function check_eos_build_depends_packages()
{
	EBD_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-build-depends/boost_1_67_0.tar.bz2"
	[ -f $EBD_FILE ] && 
	[ "ced776cb19428ab8488774e1415535ab" == $(md5sum $EBD_FILE | awk '{print $1}') ] ||
	{ echo "$0 said: $EBD_FILE error"; exit 1; }

	EBD_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-build-depends/mongodb-linux-x86_64-3.6.3.tgz"
	[ -f $EBD_FILE ] && 
	[ "fe803e2243aff20a634d5aa711705e82" == $(md5sum $EBD_FILE | awk '{print $1}') ] ||
	{ echo "$0 said: $EBD_FILE error"; exit 1; }

	EBD_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-build-depends/mongo-c-driver-1.10.2.tar.gz"
	[ -f $EBD_FILE ] && 
	[ "09f9d2b48fa24e47f9e608d290976766" == $(md5sum $EBD_FILE | awk '{print $1}') ] ||
	{ echo "$0 said: $EBD_FILE error"; exit 1; }
}

#######################################
#######################################
#######################################
#section: check eos source package

EOS_VER="v1.6.0"
EOS_SOURCE_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-${EOS_VER}.zip"
function check_eos_source_package()
{
	[ -f $EOS_SOURCE_FILE ] && 
	[ "50ceece5d97371e5c74fcead25b6a6ff" == $(md5sum $EOS_SOURCE_FILE | awk '{print $1}') ] ||
	{ echo "$0 said: eos-*.zip error"; exit 1; }
}

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

sc-edb--code --install-extension MS-CEINTL.vscode-language-pack-zh-hans
sc-edb--code --install-extension ms-vscode.cpptools
sc-edb--code --install-extension alefragnani.Bookmarks
sc-edb--code --install-extension eamodio.gitlens

#######################################
#######################################
#######################################
#section: install eos-build-depends

function install_eos_build_depends()
{
	cd "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/" &&
	unzip eos-${EOS_VER}.zip &&
	cd eos-${EOS_VER}/ &&
	patch -p1 < ../eos-only-install-depends.patch &&
	echo 1 | ./eosio_build.sh ||
	{ echo "$0 said: error when build eos from source ..."; exit 1; }
}
#######################################
#######################################
#######################################
#section: 

apt -y autoremove && 
apt-get clean  && 
rm -rf "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-${EOS_VER}/" &&
rm -rf "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/eos-${EOS_VER}.zip" ||
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
