#!/usr/bin/env bash
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
