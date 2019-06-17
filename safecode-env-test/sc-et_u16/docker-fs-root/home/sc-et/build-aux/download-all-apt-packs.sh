#!/bin/bash

apt-get update &&
apt-get install -y software-properties-common &&
add-apt-repository -y ppa:bitcoin/bitcoin &&
apt-get clean

echo 'only run at inner docker ubuntu:16.04 when it is clean.'

apt-get update
sed -e 's|#.*$||g' ./apt-pack-list | xargs apt-get install -dy
sed -e 's|#.*$||g' ./apt-pack-list | xargs apt-get install -dy	#the second time at least
sed -e 's|#.*$||g' ./apt-pack-list | xargs apt-get install -dy

tar cPf cache.apt.archives.md5sum.tar /var/cache/apt/archives/
mv cache.apt.archives.md5sum.tar cache.apt.archives.$(md5sum cache.apt.archives.md5sum.tar | awk '{print $1}').tar

echo 'at docker host, run ```docker cp``` to save cache.apt.archives.*.tar'

