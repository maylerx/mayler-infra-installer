#!/usr/bin/env bash
module_install() {
    log "Actualizando sistema y instalando herramientas básicas..."
    apt update && apt upgrade -y
    apt install -y build-essential curl wget git vim net-tools
    echo "{\"module\":\"base\",\"packages\":["build-essential","curl","wget","git","vim","net-tools"]}" > "$(dirname "${BASH_SOURCE[0]}")/../manifests/base.json"
    ok "Módulo base instalado."
}


module_rollback() {
    log "Rollback base: eliminando paquetes instalados (si aplica)..."
    apt remove -y build-essential curl wget git vim net-tools || true
    rm -f "$(dirname "${BASH_SOURCE[0]}")/../manifests/base.json"
}
