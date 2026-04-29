#!/bin/bash
set -e

KERNEL_VERSION="${1:-6.18}"
REPO="${2:-${{ github.repository }}}"

echo "Downloading kernel packages and boot.img"
echo "Kernel version: $KERNEL_VERSION"
echo "Repository: $REPO"

mkdir -p xiaomi-raphael-debs_$KERNEL_VERSION

echo "Downloading kernel packages..."
curl -sL -o xiaomi-raphael-debs_$KERNEL_VERSION/linux-image-xiaomi-raphael.deb \
    "https://github.com/$REPO/releases/download/kernel-v$KERNEL_VERSION/linux-image-xiaomi-raphael.deb"

curl -sL -o xiaomi-raphael-debs_$KERNEL_VERSION/linux-headers-xiaomi-raphael.deb \
    "https://github.com/$REPO/releases/download/kernel-v$KERNEL_VERSION/linux-headers-xiaomi-raphael.deb"

curl -sL -o xiaomi-raphael-debs_$KERNEL_VERSION/firmware-xiaomi-raphael.deb \
    "https://github.com/$REPO/releases/download/kernel-v$KERNEL_VERSION/firmware-xiaomi-raphael.deb"

echo "Downloading boot.img..."
curl -sL -o xiaomi-k20pro-boot.img \
    "https://github.com/GengWei1997/kernel-deb/releases/download/v1.0.0/xiaomi-k20pro-boot.img"

echo ""
echo "Download completed!"
echo ""
ls -lh xiaomi-raphael-debs_$KERNEL_VERSION/
ls -lh xiaomi-k20pro-boot.img
