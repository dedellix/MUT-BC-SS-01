#!/bin/bash

export OPENSSL111H=/home/vagrant/openssl-1.1.1h-install/bin/openssl
export LD_LIBRARY_PATH=/home/vagrant/openssl-1.1.1h-install/lib:/home/vagrant/openssl-1.1.1h-install/lib:

echo "[+] OpenSSL version:"
 version

echo "[+] Libraries:"
ldd 
