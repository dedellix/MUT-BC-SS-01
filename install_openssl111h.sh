#!/bin/bash

set -e

mkdir -p tls-test
cd tls-test

wget https://www.openssl.org/source/openssl-1.1.1h.tar.gz

tar xzf openssl-1.1.1h.tar.gz

cd openssl-1.1.1h

./config   --prefix=/home/vagrant/openssl-1.1.1h-install   --openssldir=/home/vagrant/openssl-1.1.1h-install   shared zlib

make -j4
make install

echo "[+] OpenSSL 1.1.1h installed"
