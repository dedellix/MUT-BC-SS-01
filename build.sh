#!/bin/bash

gcc src/poc.c \
-o poc \
-I$HOME/openssl-1.1.1h-install/include \
-L$HOME/openssl-1.1.1h-install/lib \
-lssl \
-lcrypto \
-Wl,-rpath,$HOME/openssl-1.1.1h-install/lib
