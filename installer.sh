#!/usr/bin/env bash
source utils.sh


QUIET=false
SELECTED_MODULES=()
ROLLBACK_TARGET=""


show_logo() {
echo "=============================="
echo " Instalador InfraComp v1.0 "
echo "=============================="
}


usage() {
echo "Uso: sudo bash installer.sh [--quiet] [--modules m1,m2] [--rollback modulo]"
exit 1
}


parse_args() {
while [[ "$#" -gt 0 ]]; do
case $1 in
--quiet) QUIET=true ;;
--modules)
IFS=',' read -ra SELECTED_MODULES <<< "$2"
shift ;;
--rollback) ROLLBACK_TARGET="$2" ; shift ;;
*) usage ;;
esac
shift
done
}


interactive_menu() {
echo "Seleccione módulos (1-5):"
echo "1) base"
echo "2) network"
echo "3) virtualization"
echo "4) containers"
echo "5) monitoring"
read -p "Ingrese números separados por espacio: " CHOICES
for c in $CHOICES; do
case $c in
1) SELECTED_MODULES+=(base) ;;
2) SELECTED_MODULES+=(network) ;;
3) SELECTED_MODULES+=(virtualization) ;;
4) SELECTED_MODULES+=(containers) ;;
5) SELECTED_MODULES+=(monitoring) ;;
esac
done
}


load_module() {
MFILE="modules/$1.sh"
if [[ ! -f "$MFILE" ]]; then
error "Módulo no encontrado: $1"
exit 1
fi
source "$MFILE"
module_install
}


perform_rollback() {
MFILE="modules/$ROLLBACK_TARGET.sh"
if [[ ! -f "$MFILE" ]]; then
error "No existe módulo para rollback: $ROLLBACK_TARGET"
exit 1
fi
source "$MFILE"
module_rollback
}


main($@) {
``` (`installer.sh`)
