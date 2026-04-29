#!/bin/bash
set -e

HOSTNAME="${HOSTNAME:-raphael}"
NAMESERVER="${NAMESERVER:-1.1.1.1}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [04] 🌐 Configuring network and hostname"

rm -f rootdir/etc/resolv.conf
touch rootdir/etc/resolv.conf

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [04]   └─ Hostname: ${HOSTNAME}"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] [04]   └─ DNS: ${NAMESERVER}"

echo "nameserver ${NAMESERVER}" > rootdir/etc/resolv.conf
echo "${HOSTNAME}" > rootdir/etc/hostname
echo "127.0.0.1 localhost
127.0.1.1 ${HOSTNAME}" > rootdir/etc/hosts

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [04] ✅ Network configuration completed"
