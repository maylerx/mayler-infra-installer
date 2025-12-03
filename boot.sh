#!/bin/bash
set -e

ascii_art='________                  __        ___.
\_____  \   _____ _____  |  | ____ _\_ |__
 /   |   \ /     \\__   \ |  |/ /  |  \ __ \
/    |    \  Y Y  \/ __ \|    <|  |  / \_\ \
\_______  /__|_|  (____  /__|_ \____/|___  /
        \/      \/     \/     \/         \/
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
rm -rf ~/.local/share/infra-installer

git clone https://github.com/maylerx/mayler-infra-installer.git ~/.local/share/infra-installer >/dev/null

# Checkout opcional (solo si usas ramas alternativas)
if [[ $FREETECH_REF != "main" ]]; then
    cd ~/.local/share/infra-installer
    git fetch origin "${FREETECH_REF:-main}" && git checkout "${FREETECH_REF:-main}"
    cd -
fi

echo "Iniciando instalador..."
source ~/.local/share/infra-installer/installer.sh
