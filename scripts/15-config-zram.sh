#!/bin/bash
set -e

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [14] 🧠 Configuring ZRAM swap"

if [ ! -f rootdir/etc/default/zramswap ]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [14]   └─ /etc/default/zramswap not found, skipping"
    exit 0
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [14]   └─ Tuning zramswap parameters"
sed -i \
    -e 's/^ALGO=.*/ALGO=zstd/' \
    -e 's/^PERCENT=.*/# &/' \
    -e 's/^SIZE=.*/SIZE=10240/' \
    rootdir/etc/default/zramswap

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [14]   └─ Enabling zramswap service"
chroot rootdir systemctl enable zramswap

echo ""
echo "[/etc/default/zramswap]"
cat rootdir/etc/default/zramswap

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [14] ✅ ZRAM configuration completed"
