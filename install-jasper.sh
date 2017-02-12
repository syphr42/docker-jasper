#!/bin/bash

set -xe && \
buildDeps=" \
           git-core \
          " && \
apt-get update && \
apt-get install -y $buildDeps --no-install-recommends && \
rm -rf /var/lib/apt/lists/* && \
\
git clone https://github.com/jasperproject/jasper-client.git /jasper && \
pip install --upgrade setuptools && \
pip install -r /jasper/client/requirements.txt && \
chmod +x /jasper/jasper.py && \
\
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps
