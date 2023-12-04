output "vnet_id" {
  description = "List of vnet id"
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "List of subnet id's"
  value = module.network.subnet_ids
}

