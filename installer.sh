#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"


QUIET=false
SELECTED_MODULES=()
ROLLBACK_TARGET=""

########################################
# LOGO
########################################
show_logo() {
    echo "=============================="
    echo "     Instalador InfraComp     "
    echo "             v1.0             "
    echo "=============================="
}

########################################
# AYUDA
########################################
usage() {
    echo "Uso:"
    echo "  sudo bash installer.sh [--quiet] [--modules m1,m2] [--rollback modulo]"
    exit 1
}

########################################
# PARSEO DE ARGUMENTOS
########################################
parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --quiet)
                QUIET=true
                ;;
            --modules)
                IFS=',' read -ra SELECTED_MODULES <<< "$2"
                shift
                ;;
            --rollback)
                ROLLBACK_TARGET="$2"
                shift
                ;;
            *)
                usage
                ;;
        esac
        shift
    done
}

########################################
# MENÚ INTERACTIVO
########################################
interactive_menu() {
    echo "Seleccione módulos (1-5):"
    echo "1) base"
    echo "2) network"
    echo "3) virtualization"
    echo "4) containers"
    echo "5) monitoring"
    echo
    read -p "Ingrese números separados por espacio: " CHOICES

    for c in $CHOICES; do
        case "$c" in
            1) SELECTED_MODULES+=(base) ;;
            2) SELECTED_MODULES+=(network) ;;
            3) SELECTED_MODULES+=(virtualization) ;;
            4) SELECTED_MODULES+=(containers) ;;
            5) SELECTED_MODULES+=(monitoring) ;;
        esac
    done
}

########################################
# CARGA DE MÓDULO
########################################
load_module() {
    local MFILE="modules/$1.sh"

    if [[ ! -f "$MFILE" ]]; then
        error "Módulo no encontrado: $1"
        exit 1
    fi

    source "$MFILE"
    module_install
}

########################################
# ROLLBACK
########################################
perform_rollback() {
    local MFILE="modules/$ROLLBACK_TARGET.sh"

    if [[ ! -f "$MFILE" ]]; then
        error "No existe módulo para rollback: $ROLLBACK_TARGET"
        exit 1
    fi

    source "$MFILE"
    module_rollback
}

########################################
# MAIN
########################################
main() {
    require_root
    check_os
    clear
    print_logo

    parse_args "$@"

    if [[ -n "$ROLLBACK_TARGET" ]]; then
        perform_rollback
        exit 0
    fi

    if [[ "$QUIET" = false && ${#SELECTED_MODULES[@]} -eq 0 ]]; then
        interactive_menu
    fi

    for module in "${SELECTED_MODULES[@]}"; do
        info "Instalando módulo: $module"
        load_module "$module"
    done

    log "Instalación completada."
}

main "$@"
