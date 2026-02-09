# Xiaomi Raphael Device Linux System Image Build Project

This project provides build scripts and automated workflows for creating Debian/Ubuntu Linux system images for Xiaomi Raphael devices (Redmi K20 Pro), supporting both desktop and server versions.

## 📋 Project Overview

This project contains a complete build toolchain for creating Linux system images for Xiaomi Raphael devices, including:

- **Kernel compilation workflow** - Automated compilation of customized Linux kernels
- **Debian Desktop** - Debian system with Phosh desktop environment
- **Debian Server** - Debian server system without graphical interface
- **Ubuntu Desktop** - Ubuntu system with Phosh desktop environment
- **Ubuntu Server** - Ubuntu server system without graphical interface

## 📋 Current Status

- ✅ Wi-Fi (2.4GHz, 5GHz)
- ✅ Bluetooth (file transfer, audio)
- ✅ USB (SSH, OTG)
- ✅ Battery
- ✅ Real-time clock
- ✅ Display
- ✅ Touchscreen
- ✅ Flashlight (LED with adjustable intensity)
- ✅ GPU
- ✅ FDE

## 🚀 Quick Start

### Using GitHub Actions Automated Build

1. **Fork this repository** to your GitHub account

2. **Build the kernel**:
   - Go to the Actions page of the repository
   - Select the "Kernel Compilation" workflow
   - Click "Run workflow"
   - Enter the kernel version (e.g., `6.18`)
   - Wait for the build to complete; artifacts will be automatically released

3. **Build the system image**:
   - Select the "Build System Image" workflow
   - Click "Run workflow"
   - Choose the system type:
       - `debian-desktop`: Debian desktop edition
       - `debian-server`: Debian server edition
       - `ubuntu-desktop`: Ubuntu desktop edition
       - `ubuntu-server`: Ubuntu server edition
   - Kernel version:
       - `Kernel version from previous step`
   - Choose desktop environment (desktop versions only):
       - `phosh-core`: Basic Phosh environment
       - `phosh-full`: Complete Phosh environment
       - `phosh-phone`: Phone-optimized Phosh environment
   - Wait for the build to complete; the image will be automatically released

## 📦 Image Features

### General Features
- ✅ Tsinghua University software repository
- ✅ Simplified Chinese language environment
- ✅ China Standard Time zone
- ✅ NCM support (USB connection to computer, SSH example: `ssh user@172.16.42.1`)
- ✅ Pre-installed SSH server
- ✅ Allow root SSH login
- ✅ Includes necessary device drivers and firmware
- ✅ Default users: `user` (password: `1234`), `root` (password: `1234`)
- ✅ [One-click kernel update script](https://github.com/GengWei1997/kernel-deb)

### Desktop Edition Additional Features
- ✅ Phosh mobile desktop environment

### Server Edition Additional Features
- ✅ Network Manager
- ✅ Automatic screen off 15 seconds after boot
- ✅ Command line: `leijun` to turn off screen, `jinfan` to turn on screen

## 🔧 Installation on Device

### Preparation
1. **Unlock Bootloader**: Ensure the device bootloader is unlocked
2. **Install tools**: Install `fastboot` and `adb`

### Installation Steps

```bash
# 1. Enter Fastboot mode
adb reboot bootloader

# 2. Flash boot image
fastboot flash cache xiaomi-k20pro-boot.img
fastboot flash boot u-boot.img

# 3. Flash system image (need to extract rootfs.7z first)
fastboot flash userdata rootfs.img

# 4. Erase dtbo partition
fastboot erase dtbo

# 5. Reboot device
fastboot reboot
```

## ❓ Frequently Asked Questions (FAQ)

- How to connect to network on server version???
	- 1. OTG connection with Ethernet cable will be automatically recognized
	- 2. OTG connection with keyboard, enter `nmtui` to connect to Wi-Fi
	- 3. USB connection to computer after installing NCM driver, enter `nmtui` to connect to Wi-Fi

## 🙏 Acknowledgments

- Thanks to all Linux kernel developers for their hard work
- Thanks to Debian and Ubuntu communities
- Thanks to Phosh desktop environment development team
- Thanks to all contributors and users for their support
- [@cuicanmx](https://github.com/cuicanmx) - Providing help and innovative ideas
- [@map220v](https://github.com/map220v/ubuntu-xiaomi-nabu) - Original project
- [@Pc1598](https://github.com/Pc1598) - sm8150-mainline-raphael kernel maintenance
- [Aospa-raphael-unofficial/linux](https://github.com/Aospa-raphael-unofficial/linux) - Kernel project
- [sm8150-mainline/linux](https://gitlab.com/sm8150-mainline/linux) - Kernel project
