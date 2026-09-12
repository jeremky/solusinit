#!/bin/bash

# Messages en couleur
error() { echo -e "\033[0;31m❯ $*\033[0m"; }
message() { echo -e "\033[0;36m──────────\033[0m\n\033[0;32m❯ $*\033[0m"; }
warning() { echo -e "\033[0;33m❯ $*\033[0m\n\033[0;36m──────────\033[0m"; }

# Vérification de l'OS :
if ! command -v eopkg >/dev/null; then
  error "Ce script nécessite eopkg (Solus)"
  exit 1
fi

# Vérification des droits root
if [[ "$EUID" -ne 0 ]]; then
  error "Droits root nécessaires"
  exit 1
fi

# Fonctions
install_packages() {
  warning "Mise à jour des paquets"
  eopkg -y upgrade || { error "Problème lors de la mise à jour des paquets"; }
  echo
  if [[ -f "$list" ]]; then
    warning "Installation des paquets"
    grep -v -e '#' -e '^$' "$list" | xargs eopkg -y install || {
      error "Problème lors de l'installation des paquets"
    }
    message "Installation des paquets terminée"
    echo
  fi
}

install_geforcenow() {
  warning "Installation de GeforceNow"
  sudo flatpak remote-add --system --if-not-exists GeForceNOW https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo
  sudo flatpak install flathub org.freedesktop.Platform/x86_64/24.08
  sudo flatpak install --system GeForceNOW com.nvidia.geforcenow
  message "Installation de GeforceNow terminée"
  echo
}

install_hytale() {
  warning "Installation de Hytale"
  (cd /tmp && wget https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak)
  flatpak --system install /tmp/hytale-launcher-latest.flatpak
  message "Installation de Hytale terminée"
  echo
}

# Exécution
dir="$(dirname "$0")/config"
cfg="$dir/config.cfg"
list="$dir/packages.cfg"
if [[ ! -f "$cfg" ]] || [[ ! -f "$list" ]]; then
  error "Fichier $cfg ou $list introuvable"
  exit 1
fi
echo
while read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  if declare -f "$line" >/dev/null; then
    "$line"
  else
    error "Aucune fonction ne correspond au paramètre $line"
    exit 1
  fi
done <"$cfg"
