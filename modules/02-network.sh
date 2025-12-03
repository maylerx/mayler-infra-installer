#!/usr/bin/env bash
module_name="network"


module_install() {
log "Instalando herramientas de red..."
apt install -y nmap tcpdump traceroute iperf3 dnsutils whois net-tools


echo "{\"module\": \"network\", \"packages\": [\"nmap\", \"tcpdump\", \"traceroute\", \"iperf3\", \"dnsutils\", \"whois\", \"net-tools\"]}" \
> "manifests/network.json"


ok "Módulo de red instalado."
}


module_rollback() {
log "Rollback: eliminando herramientas de red..."
apt remove -y nmap tcpdump traceroute iperf3 dnsutils whois net-tools
rm -f manifests/network.json
ok "Rollback del módulo network completado."
}
