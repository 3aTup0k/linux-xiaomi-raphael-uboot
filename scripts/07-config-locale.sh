#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

. "$CONFIG_DIR/build-config.sh"

SYSTEM_TYPE="${SYSTEM_TYPE:-ubuntu-server}"
DESKTOP_ENV="${DESKTOP_ENV:-}"
DEBIAN_VERSION="${DEBIAN_VERSION:-trixie}"
UBUNTU_VERSION="${UBUNTU_VERSION:-resolute}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [07] 🌍 Configuring timezone and language"

# Set timezone
echo "Europe/Moscow" > rootdir/etc/timezone
chroot rootdir ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Install basic locale packages
if [[ "$SYSTEM_TYPE" == *"ubuntu-"* ]]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [07]   └─ Installing Ubuntu locale packages"
    chroot rootdir apt-get update
    chroot rootdir apt-get install -y language-pack-en
elif [[ "$SYSTEM_TYPE" == *"debian-"* ]]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [07]   └─ Installing Debian locale packages"
    chroot rootdir apt-get update
    chroot rootdir apt-get install -y locales locales-all tzdata
fi

# Configure locale environment
cat > rootdir/etc/locale.gen << 'EOF'
en_US.UTF-8 UTF-8
EOF
chroot rootdir locale-gen en_US.UTF-8
chroot rootdir update-locale LANG=en_US.UTF-8 LANGUAGE=en_US

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [07] ✅ Timezone and language configuration completed"
