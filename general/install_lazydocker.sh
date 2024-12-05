#!/bin/bash

DIR="${DIR:-"$HOME/.local/bin"}"

# map different architecture variations to the available binaries
ARCH=$(uname -m)
case $ARCH in
    i386|i686) ARCH=x86 ;;
    armv6*) ARCH=armv6 ;;
    armv7*) ARCH=armv7 ;;
    aarch64*) ARCH=arm64 ;;
esac

GITHUB_LATEST_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/jesseduffield/lazydocker/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
GITHUB_FILE="lazydocker_${GITHUB_LATEST_VERSION//v/}_$(uname -s)_${ARCH}.tar.gz"
GITHUB_URL="https://github.com/jesseduffield/lazydocker/releases/download/${GITHUB_LATEST_VERSION}/${GITHUB_FILE}"

# install or update the local binary
curl -L -o lazydocker.tar.gz $GITHUB_URL
tar xzvf lazydocker.tar.gz lazydocker
install -Dm 755 lazydocker -t "$DIR"
rm lazydocker lazydocker.tar.gz

# check and make sure if the local/bin is in PATH 
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Adding $HOME/.local/bin to PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

# print if success and instruction if success
echo "Installation complete. Run 'lazydocker' to start."
echo "If 'lazydocker' is not recognized, reload your shell with 'source ~/.bashrc'."
