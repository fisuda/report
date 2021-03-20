#!/bin/sh
set -ue

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y git curl wget
apt install -y build-essential cmake
apt install -y libboost-dev libboost-regex-dev libboost-thread-dev libboost-filesystem-dev \
               libcurl4-gnutls-dev gnutls-dev libgcrypt-dev libssl-dev uuid-dev libsasl2-dev

cd /opt
wget https://github.com/mongodb/mongo-c-driver/releases/download/1.17.4/mongo-c-driver-1.17.4.tar.gz
tar xfvz mongo-c-driver-1.17.4.tar.gz
cd mongo-c-driver-1.17.4
mkdir cmake-build
cd cmake-build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
make
make install

cd /opt
curl -kOL https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz
tar xfz v1.1.0.tar.gz
mv rapidjson-1.1.0/include/rapidjson/ /usr/local/include

cd /opt
wget http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.70.tar.gz
tar xvf libmicrohttpd-0.9.70.tar.gz
cd libmicrohttpd-0.9.70
./configure --disable-messages --disable-postprocessor --disable-dauth
make
make install
ldconfig

cd /opt
git clone https://github.com/telefonicaid/fiware-orion
cd fiware-orion
git checkout -b feature/3132_poc_isolating_driver_usage origin/feature/3132_poc_isolating_driver_usage
make
make install
make install INSTALL_DIR=/usr

cd /opt
apt -y install python-is-python2 xsltproc
wget https://nexus.lab.fiware.org/repository/raw/public/storage/gmock-1.5.0.tar.bz2
tar xfvj gmock-1.5.0.tar.bz2
cd gmock-1.5.0
./configure
make
make install
ldconfig

cd /opt
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
python get-pip.py
apt install -y curl netcat valgrind bc
pip install --upgrade pip
pip install virtualenv

cd /opt/fiware-orion
mkdir ~/bin
export PATH=~/bin:$PATH
make install_scripts INSTALL_DIR=~
. scripts/testEnv.sh
virtualenv /opt/ft_env
. /opt/ft_env/bin/activate
pip install Flask==1.0.2 pyOpenSSL==19.0.0

apt -y install lcov
