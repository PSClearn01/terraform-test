# Proxmox Terraform guests

Clones LXC containers and VMs from existing Proxmox templates onto one Proxmox node using the [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest/docs) provider.

## Prerequisites

- Terraform 1.5+ and connectivity to the Proxmox API.
- A Proxmox API token with permissions to create/manage guests, storage content, and networking on the target node.
- An existing **LXC container template** for every `lxc_containers` entry. Convert its source container with `pct template <vmid>`.
- An existing **VM template** with cloud-init enabled for every `virtual_machines` entry.

## Use

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars for your node, storage, templates, network, and SSH key
export TF_VAR_proxmox_api_token='terraform@pve!iac=TOKEN_SECRET'
terraform init
terraform plan
terraform apply
```

Do not put the API token in `terraform.tfvars` or commit either `terraform.tfvars` or `.tfstate`.

`ip_address` accepts `dhcp` or a CIDR address such as `10.10.10.21/24`. Remove `gateway` when using DHCP.
