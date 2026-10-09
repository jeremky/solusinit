# solusinit

A script that automates installing and configuring Solus.

## Features

- `install_packages`: updates the system and installs the applications listed in `config/packages.cfg`
- `install_flatpaks`: installs the applications listed in `config/flatpaks.cfg`
- `install_npm`: installs Node.js and the global npm packages listed in `config/nodenpm.cfg`
- `install_herdr`: installs the herdr multiplexer for user 1000
- `install_claude`: installs Claude Code for user 1000
- `install_geforcenow`: adds the NVIDIA repository and installs GeForce NOW via Flathub
- `install_hytale`: downloads and installs the Hytale flatpak
- `configure_sshd`: hardens access to the OpenSSH server

> [!IMPORTANT]
> `configure_sshd` writes its config to `/etc/ssh/sshd_config.d/<user>.conf`

> [!NOTE]
> `install_npm` installs packages globally (`npm -g`) into `/usr/lib/node_modules`, which is not managed by eopkg.
> These packages won't be updated by `eopkg upgrade`: run `sudo npm -g update` to update them.

## Configuration

The `config/config.cfg` file lets you configure how the script runs to suit your preferences.
Comment out the functions you don't want to use. Example:

```txt
# solusinit config

install_packages
install_flatpaks
install_npm
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
