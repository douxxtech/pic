#!/bin/bash

# Installs bore (ekzhang/bore) from GitHub releases
# https://github.com/ekzhang/bore

set -e

INSTALL_DIR="/usr/local/bin"

# detect arch
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ARCH_SLUG="x86_64-unknown-linux-musl" ;;
    aarch64) ARCH_SLUG="aarch64-unknown-linux-musl" ;;
    armv7l)  ARCH_SLUG="armv7-unknown-linux-musleabihf" ;;
    *)       echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

# get latest version tag
LATEST=$(curl -fsSL "https://api.github.com/repos/ekzhang/bore/releases/latest" \
    | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\(.*\)".*/\1/')

[ -z "$LATEST" ] && echo "Could not fetch latest version." && exit 1

echo "Installing bore $LATEST..."

# download & extract
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -fsSL "https://github.com/ekzhang/bore/releases/download/$LATEST/bore-${LATEST}-${ARCH_SLUG}.tar.gz" \
    | tar -xz -C "$TMP"

# install
if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP/bore" "$INSTALL_DIR/bore"
else
    sudo mv "$TMP/bore" "$INSTALL_DIR/bore"
fi

echo "Done! $(bore --version)"