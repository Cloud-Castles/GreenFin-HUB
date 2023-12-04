output "vnet_name" {
  description = "List of vnet id"
  value       = module.network.vnet_name
}

output "subnet_objects" {
  description = "List of subnet id's"
  value = module.network.subnet_objects.name
}

