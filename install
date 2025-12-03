#!/bin/bash

set -e

ascii_art='███████╗██████╗ ███████╗███████╗████████╗██████╗██╗  ██╗
██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║  ██║
█████╗  ██████╔╝█████╗  ███████╗   ██║   ██████╔╝███████║
██╔══╝  ██╔══██╗██╔══╝  ╚════██║   ██║   ██╔══██╗██╔══██║
███████╗██║  ██║███████╗███████║   ██║   ██║  ██║██║  ██║
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝

             FreeTech – InfraComp Installer
'

echo -e "$ascii_art"
echo "=> FreeTech InfraComp Installer para Ubuntu 24.04+"
echo -e "\nIniciando instalación (Ctrl+C para cancelar)..."

# ------------------------------------------
# DEPENDENCIAS
# ------------------------------------------
sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

# ------------------------------------------
# CLONACIÓN DEL REPO
# ------------------------------------------
echo "Clonando FreeTech Installer..."
rm -rf ~/.local/share/freetech

git clone https://github.com/tuusuario/freetech.git ~/.local/share/freetech >/dev/null

if [[ $FREETECH_REF != "master" ]]; then
    cd ~/.local/share/freetech
    git fetch origin "${FREETECH_REF:-stable}" && git checkout "${FREETECH_REF:-stable}"
    cd -
fi

echo "Iniciando instalador..."
source ~/.local/share/freetech/installer.sh
