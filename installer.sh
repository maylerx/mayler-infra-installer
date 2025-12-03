#!/usr/bin/env bash
set -euo pipefail


# directorio donde está el script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"


# cargar utilidades
if [[ -f "$DIR/utils.sh" ]]; then
source "$DIR/utils.sh"
else
echo "No se encontró utils.sh en $DIR" >&2
exit 1
fi


QUIET=false
SELECTED_MODULES=()
ROLLBACK_TARGET=""

show_logo() {
print_logo || echo "== FreeTech InfraComp Installer =="
}


usage() {
cat <<EOF
Uso:
sudo bash installer.sh [--quiet] [--modules base,network,...] [--rollback <module>]
EOF
exit 1
}


parse_args() {
while [[ $# -gt 0 ]]; do
case "$1" in
--quiet) QUIET=true; shift ;;
--modules)
if [[ -z "${2:-}" ]]; then usage; fi
IFS=',' read -ra SELECTED_MODULES <<< "$2"
shift 2
;;
--rollback)
ROLLBACK_TARGET="${2:-}"
shift 2
;;
--help|-h) usage ;;
*) usage ;;
esac
done
}

interactive_menu() {
echo "Seleccione módulos (separados por espacio):"
echo "1) base"
echo "2) network"
echo "3) virtualization"
echo "4) containers"
echo "5) monitoring"
echo
read -rp "Ingrese números: " -a CHOICES
for c in "${CHOICES[@]}"; do
case "$c" in
1) SELECTED_MODULES+=(base) ;;
2) SELECTED_MODULES+=(network) ;;
3) SELECTED_MODULES+=(virtualization) ;;
4) SELECTED_MODULES+=(containers) ;;
5) SELECTED_MODULES+=(monitoring) ;;
*) warn "Opción inválida: $c" ;;
esac
done
}


load_module() {
local m="$1"
local f="$DIR/modules/${m}.sh"
if [[ ! -f "$f" ]]; then
error "Módulo no encontrado: $m (esperado en $f)"
exit 1
fi
# shellcheck source=/dev/null
source "$f"
if declare -f module_install >/dev/null; then
module_install
else
warn "El módulo $m no implementa module_install()"
fi
}
perform_rollback() {
local m="$ROLLBACK_TARGET"
local f="$DIR/modules/${m}.sh"
if [[ ! -f "$f" ]]; then
error "No existe módulo para rollback: $m"
exit 1
fi
source "$f"
if declare -f module_rollback >/dev/null; then
module_rollback
else
warn "El módulo $m no implementa module_rollback()"
fi
}


main() {
require_root
check_os
clear
show_logo


parse_args "$@"


if [[ -n "$ROLLBACK_TARGET" ]]; then
perform_rollback
exit 0
fi


if [[ "$QUIET" = false && ${#SELECTED_MODULES[@]} -eq 0 ]]; then
interactive_menu
fi


if [[ ${#SELECTED_MODULES[@]} -eq 0 ]]; then
warn "No se seleccionaron módulos. Saliendo."
exit 0
fi
mkdir -p "$DIR/manifests"


for mod in "${SELECTED_MODULES[@]}"; do
info "Instalando módulo: $mod"
load_module "$mod"
done


log "Instalación finalizada."
}


main "$@"

