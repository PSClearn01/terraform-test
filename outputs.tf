output "lxc_ids" {
  description = "Proxmox IDs of the managed LXC containers."
  value       = { for name, container in proxmox_virtual_environment_container.lxc : name => container.vm_id }
}

output "vm_ids" {
  description = "Proxmox IDs of the managed virtual machines."
  value       = { for name, vm in proxmox_virtual_environment_vm.vm : name => vm.vm_id }
}
