# solusinit

Script automatisant l'installation et le paramétrage de SolusOS.

## Fonctionnalités

- `packages` : met à jour le système et installe les applications présentes dans le fichier `config/packages.cfg`

- `geforcenow` : installe GeforceNow via flathub.

## Configuration

Le fichier `config/config.cfg` permet de paramétrer l'exécution du script selon vos préférences.
Commentez les fonctions que vous ne voulez pas utiliser. Exemple :

```txt
# solusinit config

install_packages
install_geforcenow


```

Avec le fichier de config se trouve `config/packages.cfg`, contenant la liste des paquets à installer si `install_packages` est actif.

Exemple :

```txt
# solusinit packages list

btop
dust
fd
font-jetbrainsmono-ttf
fzf
gamemode
gamescope
git
ghostty
gnome-shell-extension-dash-to-dock
golang
icdiff
mangohud
ncdu
openssh-server
papirus-icon-theme
procs
ripgrep
shellcheck
steam
vim
zed
zoxide
```

## Utilisation

Une fois le fichier `config/config.cfg` modifié, lancez le script avec les droits root :

```bash
sudo ./dnfinstall.sh
```
