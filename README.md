# solusinit

Script automatisant l'installation et le paramétrage de SolusOS.

## Fonctionnalités

- `install_packages` : met à jour le système et installe les applications présentes dans le fichier `config/packages.cfg`
- `install_flatpaks` : installe les applications présentes dans le fichier `config/flatpacks.cfg`
- `install_herdr` : installe multiplexeur herdr pour le user 1000
- `install_claude` : installe claude cli pour le user 1000
- `install_geforcenow` : ajoute le dépôt nvidia et installe GeforceNow via flathub
- `install_hytale` : télécharge et installe le flatpak Hytale
- `configure_sshd` : sécurise les accès au serveur openssh

> [!IMPORTANT]
> Le fichier sera déposé dans `/etc/ssh/sshd_config.d/<user>.conf`

## Configuration

Le fichier `config/config.cfg` permet de paramétrer l'exécution du script selon vos préférences.
Commentez les fonctions que vous ne voulez pas utiliser. Exemple :

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

## Utilisation

Une fois le fichier `config/config.cfg` modifié, lancez le script avec les droits root :

```bash
sudo ./solusinit.sh
```
