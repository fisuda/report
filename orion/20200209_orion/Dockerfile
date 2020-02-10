FROM centos:7 AS build_stage

    # Install gcc 5.3.0
RUN yum install -y wget make gcc gcc-c++ m4 && \
    cd /opt && \
    wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.gz && \
    wget https://gmplib.org/download/gmp/gmp-6.1.0.tar.xz && \
    wget https://www.mpfr.org/mpfr-3.1.4/mpfr-3.1.4.tar.xz && \
    wget ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz && \
    # Install gmp 6.1.0
    cd /opt && \
    tar xJf gmp-6.1.0.tar.xz && \
    cd gmp-6.1.0/ && \
    ./configure && \
    make -j4 && \
    make install && \
    # Install mpfr 3.1.4
    cd /opt && \
    tar xJf mpfr-3.1.4.tar.xz && \
    cd mpfr-3.1.4/ && \
    ./configure --with-gmp=/usr/local/ && \
    make -j4 && \
    make install && \
    # Install mpc 1.0.3
    cd /opt && \
    tar xf mpc-1.0.3.tar.gz && \
    cd mpc-1.0.3 && \
    ./configure && \
    make -j4 && \
    make install && \
    # Install gcc 5.3.0
    cd /opt && \
    tar xzf gcc-5.3.0.tar.gz && \
    cd gcc-5.3.0 && \
    mkdir build && \
    cd build && \
    ../configure --enable-shared --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++ --disable-multilib --disable-bootstrap && \
    make -j4 && \
    make install && \
    bash -c "echo '/usr/local/lib' >> /etc/ld.so.conf.d/00-local.conf" && \
    bash -c "echo '/usr/local/lib64' >> /etc/ld.so.conf.d/00-local.conf" && \
    ldconfig
    # Install mongo 3.6.17
RUN yum install -y epel-release && \
    yum install -y git make cmake scons python-pip python-devel libffi-devel openssl-devel wget bzip2 && \
    pip install --upgrade pip && \
    cd /opt && \
    git clone -b r3.6.17 --depth=1 https://github.com/mongodb/mongo.git && \
    cd mongo && \
    pip install --user -r buildscripts/requirements.txt && \
    python buildscripts/scons.py mongo mongod mongos --wiredtiger=on --mmapv1=on MONGO_VERSION=3.6.17 CCFLAGS=-march=armv8-a+crc

FROM centos:centos7

MAINTAINER FIWARE Orion Context Broker Team. Telefónica I+D

ENV ORION_USER orion
ENV GIT_REV_ORION 2.3.0
ENV CLEAN_DEV_TOOLS 0

WORKDIR /opt

RUN \
    adduser --comment "${ORION_USER}" ${ORION_USER} && \
    # Install dependencies
    yum -y install epel-release && \
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
      scons \
      tar \
      which \
      cyrus-sasl-devel && \
    # Install scons from source
    curl -kOL https://downloads.sourceforge.net/scons/scons-3.1.2.tar.gz && \
    tar zxf scons-3.1.2.tar.gz && \
    cd scons-3.1.2 && \
    python setup.py install && \
    # Install libmicrohttpd from source
    cd /opt && \
    curl -kOL http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.48.tar.gz && \
    tar xvf libmicrohttpd-0.9.48.tar.gz && \
    cd libmicrohttpd-0.9.48 && \
    ./configure --disable-messages --disable-postprocessor --disable-dauth && \
    make && \
    make install && \
    ldconfig && \
    # Install mongodb driver from source
    cd /opt && \
    curl -kOL https://github.com/mongodb/mongo-cxx-driver/archive/legacy-1.1.2.tar.gz && \
    tar xfz legacy-1.1.2.tar.gz && \
    cd mongo-cxx-driver-legacy-1.1.2 && \
    scons --use-sasl-client --ssl && \
    scons install --prefix=/usr/local --use-sasl-client --ssl && \
    # Install rapidjson from source
    cd /opt && \
    curl -kOL https://github.com/miloyip/rapidjson/archive/v1.0.2.tar.gz && \
    tar xfz v1.0.2.tar.gz && \
    mv rapidjson-1.0.2/include/rapidjson/ /usr/local/include && \
    # Install orion from source
    cd /opt && \
    git clone https://github.com/telefonicaid/fiware-orion && \
    cd fiware-orion && \
    git checkout ${GIT_REV_ORION} && \
    sed -i -e '251ielseif ("${BUILD_ARCH}" STREQUAL "arm64")\n    link_directories("/usr/lib64")' CMakeLists.txt && \
    make && \
    make install && \
    # reduce size of installed binaries
    strip /usr/bin/contextBroker && \
    # create needed log and run paths
    mkdir -p /var/log/contextBroker && \
    mkdir -p /var/run/contextBroker && \
    chown ${ORION_USER} /var/log/contextBroker && \
    chown ${ORION_USER} /var/run/contextBroker && \
    cd /opt && \
    if [ ${CLEAN_DEV_TOOLS} -eq 0 ] ; then yum clean all && exit 0 ; fi && \
    # cleanup sources, dev tools, locales and yum cache to reduce the final image size
    rm -rf /opt/libmicrohttpd-0.9.48.tar.gz \
           /usr/local/include/microhttpd.h \
           /usr/local/lib/libmicrohttpd.* \
           /opt/libmicrohttpd-0.9.48 \
           /opt/legacy-1.1.2.tar.gz \
           /opt/mongo-cxx-driver-legacy-1.1.2 \
           /usr/local/include/mongo \
           /usr/local/lib/libmongoclient.a \
           /opt/rapidjson-1.0.2 \
           /opt/v1.0.2.tar.gz \
           /usr/local/include/rapidjson \
           /opt/fiware-orion \
           # We don't need to manage Linux account passwords requisites: lenght, mays/mins, etc.
           # This cannot be removed using yum as yum uses hard dependencies and doing so will 
           # uninstall essential packages
           /usr/share/cracklib \
           # We don't need glibc locale data. This cannot be removed using yum as yum uses hard 
           # dependencies and doing so will uninstall essential packages
           /usr/share/i18n /usr/{lib,lib64}/gconv \
           && \
    yum -y erase git perl* rsync \
        cmake libarchive \
        gcc-c++ cloog-ppl cpp gcc glibc-devel glibc-headers \
        kernel-headers libgomp libstdc++-devel mpfr ppl \
        scons boost-devel libcurl-devel gnutls-devel libgcrypt-devel \
        clang llvm llvm-libs \
        CUnit-devel CUnit \
        autoconf automake m4 libidn-devel \
        boost-wave boost-serialization boost-python \
        boost-iostreams boost boost-date-time \
        boost-test boost-graph boost-signals \
        boost-program-options boost-math \
        openssh openssh-clients libedit hwdata dbus-glib fipscheck* *devel sysvinit-tools \
        && \
    # Erase without dependencies of the document formatting system (man). This cannot be removed using yum 
    # as yum uses hard dependencies and doing so will uninstall essential packages
    rpm -qa groff | xargs -r rpm -e --nodeps && \
    # Clean yum data
    yum clean all && rm -rf /var/lib/yum/yumdb && rm -rf /var/lib/yum/history && \
    # Rebuild rpm data files
    rpm -vv --rebuilddb && \
    # Delete unused locales. Only preserve en_US and the locale aliases
    find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en_US' ! -name 'locale.alias' | xargs -r rm -r && \
    bash -c 'localedef --list-archive | grep -v -e "en_US" | xargs localedef --delete-from-archive' && \
    # We use cp instead of mv as to refresh locale changes for ssh connections. We use /bin/cp instead of 
    # cp to avoid any alias substitution, which in some cases has been problematic
    /bin/cp -f /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl && \
    build-locale-archive && \
    # Don't need old log files inside docker images
    rm -f /var/log/*log

RUN yum install -y python curl nc valgrind bc python-devel libffi-devel python-pip && \
    pip install --upgrade pip && \
    cd /opt/fiware-orion && \
    mkdir ~/bin && \
    make install_scripts INSTALL_DIR=~ && \
    . scripts/testEnv.sh && \
    cd /opt && \
    pip install virtualenv && \
    virtualenv /opt/ft_env && \
    . /opt/ft_env/bin/activate && \
    pip install Flask==1.0.2 pyOpenSSL && \
    deactivate
ENV PATH=~/bin:$PATH

COPY --from=build_stage /usr/local/lib64/libgcc_s.so.1 /usr/local/lib64
COPY --from=build_stage /usr/local/lib64/libstdc++.so.6 /usr/local/lib64
COPY --from=build_stage /usr/local/lib64/libstdc++.so.6.0.21 /usr/local/lib64
COPY --from=build_stage /opt/mongo/mongo /usr/local/bin
COPY --from=build_stage /opt/mongo/mongos /usr/local/bin
COPY --from=build_stage /opt/mongo/mongod /usr/local/bin
COPY ./mongod.sh /

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64

RUN useradd -M -s /bin/false mongodb && \
    mkdir /var/lib/mongodb && \
    chown mongodb:mongodb /var/lib/mongodb && \
    mkdir /var/log/mongodb && \
    chown mongodb:mongodb /var/log/mongodb && \
    mkdir /var/run/mongodb && \
    chown mongodb:mongodb /var/run/mongodb
VOLUME /var/lib/mongodb
COPY ./mongod.conf /etc
COPY ./test.sh /
RUN chown mongodb:mongodb /var/lib/mongodb

RUN cd /opt && \
    curl -kOL https://github.com/linux-test-project/lcov/releases/download/v1.12/lcov-1.12.tar.gz && \
    tar xfz lcov-1.12.tar.gz && \
    cd lcov-1.12/ && \
    make install && \
    rm -fr lcov-1.12

WORKDIR /
CMD tail -f /etc/mongod.conf
EXPOSE 1026
