# MUT-BC-SS-01: Mutation Testing of X.509 BasicConstraints in OpenSSL

## Overview

This repository implements a specification-driven mutation testing experiment targeting X.509 certificate validation behavior in OpenSSL.

The experiment is based on the mutation operator:

**MUT-BC-SS-01**

which modifies the BasicConstraints extension:

```text
CA:TRUE → CA:FALSE
```

The objective is to evaluate whether certificate validation correctly enforces RFC 5280 requirements and to investigate behavior related to the vulnerability class represented by CVE-2021-3450.

---

## Repository Structure

```text
MUT-BC-SS-01/
│
│
├── configs/
│   ├── ca.cnf
│   └── leaf.cnf
│
├── src/
│   └── poc.c
|   └── poc_fixed.c
│
├── check_prerequisites.sh
├── install_openssl111h.sh
├── environment.sh
├── generate_certs.sh
├── build.sh
├── run.sh
├── build_version3.sh
├── run_version3.sh
│
│
└── README.md
```

---

## Experiment Description

The experiment creates the following certificate chain:

```text
Root CA (CA:TRUE)
        │
        ▼
Mutant Intermediate (CA:FALSE)
        │
        ▼
Subleaf Certificate
```

The mutant certificate is intentionally configured with:

```text
basicConstraints = CA:FALSE
```

while still being used to sign another certificate.

The validation harness evaluates whether OpenSSL correctly rejects this invalid chain.

---

## System Requirements

The experiment was tested on Linux systems using:

* GCC
* GNU Make
* Perl
* OpenSSL source build tools

---

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/dedellix/MUT-BC-SS-01.git
cd MUT-BC-SS-01
```


### 2. Make Scripts Executable

```bash
chmod +x *.sh
```

### 3. Check and Install Prerequisites

```bash
./check_prerequisites.sh
```

This script checks for required packages and installs any missing dependencies automatically.

Required packages include:

* build-essential
* gcc
* g++
* make
* perl
* wget
* curl
* git
* tar
* gzip
* zlib1g-dev
* libssl-dev


### 4. Install OpenSSL 1.1.1h

```bash
./install_openssl111h.sh
```

This downloads, builds, and installs OpenSSL 1.1.1h locally under:

```text
$HOME/openssl-1.1.1h-install
```

No system OpenSSL files are modified.


### 5. Configure Environment

```bash
./environment.sh
```

This configures:

```bash
LD_LIBRARY_PATH
```

and verifies that the correct OpenSSL libraries are loaded.


### 6. Generate Certificates

```bash
./generate_certs.sh
```

This generates:

* Root CA
* Mutant intermediate certificate
* Subleaf certificate

and stores them in:

```text
certs/
```

### 7. Build the Proof-of-Concept

```bash
./build.sh
./build_version3.sh
```

This compiles:

```text
src/poc.c
```

and produces:

```text
./poc
```

in the project root directory.


### 8. Run the Experiment

```bash
./run.sh
./run_version3.sh
```

or directly:

```bash
./poc
```


## Rebuilding from Scratch

To completely remove generated artifacts:

```bash
rm -rf certs
rm -f poc
```

To remove the local OpenSSL installation:

```bash
rm -rf $HOME/openssl-1.1.1h-install
rm -rf tls-test
```

To clear environment variables:

```bash
unset LD_LIBRARY_PATH
unset OPENSSL111H
```


