#!/bin/bash

gcc src/poc.c   -o poc   -I/home/vagrant/openssl-1.1.1h-install/include   -L/home/vagrant/openssl-1.1.1h-install/lib   -lssl -lcrypto   -Wl,-rpath,/home/vagrant/openssl-1.1.1h-install/lib

echo "[+] PoC compiled"
