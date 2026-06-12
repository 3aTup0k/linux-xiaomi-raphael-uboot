#!/bin/bash
set -e

DEBIAN_VERSION="${DEBIAN_VERSION:-trixie}"
UBUNTU_VERSION="${UBUNTU_VERSION:-resolute}"
BOOT_IMG="${BOOT_IMG:-xiaomi-k20pro-boot.img}"
SYSTEM_TYPE="${SYSTEM_TYPE:-ubuntu-server}"
BOOTSTRAP_TOOL="${BOOTSTRAP_TOOL:-mmdebstrap}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02] 🚀 Installing base system"

if [[ "$SYSTEM_TYPE" == *"kali-"* ]]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02]   └─ Using $BOOTSTRAP_TOOL to build Kali $DEBIAN_VERSION 🐉"
    OS_VERSION="$DEBIAN_VERSION"
    MIRROR="http://http.kali.org/kali/"
elif [[ "$SYSTEM_TYPE" == *"debian-"* ]]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02]   └─ Using $BOOTSTRAP_TOOL to build Debian $DEBIAN_VERSION 🐧"
    OS_VERSION="$DEBIAN_VERSION"
    MIRROR="http://deb.debian.org/debian/"
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02]   └─ Using $BOOTSTRAP_TOOL to build Ubuntu $UBUNTU_VERSION 🦁"
    OS_VERSION="$UBUNTU_VERSION"
    MIRROR="http://ports.ubuntu.com/ubuntu-ports/"
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02]   └─ Starting bootstrap (this may take a few minutes...)"
if [ "$BOOTSTRAP_TOOL" = "mmdebstrap" ]; then
    mmdebstrap $OS_VERSION rootdir
elif [ "$BOOTSTRAP_TOOL" = "debootstrap" ]; then
    debootstrap $OS_VERSION rootdir $MIRROR
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02] ❌ Error: Unsupported build tool: $BOOTSTRAP_TOOL"
    exit 1
fi

if [ -f "${BOOT_IMG}" ]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02]   └─ Mounting boot partition (${BOOT_IMG}) 📁"
    if mount -o loop ${BOOT_IMG} rootdir/boot 2>&1; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02]   └─ Boot partition mounted successfully"
    else
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02] ❌ Error: Boot partition mounting failed"
        exit 1
    fi
else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02] ❌ Error: ${BOOT_IMG} does not exist"
    exit 1
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [02] ✅ Base system installation completed"
