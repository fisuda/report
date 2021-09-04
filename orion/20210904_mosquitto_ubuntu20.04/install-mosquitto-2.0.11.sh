#!/bin/sh
set -ue

LANG=C

if [ -d ./mosquitto-2.0.11 ]; then
  rm -fr ./mosquitto-2.0.11
fi

date
echo "*** uname -a ***"
uname -a
echo "*** /etc/debian_version ***"
cat /etc/debian_version
echo "*** /etc/lsb-release ***"
cat /etc/lsb-release

wget http://mosquitto.org/files/source/mosquitto-2.0.11.tar.gz
tar xvf mosquitto-2.0.11.tar.gz
cd mosquitto-2.0.11
sed -i 's/WITH_CJSON:=yes/WITH_CJSON:=no/g' config.mk
sed -i 's/WITH_STATIC_LIBRARIES:=no/WITH_STATIC_LIBRARIES:=yes/g' config.mk
sed -i 's/WITH_SHARED_LIBRARIES:=yes/WITH_SHARED_LIBRARIES:=no/g' config.mk
make
sudo make install  # installation puts .h files in /usr/local/include and library in /usr/local/lib
sudo ldconfig      # Update /etc/ld.so.cache with the new library files in /usr/local/lib
