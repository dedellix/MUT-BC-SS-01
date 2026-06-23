#!/bin/bash

gcc poc.c -o poc3 -lssl -lcrypto

echo "[+] PoC Cross version validation for OpenSSL version 3.x compiled"
