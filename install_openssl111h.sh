#!/bin/bash

set -e

mkdir -p tls-test
cd tls-test

wget https://www.openssl.org/source/openssl-1.1.1h.tar.gz

tar xzf openssl-1.1.1h.tar.gz

cd openssl-1.1.1h

./config \
  --prefix=$HOME/openssl-1.1.1h-install \
  --openssldir=$HOME/openssl-1.1.1h-install \
  shared zlib

make -j$(nproc)

make install

echo "Installation complete."
