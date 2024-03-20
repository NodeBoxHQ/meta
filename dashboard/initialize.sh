#!/bin/bash

sudo apt update && sudo apt install -y wget jq curl tmux

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
    /opt/nodebox-dashboard/nodebox-dashboard
else
    echo "No download URL found for architecture $ARCH"
fi