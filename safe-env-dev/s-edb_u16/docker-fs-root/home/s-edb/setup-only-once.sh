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
#section: check vscode deb package

VSCODE_DEB_FILE="${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/code_1.38.1-1568209190_amd64.deb"
[ -f $VSCODE_DEB_FILE ] && 
[ "3bbc586aacbe17a3a8e11a1402abc389" == $(md5sum $VSCODE_DEB_FILE | awk '{print $1}') ] ||
{ echo "$0 said: code_*.deb error"; exit 1; }

#######################################
#######################################
#######################################
#section: check safe-depends-bin

DEPENDS_GZ_FILE=${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/depends_bin.*.tar.gz
function check_safe_depends_bin()
{
	return
	[ -f $DEPENDS_GZ_FILE ] && 
	[ "18f45ffff2a0e6febd18de74c2abe9f7" == $(md5sum $DEPENDS_GZ_FILE | awk '{print $1}') ] ||
	{ echo "$0 said: depends_bin.*.tar.gz error"; exit 1; }
}
#check_safe_depends_bin

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
} ||
{ echo "$0 said: error when apt-get install ..."; exit 1; }

#######################################
#######################################
#######################################
#section: install vscode

function install_vscode_by_apt()
{
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg ||
	{ echo "$0 said: error when get microsoft.gpg"; exit 1; }
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list ||
	{ echo "$0 said: error when config vscode.list"; exit 1; }
	apt-get update &&
	apt-get install -y code ||
	{ echo "$0 said: error when install vscode by apt"; exit 1; }
}

function install_vscode_by_deb()
{
	apt-get install -y "${VSCODE_DEB_FILE}" ||
	{ echo "$0 said: error when install vscode by deb"; exit 1; }
}
install_vscode_by_deb

#######################################
#######################################
#######################################
#section: install vscode extensions

s-edb--code--install-extension

#######################################
#######################################
#######################################
#section: install safe-depends-bin

function install_safe_depends_bin()
{
	cd "${ROOT_DIR}/home/${MAIN_DIR_NAME}/build-aux/" &&
	tar xzf "$DEPENDS_GZ_FILE" -C ../ ||
	{ echo "$0 said: error when install safe depends ..."; exit 1; }
}
#install_safe_depends_bin

#######################################
#######################################
#######################################
#section: 

apt -y autoremove && 
apt-get clean  && 
rm -rf "${DEPENDS_GZ_FILE}" "${VSCODE_DEB_FILE}" ||
{ echo "$0 said: error when apt clean ..."; exit 1; }

#######################################
#######################################
#######################################
#section: set build tools

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
