#!/usr/bin/env bash
module_name="monitoring"


module_install() {
log "Instalando herramientas de monitoreo..."
apt install -y htop glances sysstat iftop bmon


echo "{\"module\": \"monitoring\", \"packages\": [\"htop\", \"glances\", \"sysstat\", \"iftop\", \"bmon\"]}" \
> "manifests/monitoring.json"


ok "Herramientas de monitoreo instaladas."
}


module_rollback() {
log "Rollback del módulo monitoring..."
apt remove -y htop glances sysstat iftop bmon
rm -f manifests/monitoring.json
ok "Rollback de monitoring completado."
}
