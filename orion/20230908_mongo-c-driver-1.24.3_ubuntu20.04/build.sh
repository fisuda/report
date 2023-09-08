#!/bin/bash
set -ue

export TZ=Asia/Tokyo
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

uname -m
cat /etc/lsb-release

apt-get -y update
apt-get -y upgrade

# Install dependencies
apt-get -y install \
  curl \
  cmake \
  libssl-dev \
  git \
  g++ \
  libcurl4-openssl-dev \
  libboost-dev \
  libboost-regex-dev \
  libboost-filesystem-dev \
  libboost-thread-dev \
  uuid-dev \
  libgnutls28-dev \
  libsasl2-dev \
  libgcrypt-dev
 # Install libmicrohttpd from source
 cd /opt
 curl -kOL https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.76.tar.gz
 tar xvf libmicrohttpd-0.9.76.tar.gz
 cd libmicrohttpd-0.9.76
 ./configure --disable-messages --disable-postprocessor --disable-dauth
 make
 make install
 ldconfig
 # Install mosquitto from source
 cd /opt
 curl -kOL https://mosquitto.org/files/source/mosquitto-2.0.15.tar.gz
 tar xvf mosquitto-2.0.15.tar.gz
 cd mosquitto-2.0.15
 sed -i 's/WITH_CJSON:=yes/WITH_CJSON:=no/g' config.mk
 sed -i 's/WITH_STATIC_LIBRARIES:=no/WITH_STATIC_LIBRARIES:=yes/g' config.mk
 sed -i 's/WITH_SHARED_LIBRARIES:=yes/WITH_SHARED_LIBRARIES:=no/g' config.mk
 make
 make install
 ldconfig

 echo "--------------------"
 # Install mongodb driver from source
 cd /opt
 curl -kOL https://github.com/mongodb/mongo-c-driver/releases/download/1.24.3/mongo-c-driver-1.24.3.tar.gz
 tar xfvz mongo-c-driver-1.24.3.tar.gz
 cd mongo-c-driver-1.24.3
 mkdir cmake-build
 cd cmake-build
 # Different from ci/deb/build-dep.sh and build from source documentation, we add here also
 # the MONGOC_TEST_USE_CRYPT_SHARED=FALSE. It needs Python and in this tiny image we don't have it
 cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DMONGOC_TEST_USE_CRYPT_SHARED=FALSE ..  
 make
 make install
 echo "--------------------"
 # Install rapidjson from source
 cd /opt
 curl -kOL https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz
 tar xfz v1.1.0.tar.gz
 mv rapidjson-1.1.0/include/rapidjson/ /usr/local/include
 # Install orion from source
 cd /opt
 git clone https://github.com/telefonicaid/fiware-orion
 cd fiware-orion
 # git checkout 3.10.1
 make
 make install
 # reduce size of installed binaries
 strip /usr/bin/contextBroker
 # create needed run path
 mkdir -p /var/run/contextBroker
