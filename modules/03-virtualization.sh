#!/usr/bin/env bash
module_name="virtualization"


module_install() {
log "Instalando KVM, Libvirt y herramientas de virtualización..."


apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
systemctl enable --now libvirtd


echo "{\"module\": \"virtualization\", \"packages\": [\"qemu-kvm\", \"libvirt-daemon-system\", \"libvirt-clients\", \"bridge-utils\", \"virt-manager\"]}" \
> "manifests/virtualization.json"


ok "Virtualización instalada."
}


module_rollback() {
log "Rollback del módulo de virtualización..."
apt remove -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
systemctl disable --now libvirtd
rm -f manifests/virtualization.json
ok "Rollback completado para virtualización."
}
