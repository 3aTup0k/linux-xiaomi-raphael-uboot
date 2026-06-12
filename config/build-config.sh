# System type configuration
SYSTEM_TYPES="
  debian-server
  debian-gnome
  debian-phosh
  debian-xfce
  debian-kde
  ubuntu-server
  ubuntu-gnome
  ubuntu-phosh
  ubuntu-xfce
  ubuntu-kde
  kali-server
  kali-gnome
  kali-phosh
  kali-xfce
  kali-kde
"

# Mapping from system type to base settings
system_config() {
  case "$1" in
    "debian-server")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-trixie}"
      echo "IMAGE_SIZE=3G"
      echo "IS_DESKTOP=false"
      echo "DESKTOP_ENV="
      ;;
    "debian-gnome")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-trixie}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=gnome"
      ;;
    "debian-phosh")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-trixie}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=$2"
      ;;
    "debian-xfce")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-trixie}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=xfce"
      ;;
    "debian-kde")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-trixie}"
      echo "IMAGE_SIZE=8G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=kde"
      ;;
    "ubuntu-server")
      echo "UBUNTU_VERSION=${UBUNTU_VERSION:-resolute}"
      echo "IMAGE_SIZE=3G"
      echo "IS_DESKTOP=false"
      echo "DESKTOP_ENV="
      ;;
    "ubuntu-gnome")
      echo "UBUNTU_VERSION=${UBUNTU_VERSION:-resolute}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=gnome"
      ;;
    "ubuntu-phosh")
      echo "UBUNTU_VERSION=${UBUNTU_VERSION:-resolute}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=$2"
      ;;
    "ubuntu-xfce")
      echo "UBUNTU_VERSION=${UBUNTU_VERSION:-resolute}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=xfce"
      ;;
    "ubuntu-kde")
      echo "UBUNTU_VERSION=${UBUNTU_VERSION:-resolute}"
      echo "IMAGE_SIZE=8G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=kde"
      ;;
    "kali-server")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-kali-rolling}"
      echo "IMAGE_SIZE=4G"
      echo "IS_DESKTOP=false"
      echo "DESKTOP_ENV="
      ;;
    "kali-gnome")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-kali-rolling}"
      echo "IMAGE_SIZE=8G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=gnome"
      ;;
    "kali-phosh")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-kali-rolling}"
      echo "IMAGE_SIZE=8G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=$2"
      ;;
    "kali-xfce")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-kali-rolling}"
      echo "IMAGE_SIZE=6G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=xfce"
      ;;
    "kali-kde")
      echo "DEBIAN_VERSION=${DEBIAN_VERSION:-kali-rolling}"
      echo "IMAGE_SIZE=8G"
      echo "IS_DESKTOP=true"
      echo "DESKTOP_ENV=kde"
      ;;
  esac
}

# Mirror configuration
sources_config() {
  if [[ "$1" == *"debian-"* ]]; then
    local version="${DEBIAN_VERSION:-trixie}"
    echo "DEBIAN_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/debian/"
    echo "DEBIAN_SECURITY_MIRROR=http://security.debian.org/debian-security"
  elif [[ "$1" == *"ubuntu-"* ]]; then
    local version="${UBUNTU_VERSION:-resolute}"
    echo "UBUNTU_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/"
    echo "UBUNTU_SECURITY_MIRROR=http://ports.ubuntu.com/ubuntu-ports/"
  elif [[ "$1" == *"kali-"* ]]; then
    echo "DEBIAN_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/kali/"
    echo "DEBIAN_SECURITY_MIRROR="
  fi
}

# Package configuration
get_packages() {
  local system_type="$1"
  local desktop_env="$2"

  base_packages="bash-completion sudo apt-utils ssh openssh-server nano network-manager systemd-boot initramfs-tools chrony curl wget locales tzdata dnsmasq iptables iproute2 zram-tools"

  # Kali-specific handling
  if [[ "$system_type" == *"kali-"* ]]; then
    if [[ "$system_type" == *"server"* ]]; then
      echo "$base_packages kali-linux-headless"
    else
      case "$desktop_env" in
        "gnome")
          echo "$base_packages kali-desktop-gnome gdm3"
          ;;
        "phosh-core"|"phosh-full"|"phosh-phone")
          echo "$base_packages phosh phoc squeekboard gnome-settings-daemon gnome-control-center"
          ;;
        "xfce")
          echo "$base_packages kali-desktop-xfce lightdm"
          ;;
        "kde")
          echo "$base_packages kali-desktop-kde sddm"
          ;;
        *)
          echo "$base_packages kali-linux-headless"
          ;;
      esac
    fi
    return
  fi

  if [[ "$system_type" == *"server"* ]]; then
    echo "$base_packages"
  else
    case "$desktop_env" in
      "gnome")
        echo "$base_packages gnome gnome-terminal gdm3"
        ;;
      "phosh-core")
        if [[ "$system_type" == *"ubuntu-"* ]]; then
          echo "$base_packages phosh phoc onboard"
        elif [[ "$system_type" == *"debian-"* ]]; then
          echo "$base_packages phosh phoc squeekboard"
        fi
        ;;
      "phosh-full")
        if [[ "$system_type" == *"ubuntu-"* ]]; then
          echo "$base_packages phosh phoc onboard gnome-settings-daemon gnome-control-center"
        elif [[ "$system_type" == *"debian-"* ]]; then
          echo "$base_packages phosh phoc squeekboard gnome-settings-daemon gnome-control-center"
        fi
        ;;
      "phosh-phone")
        echo "$base_packages phosh phoc squeekboard gnome-settings-daemon gnome-control-center ofono mobian-tweaks"
        ;;
      "xfce")
        echo "$base_packages xfce4 xfce4-goodies xfce4-terminal lightdm"
        ;;
      "kde")
        echo "$base_packages plasma-mobile sddm"
        ;;
      *)
        echo "$base_packages"
        ;;
    esac
  fi
}
