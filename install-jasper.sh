#!/bin/bash

set -xe && \
buildDeps=" \
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
          " && \
apt-get update && \
apt-get install -y $buildDeps --no-install-recommends && \
rm -rf /var/lib/apt/lists/* && \
\
git clone https://github.com/jasperproject/jasper-client.git /jasper && \
easy_install pip && \
pip install --upgrade setuptools && \
pip install -r /jasper/client/requirements.txt && \
chmod +x /jasper/jasper.py && \
\
svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/ /jasper/cmuclmtk && \
cd /jasper/cmuclmtk && \
./autogen.sh && \
make && \
make install && \
\
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps
