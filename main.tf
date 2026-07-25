provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

resource "proxmox_virtual_environment_container" "lxc" {
  for_each = var.lxc_containers

  node_name     = var.node_name
  vm_id         = each.value.vm_id
  description   = "Managed by Terraform"
  tags          = each.value.tags
  unprivileged  = each.value.unprivileged
  started       = true
  start_on_boot = each.value.start_on_boot

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory_mb
  }

  operating_system {
    template_file_id = each.value.template
    type             = "debian"
  }

  disk {
    datastore_id = each.value.datastore_id
    size         = each.value.disk_size_gb
  }

  initialization {
    hostname = each.value.hostname

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.gateway
      }
    }

    user_account {
      keys = [trimspace(var.ssh_public_key)]
    }
  }

  network_interface {
    name   = "eth0"
    bridge = each.value.bridge
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.virtual_machines

  node_name   = var.node_name
  vm_id       = each.value.vm_id
  name        = each.value.name
  description = "Managed by Terraform"
  tags        = each.value.tags
  on_boot     = each.value.start_on_boot
  started     = true

  clone {
    vm_id = each.value.template_vm_id
    full  = true
  }

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory_mb
  }

  disk {
    datastore_id = each.value.datastore_id
    interface    = "scsi0"
    size         = each.value.disk_size_gb
  }

  initialization {
    user_account {
      keys = [trimspace(var.ssh_public_key)]
    }

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.gateway
      }
    }
  }

  network_device {
    bridge = each.value.bridge
    model  = "virtio"
  }
}
