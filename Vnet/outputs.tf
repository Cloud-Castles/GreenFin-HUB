output "vnet_id" {
  description = "List of vnet id"
  value = module.greenfin-tfc-lab-tf-code-modules.vnet_id
}

output "subnet_ids" {
  description = "List of subnet id's"
  value = module.greenfin-tfc-lab-tf-code-modules.subnet_ids
}

output "network_interface_ip" {
  description = "List of nic ip's"
  value = module.greenfin-tfc-lab-tf-code-modules.network_interface_ip
}