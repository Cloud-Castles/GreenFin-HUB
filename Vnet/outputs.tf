output "vnet_name" {
  description = "ID of the created vnet"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_names" {
  description = "List of subnet names"
  value = [for subnet in azurerm_subnet.subnet : subnet.name]
}
