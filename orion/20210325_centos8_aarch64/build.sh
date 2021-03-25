#!/bin/sh

# Install dependencies
yum -y install epel-release
yum -y install \
  boost-devel \
  bzip2 \
  cmake \
  gnutls-devel \
  libgcrypt-devel \
  libcurl-devel \
  openssl-devel \
  libuuid-devel \
  make \
  nc \
  git \
  gcc-c++ \
  tar \
  which \
  cyrus-sasl-devel

# Install libmicrohttpd from source
cd /opt
curl -kOL http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.70.tar.gz
tar xvf libmicrohttpd-0.9.70.tar.gz
cd libmicrohttpd-0.9.70
./configure --disable-messages --disable-postprocessor --disable-dauth
make
make install
ldconfig

# Install mongodb driver from source
cd /opt
curl -kOL https://github.com/mongodb/mongo-c-driver/releases/download/1.17.4/mongo-c-driver-1.17.4.tar.gz
tar xfvz mongo-c-driver-1.17.4.tar.gz
cd mongo-c-driver-1.17.4
mkdir cmake-build
cd cmake-build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..  
make
make install

# Install rapidjson from source
cd /opt
curl -kOL https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz
tar xfz v1.1.0.tar.gz
mv rapidjson-1.1.0/include/rapidjson/ /usr/local/include

# Install orion from source
RUN cd /opt
git clone https://github.com/telefonicaid/fiware-orion.git
cd fiware-orion
git checkout feature/3132_poc_isolating_driver_usage
make
make install

yum -y install python2 wget diffutils
wget https://nexus.lab.fiware.org/repository/raw/public/storage/gmock-1.5.0.tar.bz2
tar xfvj gmock-1.5.0.tar.bz2
cd gmock-1.5.0
./configure --build=arm-linux
sed -i 's/env python/env python2/' gtest/scripts/fuse_gtest_files.py
make
make install
ldconfig

yum -y install curl nc valgrind bc
pip2 install virtualenv
yum -y install libffi-devel rpm-build python2-devel

cd /opt/fiware-orion
mkdir ~/bin
export PATH=~/bin:$PATH
make install_scripts INSTALL_DIR=~
. scripts/testEnv.sh
virtualenv /opt/ft_env --python=/usr/bin/python2
. /opt/ft_env/bin/activate
pip install Flask==1.0.2 pyOpenSSL==19.0.0

cd /opt
yum -y install libxslt
wget http://downloads.sourceforge.net/ltp/lcov-1.14-1.noarch.rpm
yum -y install lcov-1.14-1.noarch.rpm
