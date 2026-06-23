#!/bin/bash

set -e

OPENSSL=$HOME/openssl-1.1.1h-install/bin/openssl
export LD_LIBRARY_PATH=$HOME/openssl-1.1.1h-install/lib

mkdir -p certs

########################################
# ROOT CA
########################################
$OPENSSL genrsa -out certs/root.key 2048

$OPENSSL req -new -x509 \
  -key certs/root.key \
  -out certs/root.pem \
  -days 3650 \
  -config configs/ca.cnf \
  -extensions v3_ca

########################################
# MUTANT INTERMEDIATE
########################################
$OPENSSL genrsa -out certs/leaf.key 2048

$OPENSSL req -new \
  -key certs/leaf.key \
  -out certs/leaf.csr \
  -config configs/leaf.cnf

$OPENSSL x509 -req \
  -in certs/leaf.csr \
  -CA certs/root.pem \
  -CAkey certs/root.key \
  -CAcreateserial \
  -out certs/leaf.pem \
  -days 365 \
  -extfile configs/leaf.cnf \
  -extensions v3_leaf

########################################
# SUBLEAF
########################################
$OPENSSL genrsa -out certs/subleaf.key 2048

$OPENSSL req -new \
  -key certs/subleaf.key \
  -out certs/subleaf.csr \
  -subj "/CN=www.subleaf.com"

$OPENSSL x509 -req \
  -in certs/subleaf.csr \
  -CA certs/leaf.pem \
  -CAkey certs/leaf.key \
  -CAcreateserial \
  -out certs/subleaf.pem \
  -days 365 \
  -extfile <(cat <<EOF
[v3]
subjectAltName=DNS:www.subleaf.com
basicConstraints=CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
) \
  -extensions v3

echo "[+] Certificates generated"
