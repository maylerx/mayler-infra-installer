#!/usr/bin/env bash
module_install() {
log "Instalando herramientas de red..."
apt install -y nmap tcpdump traceroute iperf3 dnsutils whois net-tools
echo "{\"module\":\"network\"}" > "$(dirname "${BASH_SOURCE[0]}")/../manifests/network.json"
}
module_rollback() {
apt remove -y nmap tcpdump traceroute iperf3 dnsutils whois net-tools || true
rm -f "$(dirname "${BASH_SOURCE[0]}")/../manifests/network.json"
}
