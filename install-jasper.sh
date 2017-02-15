#!/bin/bash

set -xeuo pipefail

BUILD_DEPS=" \
            git-core \
            python-dev \
            python-setuptools \
            subversion \
            autoconf \
            libtool \
            make \
            automake \
            gfortran \
            g++
           "

# install build dependencies
apt-get update
apt-get install -y ${BUILD_DEPS} --no-install-recommends
rm -rf /var/lib/apt/lists/*

# download and install Jasper
git clone "${JASPER_GIT_URL}" "${JASPER_DIR}"
easy_install pip
pip install --upgrade setuptools
pip install -r "${JASPER_DIR}/client/requirements.txt"
chmod +x /jasper/jasper.py

# download and install CMUCLMTK
svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/ "${JASPER_DIR}/cmuclmtk"
cd "${JASPER_DIR}/cmuclmtk"
./autogen.sh
make
make install

# download and install Phonetisaurus
mkdir "${JASPER_DIR}/phonetisaurus"
curl -sSL https://www.dropbox.com/s/kfht75czdwucni1/g014b2b.tgz | tar -zx --directory "${JASPER_DIR}/phonetisaurus"
cd "${JASPER_DIR}/phonetisaurus/g014b2b"
./compile-fst.sh

# remove build dependencies
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${BUILD_DEPS}
