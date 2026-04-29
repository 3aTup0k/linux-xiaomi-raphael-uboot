#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../config"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [08] 🖥️ Adding screen management commands"

# Add screen management commands to global bash configuration
cat >> rootdir/etc/bash.bashrc << 'EOF'
# Screen management commands
leijun() {
    if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
        sudo sh -c 'TERM=linux setterm --blank force </dev/tty1'
    else
        setterm --blank force --term linux </dev/tty1
    fi
    echo "Screen turned off"
}

jinfan() {
    if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
        sudo sh -c 'TERM=linux setterm --blank poke </dev/tty1'
    else
        setterm --blank poke --term linux </dev/tty1
    fi
    echo "Screen turned on"
}
EOF

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [08]   └─ Screen management commands added"

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

echo "[$(date +'%Y-%m-%d %H:%M:%S')] [08]   └─ Auto-blank screen service enabled"
