#!/bin/bash

install_package() {
    if [[ $(id -u) -ne 0 ]]; then
        if command -v sudo >/dev/null 2>&1; then
            sudo apt install -y "$1"
        else
            echo "sudo is not installed, please install sudo or run as root." >&2
            exit 1
        fi
    else
        apt install -y "$1"
    fi
}

for pkg in wget jq curl tmux; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        install_package "$pkg"
    fi
done

if [[ $(id -u) -ne 0 ]]; then
    sudo apt update
else
    apt update
fi

ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="x86_64";;
    aarch64) ARCH="aarch64";;
    *) echo "Architecture $ARCH not supported" >&2; exit 1;;
esac

LATEST_RELEASE=$(curl -s https://api.github.com/repos/NodeBoxHQ/node-dashboard/releases/latest)
TAG_NAME=$(echo "$LATEST_RELEASE" | jq -r '.tag_name')
DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | jq -r --arg ARCH "$ARCH" '.assets[] | select(.name | contains($ARCH)) | .browser_download_url')

if [[ -n "$DOWNLOAD_URL" ]]; then
    echo "Latest version: $TAG_NAME"
    echo "Download URL: $DOWNLOAD_URL"
    mkdir -p /opt/nodebox-dashboard
    wget "$DOWNLOAD_URL" -O "/opt/nodebox-dashboard/nodebox-dashboard"
    chmod +x "/opt/nodebox-dashboard/nodebox-dashboard"
    if [[ $(id -u) -ne 0 ]]; then
        sudo /opt/nodebox-dashboard/nodebox-dashboard
    else
        /opt/nodebox-dashboard/nodebox-dashboard
    fi
else
    echo "No download URL found for architecture $ARCH"
fi
