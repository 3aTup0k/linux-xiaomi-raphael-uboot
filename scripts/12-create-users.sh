#!/bin/bash
set -e

ROOT_PASS="${ROOT_PASS:-1234}"
USER_NAME="${USER_NAME:-user}"
USER_PASS="${USER_PASS:-1234}"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [12] 👤 Creating users and configuring SSH"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [12]   └─ Creating user: ${USER_NAME}"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] [12]   └─ Enabling SSH password login"

echo "root:${ROOT_PASS}" | chroot rootdir chpasswd
chroot rootdir useradd -m -G sudo -s /bin/bash ${USER_NAME}
echo "${USER_NAME}:${USER_PASS}" | chroot rootdir chpasswd

echo "PermitRootLogin yes" >> rootdir/etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> rootdir/etc/ssh/sshd_config

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [12] ✅ User creation completed"
