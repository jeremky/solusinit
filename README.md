# solusinit

A script that automates installing and configuring SolusOS.

## Features

- `install_packages`: updates the system and installs the applications listed in `config/packages.cfg`
- `install_flatpaks`: installs the applications listed in `config/flatpaks.cfg`
- `install_herdr`: installs the herdr multiplexer for user 1000
- `install_claude`: installs the Claude CLI for user 1000
- `install_geforcenow`: adds the NVIDIA repository and installs GeforceNow via Flathub
- `install_hytale`: downloads and installs the Hytale flatpak
- `configure_sshd`: hardens access to the OpenSSH server

> [!IMPORTANT]
> The file will be placed in `/etc/ssh/sshd_config.d/<user>.conf`

## Configuration

The `config/config.cfg` file lets you configure how the script runs to suit your preferences.
Comment out the functions you don't want to use. Example:

```txt
# solusinit config

install_packages
install_flatpaks
install_herdr
install_claude

install_geforcenow
install_hytale

configure_sshd
```

## Usage

Once you've edited `config/config.cfg`, run the script with root privileges:

```bash
sudo ./solusinit.sh
```
