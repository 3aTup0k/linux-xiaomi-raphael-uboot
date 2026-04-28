#!/bin/sh
set -e  # Exit immediately on error

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "rootfs can only be built as root"
  exit 1
fi

# Script arguments:
# $1 - kernel version (e.g. 6.18)
# $2 - language pack scope (full | minimum)
# $3 - timezone (e.g. Europe/Moscow)
# $4 - hostname (e.g. raphael)

KERNEL_VERSION="$1"
LANGUAGE_PACK="${2:-full}"
TIMEZONE="${3:-Europe/Moscow}"
HOSTNAME="${4:-raphael}"

DEBIAN_VERSION="trixie"

# Create root filesystem image
truncate -s 6G rootfs.img
mkfs.ext4 rootfs.img
mkdir rootdir
mount -o loop rootfs.img rootdir

# Bootstrap Debian base system
debootstrap --arch=arm64 "$DEBIAN_VERSION" rootdir https://mirrors.tuna.tsinghua.edu.cn/debian/

# Mount boot image
mount -o loop xiaomi-k20pro-boot.img rootdir/boot

# Bind system directories
mount --bind /dev rootdir/dev
mount --bind /dev/pts rootdir/dev/pts
mount --bind /proc rootdir/proc
mount --bind /sys rootdir/sys

# Configure network and hostname
echo "nameserver 1.1.1.1" | tee rootdir/etc/resolv.conf
echo "$HOSTNAME" | tee rootdir/etc/hostname
echo "127.0.0.1 localhost
127.0.1.1 $HOSTNAME" | tee rootdir/etc/hosts

# Set up chroot environment
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\$PATH
export DEBIAN_FRONTEND=noninteractive

# Configure Tsinghua mirror
cat > rootdir/etc/apt/sources.list << EOF
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-backports main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF

# Update and upgrade base system
chroot rootdir apt update
chroot rootdir apt upgrade -y

# Install base packages and GNOME desktop
chroot rootdir apt install -y bash-completion sudo apt-utils ssh openssh-server nano systemd-boot initramfs-tools chrony curl wget dnsmasq iptables iproute2 gnome

# Install device-specific packages
chroot rootdir apt install -y rmtfs protection-domain-mapper tqftpserv

# Language and locale setup
if [ "$LANGUAGE_PACK" = "full" ]; then
  chroot rootdir apt install -y locales-all
  # Generate all locales
  chroot rootdir locale-gen
else
  # Minimum set: US English and Russian
  chroot rootdir apt install -y locales
  echo "en_US.UTF-8 UTF-8" > rootdir/etc/locale.gen
  echo "ru_RU.UTF-8 UTF-8" >> rootdir/etc/locale.gen
  chroot rootdir locale-gen
fi
# Set default locale to US English (neutral)
chroot rootdir update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en

# Timezone configuration
echo "$TIMEZONE" | tee rootdir/etc/timezone
chroot rootdir ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
chroot rootdir dpkg-reconfigure -f noninteractive tzdata

# Fix pd-mapper service
sed -i '/ConditionKernelVersion/d' rootdir/lib/systemd/system/pd-mapper.service

# Install kernel packages (pre-downloaded)
cp "xiaomi-raphael-debs_${KERNEL_VERSION}/"*"-xiaomi-raphael.deb" rootdir/tmp/
chroot rootdir dpkg -i /tmp/linux-image-xiaomi-raphael.deb
chroot rootdir dpkg -i /tmp/linux-headers-xiaomi-raphael.deb
chroot rootdir dpkg -i /tmp/firmware-xiaomi-raphael.deb
chroot rootdir dpkg -i /tmp/alsa-xiaomi-raphael.deb
rm rootdir/tmp/*-xiaomi-raphael.deb
chroot rootdir update-initramfs -c -k all

# Configure CDC NCM (USB networking)
cat > rootdir/etc/dnsmasq.d/usb-ncm.conf << 'EOF'
interface=usb0
bind-dynamic
port=0
dhcp-authoritative
dhcp-range=172.16.42.2,172.16.42.254,255.255.255.0,1h
dhcp-option=3,172.16.42.1
EOF
echo "net.ipv4.ip_forward=1" | tee rootdir/etc/sysctl.d/99-usb-ncm.conf
chroot rootdir systemctl enable dnsmasq

cat > rootdir/usr/local/sbin/setup-usb-ncm.sh << EOF
#!/bin/sh
set -e
modprobe libcomposite
mountpoint -q /sys/kernel/config || mount -t configfs none /sys/kernel/config
G=/sys/kernel/config/usb_gadget/g1
mkdir -p \$G
echo 0x1d6b > \$G/idVendor
echo 0x0104 > \$G/idProduct
echo 0x0200 > \$G/bcdUSB
mkdir -p \$G/strings/0x409
echo $HOSTNAME > \$G/strings/0x409/manufacturer
echo NCM > \$G/strings/0x409/product
echo \$(cat /etc/machine-id) > \$G/strings/0x409/serialnumber
mkdir -p \$G/configs/c.1
mkdir -p \$G/configs/c.1/strings/0x409
echo NCM > \$G/configs/c.1/strings/0x409/configuration
mkdir -p \$G/functions/ncm.usb0
ln -sf \$G/functions/ncm.usb0 \$G/configs/c.1/
UDC=\$(ls /sys/class/udc | head -n 1)
echo \$UDC > \$G/UDC
ip link set usb0 up
ip addr add 172.16.42.1/24 dev usb0 || true
OUT=\$(ip route get 1.1.1.1 | awk '{print \$5; exit}')
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -C POSTROUTING -o \$OUT -j MASQUERADE || iptables -t nat -A POSTROUTING -o \$OUT -j MASQUERADE
iptables -C FORWARD -i \$OUT -o usb0 -m state --state RELATED,ESTABLISHED -j ACCEPT || iptables -A FORWARD -i \$OUT -o usb0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -C FORWARD -i usb0 -o \$OUT -j ACCEPT || iptables -A FORWARD -i usb0 -o \$OUT -j ACCEPT
systemctl restart dnsmasq || true
EOF
chmod +x rootdir/usr/local/sbin/setup-usb-ncm.sh

cat > rootdir/etc/systemd/system/usb-ncm.service << 'EOF'
[Unit]
Description=USB CDC-NCM gadget setup
After=network.target
DefaultDependencies=no

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/setup-usb-ncm.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
chroot rootdir systemctl enable usb-ncm

# Configure fstab
echo "PARTLABEL=userdata / ext4 errors=remount-ro,x-systemd.growfs 0 1
PARTLABEL=cache /boot vfat umask=0077 0 1" | tee rootdir/etc/fstab

# Create default users
echo "root:1234" | chroot rootdir chpasswd
chroot rootdir useradd -m -G sudo -s /bin/bash user
echo "user:1234" | chroot rootdir chpasswd

# Allow SSH root login
echo "PermitRootLogin yes" | tee -a rootdir/etc/ssh/sshd_config
echo "PasswordAuthentication yes" | tee -a rootdir/etc/ssh/sshd_config

# Disable system suspend/hibernate
chroot rootdir systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Clean apt cache
chroot rootdir apt clean

# Rename boot files
mv rootdir/boot/initrd.img-* rootdir/boot/initramfs
mv rootdir/boot/vmlinuz-* rootdir/boot/linux.efi

# Remove Wi-Fi regulatory certificates (optional)
rm -f rootdir/lib/firmware/reg*

# Unmount everything in reverse order
umount rootdir/sys
umount rootdir/proc
umount rootdir/dev/pts
umount rootdir/dev
umount rootdir/boot
umount rootdir

rm -d rootdir

# Set filesystem UUID
tune2fs -U ee8d3593-59b1-480e-a3b6-4fefb17ee7d8 rootfs.img

echo 'cmdline for legacy boot: "root=PARTLABEL=userdata"'

# Compress rootfs image
7z a rootfs.7z rootfs.img
