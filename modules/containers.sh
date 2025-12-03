#!/usr/bin/env bash
module_name="containers"


module_install() {
log "Instalando Docker + Docker Compose..."


apt install -y ca-certificates curl gnupg lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list


apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


usermod -aG docker "$SUDO_USER"


echo "{\"module\": \"containers\", \"packages\": [\"docker-ce\", \"docker-ce-cli\", \"containerd.io\", \"docker-buildx-plugin\", \"docker-compose-plugin\"]}" \
> "manifests/containers.json"


ok "Docker instalado correctamente."
}


module_rollback() {
log "Rollback del módulo containers..."
apt remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
rm -f /etc/apt/sources.list.d/docker.list
rm -f manifests/containers.json
ok "Rollback containers completado."
}
