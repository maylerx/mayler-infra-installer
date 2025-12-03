#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/utils.sh"

MODULES_DIR="$SCRIPT_DIR/modules"

while true; do
    clear
    echo "============================"
    echo "  Instalador de Infra"
    echo "============================"
    echo "Seleccione un módulo:"
    echo "1) base"
    echo "2) network"
    echo "3) virtualization"
    echo "4) containers"
    echo "5) monitoring"
    echo "0) Salir"
    echo "============================"
    read -rp "Opción: " opt

    case "$opt" in
        1) module="base" ;;
        2) module="network" ;;
        3) module="virtualization" ;;
        4) module="containers" ;;
        5) module="monitoring" ;;
        0) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida"; sleep 1; continue ;;
    esac

    MODULE_PATH="$MODULES_DIR/$module.sh"

    if [[ ! -f "$MODULE_PATH" ]]; then
        echo "❌ El módulo '$module' no existe."
        sleep 2
        continue
    fi

    echo "▶ Instalando módulo: $module"
    source "$MODULE_PATH"

    if command -v module_install >/dev/null 2>&1; then
        module_install
    else
        echo "❌ El módulo '$module' no tiene función module_install()"
    fi

    unset -f module_install module_rollback

    echo ""
    read -rp "Presione ENTER para volver al menú..."
done
