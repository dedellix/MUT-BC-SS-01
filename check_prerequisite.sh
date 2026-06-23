```bash
#!/bin/bash

set -e

echo "========================================"
echo " MUT-BC-SS-01 Prerequisite Checker"
echo "========================================"

PACKAGES=(
    build-essential
    gcc
    g++
    make
    perl
    wget
    curl
    git
    tar
    gzip
    zlib1g-dev
    libssl-dev
)

MISSING=()

echo
echo "[*] Checking required packages..."
echo

for pkg in "${PACKAGES[@]}"
do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "[OK] $pkg"
    else
        echo "[MISSING] $pkg"
        MISSING+=("$pkg")
    fi
done

echo

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "All required packages are already installed."
    exit 0
fi

echo "The following packages are missing:"
printf ' - %s\n' "${MISSING[@]}"

echo
read -p "Install missing packages now? [Y/n] " answer

if [[ "$answer" =~ ^[Nn]$ ]]; then
    echo "Installation cancelled."
    exit 1
fi

echo
echo "[*] Updating package lists..."
sudo apt update

echo
echo "[*] Installing missing packages..."
sudo apt install -y "${MISSING[@]}"

echo
echo "========================================"
echo " Prerequisites successfully installed"
echo "========================================"
```

