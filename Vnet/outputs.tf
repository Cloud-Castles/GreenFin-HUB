output "vnet_name" {
  description = "ID of the created vnet"
  value = module.vnet.vnet_name
}

output "subnet_ids" {
  description = "List of subnet id's"
  value = module.vnet.subnet_ids
}
