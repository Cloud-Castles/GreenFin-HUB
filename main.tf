locals {
  foundation_settings = jsondecode(file("Foundation/foundation_configuration.json"))
  netowrk_settings    = jsondecode(file("Network/network_configuration.json"))
  fw_settings         = jsondecode(file("Resources/FW/fw_configuration.json"))
  vpngw_settings      = jsondecode(file("Resources/VPNGW/vpngw_configuration.json"))
}

module "foundation" {
  source         = "app.terraform.io/cloud-castles/foundation/azurerm"
  version        = "1.0.0"
  resource_group = local.foundation_settings.resource_group
  location       = local.foundation_settings.location
}

module "network" {
  source                = "app.terraform.io/cloud-castles/network/azurerm"
  version               = "1.1.2"
  resource_group        = local.foundation_settings.resource_group
  location              = local.foundation_settings.location
  vnet_name             = local.netowrk_settings.vnet_name
  address_space         = local.netowrk_settings.address_space
  subnets               = local.netowrk_settings.subnets
  fw_private_ip_address = local.netowrk_settings.fw_private_ip_address
  dns_servers           = local.netowrk_settings.dns_servers
  vpngw_rt_routes       = local.netowrk_settings.vpngw_rt_routes

  depends_on = [module.foundation]
}

module "fw" {
  source            = "app.terraform.io/cloud-castles/fw/azurerm"
  version           = "1.0.9"
  resource_group    = local.foundation_settings.resource_group
  location          = local.foundation_settings.location
  subnet_id         = element(module.network.subnet_ids, 0)
  dns_servers       = local.netowrk_settings.dns_servers
  pip_name          = local.fw_settings.pip_name
  allocation_method = local.fw_settings.allocation_method
  pip_sku           = local.fw_settings.pip_sku
  fw_policy_name    = local.fw_settings.fw_policy_name
  fw_policy_sku     = local.fw_settings.fw_policy_sku
  fw_name           = local.fw_settings.fw_name
  fw_sku            = local.fw_settings.fw_sku
  fw_tier           = local.fw_settings.fw_tier
  ip_conf_name      = local.fw_settings.ip_conf_name

  depends_on = [module.network]
}

module "vpngw" {
  source                  = "app.terraform.io/cloud-castles/fw/azurerm"
  version                 = "1.0.2"
  resource_group          = local.foundation_settings.resource_group
  location                = local.foundation_settings.location
  subnet_id               = element(module.network.subnet_ids, 1)
  localgw_bgp_settings    = local.vpngw_settings.localgw_bgp_settings
  localgw_networks        = local.vpngw_settings.localgw_networks
  vpngw_bgp_asn           = local.vpngw_settings.vpngw_bgp_asn
  vpngw_conn_ipsec_policy = local.vpngw_settings.vpngw_conn_ipsec_policy

  depends_on = [module.network]
}



# module "storage_account" {
#   source  = "app.terraform.io/cloud-castles/network/azurerm"
#   version = "1.0.0"
# }

# module "azure_function" {
#   source  = "app.terraform.io/cloud-castles/network/azurerm"
#   version = "1.0.0"
# }
