#!/bin/bash
set -e

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [13] 🔋 Configuring power management and screen blanking"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [13]   └─ Disabling sleep/suspend targets"
chroot rootdir systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Configure NetworkManager only for Ubuntu builds
if [[ "$SYSTEM_TYPE" == *"ubuntu-"* ]]; then 
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [13]   └─ Configuring NetworkManager"
    cat > rootdir/etc/netplan/01-network-manager-all.yaml << 'EOF'
network:
  version: 2
  renderer: NetworkManager
EOF
fi


# Configure Systemd service to auto-blank screen after 15 seconds of boot
cat > rootdir/etc/systemd/system/blank_screen.service << 'EOF'
[Unit]
Description=Auto-blank screen after 15s
After=multi-user.target

[Service]
Type=simple
ExecStartPre=/bin/bash -c "/usr/bin/sleep 15"
ExecStart=sh -c 'TERM=linux setterm --blank force </dev/tty1'
User=root
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
chroot rootdir systemctl enable blank_screen.service


echo "[$(date +'%Y-%m-%d %H:%M:%S')] [13] ✅ Power management configuration completed"

