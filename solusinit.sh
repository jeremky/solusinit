#!/bin/bash

# Colored messages
error() { echo -e "\033[0;31m❯ $*\033[0m"; }
message() { echo -e "\033[0;36m──────────\033[0m\n\033[0;32m❯ $*\033[0m"; }
warning() { echo -e "\033[0;33m❯ $*\033[0m\n\033[0;36m──────────\033[0m"; }

# Check OS
if ! command -v eopkg >/dev/null; then
  error "This script requires eopkg (Solus)"
  exit 1
fi

# Check root privileges
if [[ "$EUID" -ne 0 ]]; then
  error "Root privileges required"
  exit 1
fi

# Functions
install_packages() {
  warning "Updating packages"
  eopkg -y upgrade || {
    error "Error while updating packages"
    return 1
  }
  echo
  if [[ -f "$list" ]]; then
    warning "Installing packages"
    grep -v -e '#' -e '^$' "$list" | xargs -r eopkg -y install || {
      error "Error while installing packages"
      return 1
    }
    message "Package installation complete"
    echo
  fi
}

install_flatpaks() {
  if [[ -f "$apps" ]]; then
    warning "Installing flatpaks"
    grep -v -e '#' -e '^$' "$apps" | xargs -r flatpak install -y --system flathub || {
      error "Error while installing flatpaks"
      return 1
    }
    message "Flatpak installation complete"
    echo
  fi
}

install_herdr() {
  warning "Installing herdr"
  user=$(id -un 1000)
  (sudo -u "$user" -H sh -c 'curl -fsSL https://herdr.dev/install.sh | sh') || {
    error "Error while installing herdr"
    return 1
  }
  message "herdr installation complete"
  echo
}

install_claude() {
  warning "Installing claude"
  user=$(id -un 1000)
  (sudo -u "$user" -H bash -c 'curl -fsSL https://claude.ai/install.sh | bash') || {
    error "Error while installing claude"
    return 1
  }
  message "claude installation complete"
  echo
}

install_geforcenow() {
  warning "Installing GeForce NOW"
  flatpak remote-add --system --if-not-exists GeForceNOW https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo
  flatpak install -y --system flathub org.freedesktop.Platform/x86_64/24.08 || {
    error "Error while installing the Freedesktop platform"
    return 1
  }
  flatpak install -y --system GeForceNOW com.nvidia.geforcenow || {
    error "Error while installing GeForce NOW"
    return 1
  }
  message "GeForce NOW installation complete"
  echo
}

install_hytale() {
  warning "Installing Hytale"
  (cd /tmp && wget https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak) || {
    error "Error while downloading Hytale"
    return 1
  }
  flatpak --system install -y /tmp/hytale-launcher-latest.flatpak || {
    error "Error while installing Hytale"
    return 1
  }
  message "Hytale installation complete"
  echo
}

configure_sshd() {
  if [[ ! -d /etc/ssh/sshd_config.d ]]; then
    error "SSH is not installed"
    return 1
  fi
  warning "Securing SSH"
  user=$(id -un 1000)
  tee "/etc/ssh/sshd_config.d/$user.conf" <<EOF
# Secure Config
X11Forwarding no
AllowUsers $user
HostKey /etc/ssh/ssh_host_ed25519_key
PasswordAuthentication no
KbdInteractiveAuthentication no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
KexAlgorithms sntrup761x25519-sha512,mlkem768x25519-sha256,curve25519-sha256,curve25519-sha256@libssh.org
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
Ciphers aes256-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-gcm@openssh.com,aes128-ctr
EOF
  systemctl restart sshd || {
    error "Error while restarting SSH"
    exit 1
  }
  message "SSH secured"
  echo
}

# Execution
dir="$(dirname "$0")/config"
cfg="$dir/config.cfg"
list="$dir/packages.cfg"
apps="$dir/flatpaks.cfg"
if [[ ! -f "$cfg" ]] || [[ ! -f "$list" ]]; then
  error "File $cfg or $list not found"
  exit 1
fi
echo
while read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  if declare -f "$line" >/dev/null; then
    "$line"
  else
    error "No function matches parameter $line"
    exit 1
  fi
done <"$cfg"
