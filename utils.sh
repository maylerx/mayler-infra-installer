#!/usr/bin/env bash
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"


log() { echo -e "${GREEN}[✔]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
error() { echo -e "${RED}[✘]${RESET} $1"; }
info() { echo -e "${CYAN}[i]${RESET} $1"; }


print_logo() {
cat <<'EOF'


███████╗██████╗ ███████╗███████╗████████╗███████╗ ██████╗██╗ ██╗
██╔════╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔════╝██║ ██║
█████╗ ██████╔╝█████╗ ███████╗ ██║ █████╗ ██║ ███████║
██╔══╝ ██╔══██╗██╔══╝ ╚════██║ ██║ ██╔══╝ ██║ ██╔══██║
███████╗██║ ██║███████╗███████║ ██║ ███████╗╚██████╗██║ ██║
╚══════╝╚═╝ ╚═╝╚══════╝╚══════╝ ╚═╝ ╚══════╝ ╚═════╝╚═╝ ╚═╝


FreeTech – Instalador Automático
EOF
}


spinner() {
local pid=$!
local delay=0.1
local spinstr='|/-\\'
while kill -0 "$pid" 2>/dev/null; do
local temp=${spinstr#?}
printf " [%c] " "$spinstr"
spinstr=$temp${spinstr%"$temp"}
sleep "$delay"
printf "\b\b\b\b\b\b"
done
}


require_root() { if [[ $EUID -ne 0 ]]; then error "Este script debe ejecutarse como root."; exit 1; fi }
require_command() { if ! command -v "$1" &>/dev/null; then error "Falta comando: $1"; exit 1; fi }
check_os() {
if [[ -f /etc/os-release ]]; then
. /etc/os-release
if [[ "$ID" != "ubuntu" ]]; then
warn "Detectado: $ID. Este instalador está pensado para Ubuntu.";
fi
else
error "No se detecta /etc/os-release"; exit 1
fi
}


ROLLBACK_ACTIONS=()
add_rollback() { ROLLBACK_ACTIONS+=("$1"); }
run() { info "Ejecutando: $1"; if eval "$1"; then log "OK"; else error "Fallo: $1"; rollback; exit 1; fi }
rollback() { warn "Ejecutando rollback..."; for a in "${ROLLBACK_ACTIONS[@]}"; do warn "-> $a"; eval "$a"; done }


load_module() { local m="$1"; local f="modules/${m}.sh"; if [[ -f "$f" ]]; then source "$f"; else error "No existe módulo: $m"; exit 1; fi }


parse_flag() { case "$1" in --silent) SILENT=true ;; --debug) DEBUG=true ;; esac }
