# Xiaomi Raphael Linux System Image Building Project

This project provides build scripts and automated workflows for Debian/Ubuntu Linux system images for Xiaomi Raphael devices (Redmi K20 Pro), supporting both desktop environments and server editions.

## 📋 Project Overview

This project includes a complete build toolchain to create Linux system images for Xiaomi Raphael devices, including:

- **Kernel Compilation Workflow** - Automates the compilation of a custom Linux kernel
- **Debian GNOME** - Debian with GNOME desktop environment
- **Debian Phosh** - Debian with Phosh desktop environment
- **Debian XFCE** - Debian with XFCE desktop environment
- **Debian KDE Mobile** - Debian with KDE Mobile environment
- **Debian Server** - Debian server without a graphical interface
- **Ubuntu GNOME** - Ubuntu with GNOME desktop environment
- **Ubuntu Phosh** - Ubuntu with Phosh desktop environment
- **Ubuntu XFCE** - Ubuntu with XFCE desktop environment
- **Ubuntu KDE Mobile** - Ubuntu with KDE Mobile environment
- **Ubuntu Server** - Ubuntu server without a graphical interface

## 📋 Current Status

- ✅ Wi-Fi (2.4 GHz, 5 GHz)
- ✅ Bluetooth (file transfer, audio)
- ✅ USB (SSH, OTG)
- ✅ Battery
- ✅ Real-time clock
- ✅ Display
- ✅ Touch
- ✅ Flashlight (LED & intensity control)
- ✅ GPU
- ✅ FDE (Full Disk Encryption)

## 🚀 Quick Start

### Using GitHub Actions for Automated Builds

1. **Fork this repository** to your GitHub account

2. **Build the kernel**:
   - Go to the Actions page of your repository
   - Select the "Kernel compilation" workflow
   - Click "Run workflow"
   - Enter the kernel version (e.g., `6.18`)
   - Wait for the build to finish; the artifacts will be automatically published to Releases

3. **Build a system image**:
   - Select the "Build system image" workflow
   - Click "Run workflow"
   - Choose the system type:
       - `debian-gnome` — Debian GNOME edition
       - `debian-phosh` — Debian Phosh edition
       - `debian-xfce` — Debian XFCE edition
       - `debian-kde` — Debian KDE Mobile edition
       - `debian-server` — Debian server edition
       - `ubuntu-gnome` — Ubuntu GNOME edition
       - `ubuntu-phosh` — Ubuntu Phosh edition
       - `ubuntu-xfce` — Ubuntu XFCE edition
       - `ubuntu-kde` — Ubuntu KDE Mobile edition
       - `ubuntu-server` — Ubuntu server edition
   - Kernel version:
       - `the kernel version from the previous step`
   - Choose a desktop environment (only for Phosh editions; not needed for others):
       - `phosh-core` — basic Phosh environment
       - `phosh-full` — full Phosh environment
       - `phosh-phone` — phone-optimized Phosh environment
   - Wait for the build to finish; the image will be automatically published to Releases

## 📦 Image Features

### Common Features
- ✅ Tsinghua University mirror for package sources
- ✅ English locale (en_US.UTF-8)
- ✅ Moscow Time zone (Europe/Moscow)
- ✅ NCM support (USB connection to PC, SSH example: `ssh user@172.16.42.1`)
- ✅ Preinstalled SSH server
- ✅ Root SSH login enabled
- ✅ Includes necessary device drivers and firmware
- ✅ Default users: `user` (password: `1234`), `root` (password: `1234`)
- ✅ [One-click kernel update script](https://github.com/GengWei1997/kernel-deb)

### Additional Desktop Features
- ✅ GNOME desktop environment (power button does not turn off screen)
- ✅ Phosh mobile desktop environment
- ✅ XFCE desktop environment
- ✅ KDE Mobile desktop environment

### Additional Server Features
- ✅ Network Manager
- ✅ Automatic screen off 15 seconds after boot
- ✅ Command line: type `leijun` to turn off the screen, `jinfan` to turn it on

## 🔧 Flashing to the Device

### Prerequisites
1. **Unlock Bootloader**: Make sure the device bootloader is unlocked.
2. **Install tools**: Install `fastboot` and `adb`.

### Flashing Steps

```bash
# 1. Enter Fastboot mode
adb reboot bootloader

# 2. Erase partitions
fastboot erase dtbo
fastboot erase boot
fastboot erase cache
fastboot erase userdata

# 3. Flash boot images
fastboot flash cache xiaomi-k20pro-boot.img
fastboot flash boot u-boot.img

# 4. Flash the system image (first extract rootfs.7z)
fastboot flash userdata rootfs.img

# 5. Reboot the device
fastboot reboot
```

## ❓ Frequently Asked Questions (FAQ)

- [How to fix CDC NCM driver issues on Windows](https://www.bilibili.com/video/BV1tW4y1A79V/)

- How to connect to a network on the server edition?
	- 1. Connect an Ethernet cable via OTG – the system will recognize it automatically.
	- 2. Connect a keyboard via OTG, then run `nmtui` to connect to Wi-Fi.
	- 3. Connect the device to a PC via USB, install the NCM driver, then run `nmtui` to connect to Wi-Fi.

## 🙏 Acknowledgements

- Thanks to all Linux kernel developers for their hard work
- Thanks to the Debian and Ubuntu communities
- Thanks to the Phosh desktop environment development team
- Thanks to all contributors and users for their support
- [@璀璨梦星](https://github.com/ccmx200) – for help and innovative ideas
- [@map220v](https://github.com/map220v/ubuntu-xiaomi-nabu) – original project
- [@Pc1598](https://github.com/Pc1598) – sm8150-mainline-raphael kernel maintenance
- [Aospa-raphael-unofficial/linux](https://github.com/Aospa-raphael-unofficial/linux) – kernel project
- [sm8150-mainline/linux](https://gitlab.com/sm8150-mainline/linux) – kernel project
- 
