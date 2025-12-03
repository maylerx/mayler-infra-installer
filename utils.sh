#!/usr/bin/env bash

########################################
# COLORES Y FORMATO
########################################

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

########################################
# LOGGING
########################################

log() {
    echo -e "${GREEN}[✔]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

error() {
    echo -e "${RED}[✘]${RESET} $1"
}

info() {
    echo -e "${CYAN}[i]${RESET} $1"
}

########################################
# ASCII LOGO (FreeTech)
########################################

print_logo() {
cat << 'EOF

███████╗██████╗ ███████╗███████╗████████╗██████╗ ███████╗ ██████╗██╗  ██╗
██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔════╝██║ ██╔╝
█████╗  ██████╔╝█████╗  ███████╗   ██║   ██████╔╝█████╗  ██║     █████╔╝ 
██╔══╝  ██╔══██╗██╔══╝  ╚════██║   ██║   ██╔══██╗██╔══╝  ██║     ██╔═██╗ 
███████╗██║  ██║███████╗███████║   ██║   ██║  ██║███████╗╚██████╗██║  ██╗
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝

                FreeTech — Instalador Automático
EOF
}

########################################
# SPINNER / ANIMACIONES
########################################

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'

    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep "$delay"
        printf "\b\b\b\b\b\b"
    done
}

run_with_spinner() {
    ($1) &
    spinner
    wait $!
}

########################################
# VALIDACIÓN DEL SISTEMA
########################################

require_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Este instalador debe ejecutarse como root."
        exit 1
    fi
}

require_command() {
    if ! command -v "$1" &> /dev/null; then
        error "Comando requerido no encontrado: $1"
        exit 1
    fi
}

check_os() {
    if [[ ! -f /etc/os-release ]]; then
        error "No se detecta un sistema Linux compatible."
        exit 1
    fi
    
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        warn "Este instalador está pensado para Ubuntu. Sistema detectado: $ID"
    fi
}

########################################
# EJECUCIÓN SEGURA + ROLLBACK
########################################

ROLLBACK_ACTIONS=()

add_rollback() {
    ROLLBACK_ACTIONS+=("$1")
}

run() {
    info "Ejecutando: $1"
    if eval "$1"; then
        log "OK"
    else
        error "Fallo ejecutando: $1"
        rollback
        exit 1
    fi
}

rollback() {
    warn "Deshaciendo cambios…"
    for action in "${ROLLBACK_ACTIONS[@]}"; do
        warn "Rollback: $action"
        eval "$action"
    done
}

########################################
# CARGADOR DE MÓDULOS
########################################

load_module() {
    local module="$1"

    if [[ -f "modules/${module}.sh" ]]; then
        source "modules/${module}.sh"
        log "Módulo cargado: ${module}"
    else
        error "No existe el módulo: ${module}"
        exit 1
    fi
}

########################################
# PARSEO DE FLAGS
########################################

parse_flag() {
    case "$1" in
        --silent) SILENT=true ;;
        --debug) DEBUG=true ;;
        --all) RUN_ALL=true ;;
        *) warn "Flag desconocida: $1" ;;
    esac
}

