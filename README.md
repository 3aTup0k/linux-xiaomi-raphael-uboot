<div align="center">

# <img src="https://img.shields.io/badge/Device-Xiaomi_Raphael-FF6900?style=for-the-badge&logo=android&logoColor=white" alt="Device"/> <img src="https://img.shields.io/badge/Linux-Ubuntu|Debian-E95420?style=for-the-badge&logo=linux&logoColor=white" alt="Linux"/>

# 📱 Xiaomi Raphael Linux Image Build Project

### Redmi K20 Pro · One-click build for Debian / Ubuntu / Kali system images

[![Build](https://img.shields.io/github/actions/workflow/status/GengWei1997/linux-xiaomi-raphael-uboot/build-system.yml?style=flat-square&label=Build&logo=github-actions&logoColor=white)](https://github.com/GengWei1997/linux-xiaomi-raphael-uboot/actions)
[![Release](https://img.shields.io/github/v/release/GengWei1997/linux-xiaomi-raphael-uboot?style=flat-square&label=Release&logo=github&logoColor=white)](https://github.com/GengWei1997/linux-xiaomi-raphael-uboot/releases)
[![Stars](https://img.shields.io/github/stars/GengWei1997/linux-xiaomi-raphael-uboot?style=flat-square&logo=github&logoColor=white)](https://github.com/GengWei1997/linux-xiaomi-raphael-uboot/stargazers)

---

</div>

## ✨ Project Introduction

This project provides a comprehensive Linux image building solution for **Xiaomi Raphael (Redmi K20 Pro)**. It includes full build scripts and GitHub Actions automated workflows for Debian, Ubuntu, and Kali Linux. It supports multiple kernel versions and various desktop environments, providing an out-of-the-box experience.

## 📋 Supported System Types

| System ID | Desktop Environment | Distribution | Image Size |
|:---:|:---:|:---:|:---:|
| `debian-server` | None (CLI) | Debian trixie | 3G |
| `debian-gnome` | GNOME | Debian trixie | 6G |
| `debian-phosh` | Phosh Mobile | Debian trixie | 6G |
| `debian-xfce` | XFCE | Debian trixie | 6G |
| `debian-kde` | KDE Mobile | Debian trixie | 8G |
| `ubuntu-server` | None (CLI) | Ubuntu resolute | 3G |
| `ubuntu-gnome` | GNOME | Ubuntu resolute | 6G |
| `ubuntu-phosh` | Phosh Mobile | Ubuntu resolute | 6G |
| `ubuntu-xfce` | XFCE | Ubuntu resolute | 6G |
| `ubuntu-kde` | KDE Mobile | Ubuntu resolute | 8G |
| `kali-gnome` | GNOME | Kali rolling | 8G |
| `kali-phosh` | Phosh Mobile | Kali rolling | 8G |
| `kali-xfce` | XFCE | Kali rolling | 6G |
| `kali-kde` | KDE Mobile | Kali rolling | 8G |

## 🖥️ Hardware Adaptation

| Category | Item | Status |
|:---:|:---|:---:|
| 🌐 **Network** | 2.4G / 5G Dual-band Wi-Fi | ✅ |
| 📡 **Bluetooth** | File Transfer · Audio Output | ✅ |
| 📶 **Cellular** | Network Support | ❌ |
| 🔌 **USB** | NCM Network Sharing · OTG Function | ✅ |
| 🖥️ **Display** | Screen Output · GPU Rendering | ✅ |
| 🔊 **Audio** | Speaker · Headphone Output | ✅ |
| 👆 **Input** | Touchscreen · Flashlight | ✅ |
| 🔋 **System** | Battery Detection · RTC · FDE Encryption | ✅ |

## 🚀 Quick Start

### Option 1: Download Pre-built Images
Visit the [Releases](https://github.com/GengWei1997/linux-xiaomi-raphael-uboot/releases) page to download the latest images. No local compilation required.

> ⚠️ For images exceeding 2GB (e.g., `ubuntu-gnome`), please visit [Actions → Artifacts](https://github.com/GengWei1997/linux-xiaomi-raphael-uboot/actions).

### Option 2: Custom Build via GitHub Actions (Recommended)
1. **Fork** this repository to your personal GitHub account.
2. Go to the **Actions** page $\rightarrow$ Select the "Build system image" workflow.
3. Click **Run workflow** and customize the parameters:

| Parameter | Description | Default |
|:---:|:---|:---:|
| Build Mode | `parallel` for all / `single` for specific | `parallel` |
| System Type | Comma-separated list (e.g., `debian-gnome,ubuntu-server`) | All |
| Kernel Version | `6.18` or `7.0` | `7.0` |
| Build Tool | `mmdebstrap` / `debootstrap` | `mmdebstrap` |
| Phosh Variant | Only for Phosh images (`phosh-core`, `phosh-full`, `phosh-phone`) | `phosh-full` |

4. Wait for the build to complete; images will be automatically published to Releases.

## 📦 Image Features

### 🌐 General Features
- Default configuration using **Tsinghua University mirrors**.
- Pre-installed **English language pack** (`en_US.UTF-8`) and **Moscow Time zone** (`Europe/Moscow`).
- Support for **USB NCM network sharing**, allowing direct SSH connection from a PC.
- Built-in SSH server supporting root and ordinary user logins.
- Includes a **one-click kernel update script** for online upgrades.

| Account | Username | Password |
|:---:|:---:|:---:|
| Regular User | `user` | `1234` |
| Superuser | `root` | `1234` |

> 📌 When connected via USB NCM, device IP: `172.16.42.1`, SSH: `ssh user@172.16.42.1`

### 🎨 Desktop Edition Extras
- **GNOME / Phosh / XFCE / KDE Mobile** environments available to suit both desktop and mobile usage.

### 🖥️ Server Edition Extras
- Built-in Network Manager for wired, Wi-Fi, and USB connectivity.
- Automatic screen-off after 15 seconds of boot to reduce power consumption.
- Custom shortcuts: `leijun` to turn off the screen $\cdot$ `jinfan` to wake it up.

## ⬆️ Kernel Update
<details>
<summary><b>⚠️ For kernel debugging only; not recommended for general use</b></summary>

Execute with **root privileges**, then reboot the device.

| Mirror | Command |
|:---:|:---|
| 🌏 Accelerated | `sudo bash -c "$(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/GengWei1997/kernel-deb/refs/heads/main/ghproxy-Update-kernel.sh)"` |
| 🌐 Original | `sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/GengWei1997/kernel-deb/refs/heads/main/Update-kernel.sh)"` |

</details>

## 🔧 Installation Guide

### Prerequisites
- ✅ **Bootloader Unlocked**
- ✅ `adb` / `fastboot` tools installed on PC
- ✅ Downloaded image package and extracted:
  - `rootfs.img` — System image
  - `xiaomi-k20pro-boot.img` — Kernel image
  - [u-boot.img](https://github.com/GengWei1997/linux-xiaomi-raphael-uboot/releases/tag/v1.0.0) — U-Boot bootloader

### Flashing Commands
```bash
# 1. Enter Fastboot Mode
adb reboot bootloader

# 2. Erase Partitions
fastboot erase dtbo
fastboot erase boot
fastboot erase cache
fastboot erase userdata

# 3. Flash Images
fastboot flash cache xiaomi-k20pro-boot.img
fastboot flash boot u-boot.img
fastboot flash userdata rootfs.img

# 4. Reboot Device
fastboot reboot
```

## ❓ FAQ

| Question | Solution |
|:---|:---|
| Cellular network support | China Unicom / Telecom supported, China Mobile being fixed. |
| Windows cannot connect | Refer to [NCM Driver Tutorial](https://www.bilibili.com/video/BV1tW4y1A79V/) |
| How to connect server edition? | OTG Ethernet (auto) $\cdot$ OTG Keyboard (`nmtui` for Wi-Fi) $\cdot$ USB NCM (`nmtui`) |

---

## 🙏 Acknowledgements

Thanks to the following open-source projects and developers:

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/degdag">
        <img src="https://github.com/degdag.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>degdag</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/dabao1955">
        <img src="https://github.com/dabao1955.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>dabao1955</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/qaz6750">
        <img src="https://github.com/qaz6750.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>qaz6750</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/GavinLiuOnline">
        <img src="https://github.com/GavinLiuOnline.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>GavinLiuOnline</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/umeiko">
        <img src="https://github.com/umeiko.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>umeiko</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/yuweiyuan8">
        <img src="https://github.com/yuweiyuan8.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>yuweiyuan8</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/ccmx200">
        <img src="https://github.com/ccmx200.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>璀璨梦星</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/map220v">
        <img src="https://github.com/map220v.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>map220v</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Pc1598">
        <img src="https://github.com/Pc1598.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>Pc1598</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Aospa-raphael-unofficial/linux">
        <img src="https://github.com/Aospa-raphael-unofficial.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>Aospa-raphael</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/GengWei1997">
        <img src="https://github.com/GengWei1997.png" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>GengWei1997</b></sub>
      </a>
    <td align="center">
      <a href="https://gitlab.postmarketos.org/soc/qualcomm-sm8150/linux">
        <img src="https://avatars.githubusercontent.com/u/167286130?s=200&v=4" width="60" height="60" style="border-radius:50%"><br>
        <sub><b>sm8150-mainline</b></sub>
      </a>
    </td>
  </tr>
</table>

<p align="center">
  <i>Linux Kernel Official Dev Team · Debian / Ubuntu Open Source Community · Phosh Desktop Dev Team · and all other contributors</i>
</p>

<div align="center">

**If this project helps you, please give it a ⭐ Star!**

</div>
