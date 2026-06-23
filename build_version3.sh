#!/bin/bash

gcc src/poc_fixed.c -o poc3 -lssl -lcrypto

echo "[+] PoC Cross version validation for OpenSSL version 3.x compiled"
