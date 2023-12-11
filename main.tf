locals {
  foundation_settings = jsondecode(file("Foundation/foundation_configuration.json"))
  netowrk_settings = jsondecode(file("Network/network_configuration.json"))
  fw_settings = jsondecode(file("Resources/FW/fw_configuration.json"))
}

module "foundation" {
  source  = "app.terraform.io/cloud-castles/foundation/azurerm"
  version = "1.0.0"
  resource_group = local.foundation_settings.resource_group
  location = local.foundation_settings.location
} 

# module "route_table" {
#   source  = "app.terraform.io/cloud-castles/foundation/azurerm"
#   version = "1.0.0"
#   resource_group = local.foundation_settings.resource_group
#   location = local.foundation_settings.location
# }

module "network" {
  source  = "app.terraform.io/cloud-castles/network/azurerm"
  version = "1.0.5"
  resource_group = local.foundation_settings.resource_group
  location = local.foundation_settings.location
  vnet_name = local.netowrk_settings.vnet_name
  address_space = local.netowrk_settings.address_space
  subnet_objects = local.netowrk_settings.subnet_objects
}

module "pip" {
  source  = "app.terraform.io/cloud-castles/pip/azurerm"
  version = "1.0.0"
  pip_name = local.fw_settings.pip_name
  resource_group = local.foundation_settings.resource_group
  location = local.foundation_settings.location
  allocation_method = local.fw_settings.allocation_method
  pip_sku = local.fw_settings.pip_sku

  depends_on = [module.network]
}

module "fw" {
  source  = "app.terraform.io/cloud-castles/fw/azurerm"
  version = "1.0.7"
  resource_group = local.foundation_settings.resource_group
  location = local.foundation_settings.location
  subnet_id = element(module.network.subnet_ids, 0)
  pip_name = local.fw_settings.pip_name
  allocation_method = local.fw_settings.allocation_method
  pip_sku = local.fw_settings.pip_sku
  fw_policy_name = local.fw_settings.fw_policy_name
  fw_policy_sku = local.fw_settings.fw_policy_sku
  fw_name = local.fw_settings.fw_name
  fw_sku = local.fw_settings.fw_sku
  fw_tier = local.fw_settings.fw_tier
  ip_conf_name = local.fw_settings.ip_conf_name

  depends_on = [module.pip]
}

module "vpngw" {
  source  = "app.terraform.io/cloud-castles/fw/azurerm"
  version = "1.0.0"
  resource_group = local.foundation_settings.resource_group
  location = local.foundation_settings.location

  depends_on = [module.pip]
}



# module "storage_account" {
#   source  = "app.terraform.io/cloud-castles/network/azurerm"
#   version = "1.0.0"
# }

# module "azure_function" {
#   source  = "app.terraform.io/cloud-castles/network/azurerm"
#   version = "1.0.0"
# }