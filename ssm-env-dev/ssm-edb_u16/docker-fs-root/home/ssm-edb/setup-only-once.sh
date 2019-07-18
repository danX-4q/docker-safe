#!/bin/bash

ROOT_DIR=/
MAIN_DIR_NAME="ssm-edb"

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

ssm-edb--code --install-extension MS-CEINTL.vscode-language-pack-zh-hans
ssm-edb--code --install-extension atian25.eggjs
ssm-edb--code --install-extension yuzukwok.eggjs-dev-tools
ssm-edb--code --install-extension alefragnani.Bookmarks
ssm-edb--code --install-extension eamodio.gitlens

#######################################
#######################################
#######################################
#section: install node 10.x LTS

curl -sL https://deb.nodesource.com/setup_10.x | bash - &&
#spec nodejs version like: apt-get install -y nodejs=10.15.3-1nodesource1 &&
apt-get install -y nodejs &&
apt-get install -y gcc g++ make &&
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && 
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&
apt-get update && apt-get install -y yarn=1.16.0-1 ||
{ echo "$0 said: error when install nodejs ..."; exit 1; }

#######################################
#######################################
#######################################
#section: install cnpm

npm install -g cnpm --registry=https://registry.npm.taobao.org &&
cnpm -v ||
{ echo "$0 said: error when install cnpm ..."; exit 1; }

#######################################
#######################################
#######################################
#section: 

apt -y autoremove && 
apt-get clean ||
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
