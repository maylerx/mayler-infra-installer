#!/usr/bin/env bash
module_install() {
    log "Instalando KVM/libvirt..."
    apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
    systemctl enable --now libvirtd || true
    echo "{\"module\":\"virtualization\"}" > "$(dirname "${BASH_SOURCE[0]}")/../manifests/virtualization.json"
}
module_rollback() {
    apt remove -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager || true
    systemctl disable --now libvirtd || true
    rm -f "$(dirname "${BASH_SOURCE[0]}")/../manifests/virtualization.json"
}
