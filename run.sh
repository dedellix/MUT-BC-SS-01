#!/bin/bash

export LD_LIBRARY_PATH=/home/vagrant/openssl-1.1.1h-install/lib

echo "[+] Running mutation test..."
./poc
