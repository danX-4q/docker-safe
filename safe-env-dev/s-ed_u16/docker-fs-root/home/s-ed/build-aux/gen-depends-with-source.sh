#!/bin/bash

apt-get install -y curl librsvg2-bin libtiff-tools bsdmainutils cmake imagemagick libcap-dev libz-dev libbz2-dev python-setuptools &&

git clone https://github.com/BankLedger/safe.git --branch dev-2.1.0 --single-branch &&
cd safe &&
git checkout cc0b049845ca2b242d3af1cfb16156a410718c12 &&

cd depends && {
        make download || make download || make download || make download
}

echo -e 'please confirm cmd and run it yourself: \n cd .. && cp -rf depends ../'

