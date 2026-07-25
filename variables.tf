variable "proxmox_endpoint" {
  description = "Proxmox API URL, for example https://pve.example.internal:8006/api2/json"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token in user@realm!tokenid=secret form. Supply via TF_VAR_proxmox_api_token."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Allow an untrusted Proxmox TLS certificate. Keep false in production."
  type        = bool
  default     = false
}

variable "node_name" {
  description = "Name of the Proxmox node on which to create guests."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key installed for the initial guest user."
  type        = string
}

variable "lxc_containers" {
  description = "LXC containers cloned from existing Proxmox LXC templates, keyed by Terraform name. ip_address can be dhcp or a CIDR address."
  type = map(object({
    vm_id              = number
    template_vm_id     = number
    template_node_name = optional(string)
    hostname           = string
    datastore_id       = string
    disk_size_gb       = number
    cores              = number
    memory_mb          = number
    bridge             = string
    ip_address         = string
    gateway            = optional(string)
    tags               = optional(list(string), [])
    unprivileged       = optional(bool, true)
    start_on_boot      = optional(bool, true)
  }))
  default = {}
}

variable "virtual_machines" {
  description = "VMs cloned from an existing cloud-init-capable Proxmox VM template, keyed by Terraform name."
  type = map(object({
    vm_id          = number
    template_vm_id = number
    name           = string
    datastore_id   = string
    disk_size_gb   = number
    cores          = number
    memory_mb      = number
    bridge         = string
    ip_address     = string
    gateway        = optional(string)
    tags           = optional(list(string), [])
    start_on_boot  = optional(bool, true)
  }))
  default = {}
}
