locals {
  netowrk_settings = jsondecode(file("./configuration.json"))
}

module "network" {
  source  = "app.terraform.io/cloud-castles/network/azurerm"
  version = "1.0.4"
  address_space = local.netowrk_settings.address_space
  location = local.netowrk_settings.location
  resource_group = local.netowrk_settings.resource_group
  subnet_objects = local.netowrk_settings.subnet_objects
  vnet_name = local.netowrk_settings.vnet_name
  env = var.env
}
#test1234