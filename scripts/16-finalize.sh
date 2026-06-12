#!/bin/bash
set -e

IMAGE_NAME="${IMAGE_NAME:-rootfs.img}"
IMAGE_UUID="${IMAGE_UUID:-ee8d3593-59b1-480e-a3b6-4fefb17ee7d8}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [16] 📦 Unmounting and finalizing image"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [16]   └─ Unmounting mount points..."
umount rootdir/sys 2>/dev/null || true
umount rootdir/proc 2>/dev/null || true
umount rootdir/dev/pts 2>/dev/null || true
umount rootdir/dev 2>/dev/null || true
umount rootdir/boot 2>/dev/null || true
umount rootdir 2>/dev/null || true

rm -d rootdir 2>/dev/null || true

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [16]   └─ Setting image UUID: ${IMAGE_UUID}"
e2fsck -f -y ${IMAGE_NAME}
tune2fs -U ${IMAGE_UUID} ${IMAGE_NAME}

echo ""
echo "[$(date +'%Y-%m-%d %H:%M:%S')] [16]   └─ Legacy boot cmdline: root=PARTLABEL=userdata"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [16] ✅ Image finalized"
