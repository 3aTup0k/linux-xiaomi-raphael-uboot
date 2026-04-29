#!/bin/bash
set -e

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [03] 🔗 Bind mounting system directories"

mount --bind /dev rootdir/dev
mount --bind /dev/pts rootdir/dev/pts
mount --bind /proc rootdir/proc
mount --bind /sys rootdir/sys

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [03] ✅ System directories mounted"
