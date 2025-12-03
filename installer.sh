#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/utils.sh"

MODULES_DIR="$SCRIPT_DIR/modules"
INSTALLED_FILE="/var/log/infra-installer-installed.log"

mkdir -p "$(dirname "$INSTALLED_FILE")"
touch "$INSTALLED_FILE"

# Registrar instalación
mark_installed() {
    echo "$1" >> "$INSTALLED_FILE"
}

is_installed() {
    grep -qx "$1" "$INSTALLED_FILE"
}

# Menú gráfico
main_menu() {
    whiptail --title "FreeTech – Instalador" \
        --menu "Seleccione una opción:" 20 60 10 \
        1 "Instalar módulo" \
        2 "Ver módulos instalados" \
        0 "Salir" \
        3>&1 1>&2 2>&3
}

module_menu() {
    whiptail --title "Módulos disponibles" \
        --checklist "Seleccione módulos a instalar:" 20 60 10 \
        base "Herramientas base" OFF \
        network "Red y conectividad" OFF \
        virtualization "Virtualización" OFF \
        containers "Docker / Podman" OFF \
        monitoring "Monitorización" OFF \
        3>&1 1>&2 2>&3
}

show_installed() {
    if [[ ! -s "$INSTALLED_FILE" ]]; then
        whiptail --title "Módulos instalados" --msgbox "Aún no hay módulos instalados." 10 50
        return
    fi

    whiptail --title "Módulos instalados" \
        --msgbox "$(cat "$INSTALLED_FILE")" 20 60
}

install_module() {
    local module="$1"
    local path="$MODULES_DIR/$module.sh"

    if [[ ! -f "$path" ]]; then
        whiptail --title "Error" --msgbox "El módulo '$module' no existe." 10 50
        return
    fi

    source "$path"

    if ! command -v module_install >/dev/null; then
        whiptail --title "Error" --msgbox "El módulo '$module' no implementa module_install()" 10 50
        return
    fi

    module_install && mark_installed "$module"
    unset -f module_install module_rollback

    whiptail --title "Éxito" --msgbox "Módulo '$module' instalado correctamente." 10 50
}

# LOOP PRINCIPAL
while true; do
    choice=$(main_menu)

    case "$choice" in
        1)
            selected=$(module_menu)
            for module in $selected; do
                module=${module//\"/}
                install_module "$module"
            done
            ;;
        2)
            show_installed
            ;;
        0)
            exit 0
            ;;
        *)
            ;;
    esac
done
