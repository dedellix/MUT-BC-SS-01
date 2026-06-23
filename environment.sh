#!/bin/bash

export OPENSSL111H=$HOME/openssl-1.1.1h-install/bin/openssl

export LD_LIBRARY_PATH=$HOME/openssl-1.1.1h-install/lib:$LD_LIBRARY_PATH

echo "Using:"
$OPENSSL111H version

ldd $OPENSSL111H 
