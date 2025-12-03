#!/usr/bin/env bash
# ----------------------------------------
# AUTO-ELEVACIÓN A ROOT
# ----------------------------------------
if [ "$EUID" -ne 0 ]; then
  echo "[i] Elevando privilegios..."
  exec sudo bash "$0" "$@"
fi



set -euo pipefail


ascii_art='''
________ __ ___.
\_____ \ _____ _____ | | ____ _\_ |__
/ | \ / \\__ \ | |/ / | \ __ \
/ | \ Y Y \/ __ \| <| | / \_\ \\
\_______ /__|_| (____ /__|_ \____/|___ /
\/ \/ \/ \/ \/
'''


printf "%s\n" "$ascii_art"
echo "=> FreeTech InfraComp Installer para Ubuntu 24.04+"
echo


echo "Iniciando..."


sudo apt-get update -y >/dev/null
sudo apt-get install -y git >/dev/null


echo "Clonando FreeTech Installer..."
rm -rf ~/.local/share/infra-installer


git clone https://github.com/maylerx/mayler-infra-installer.git ~/.local/share/infra-installer >/dev/null 2>&1


# si se define FREETECH_REF y existe en remoto, cambiar
if git -C ~/.local/share/infra-installer ls-remote --heads origin "${FREETECH_REF:-main}" | grep -q "${FREETECH_REF:-main}"; then
    git -C ~/.local/share/infra-installer fetch --depth 1 origin "${FREETECH_REF:-main}" >/dev/null
    git -C ~/.local/share/infra-installer checkout -q "${FREETECH_REF:-main}"
fi


# ejecutar installer correctamente
bash ~/.local/share/infra-installer/installer.sh "$@"
