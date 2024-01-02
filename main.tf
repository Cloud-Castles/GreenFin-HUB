locals {
  foundation_settings = jsondecode(file("Foundation/foundation_configuration.json"))
  network_settings    = jsondecode(file("Network/network_configuration.json"))
  fw_settings         = jsondecode(file("Resources/FW/fw_configuration.json"))
  # vpngw_settings      = jsondecode(file("Resources/VPNGW/vpngw_configuration.json"))
}

module "foundation" {
  source         = "app.terraform.io/cloud-castles/foundation/azurerm"
  version        = "1.0.0"
  for_each = {
    for key, value in local.foundation_settings.resource_groups :
    key => value
  }
  name                  = each.key
  location              = each.value.location
}

module "network" {
  source                = "app.terraform.io/cloud-castles/network/azurerm"
  version               = "1.0.1"
  for_each = {
    for key, value in local.network_settings.vnets :
    key => value
  }
  ###########################################################
  # Import inputs from previous Modules
  ###########################################################
  resource_group = module.foundation[each.value.targetResourceGroup].resource_group_name
  location       = module.foundation[each.value.targetResourceGroup].resource_group_location
  ###########################################################
  vnet_name             = each.key
  address_space         = each.value.address_space
  fw_private_ip_address = each.value.fw_private_ip_address
  dns_servers           = each.value.dns_servers
  subnets               = each.value.subnets
  route_tables          = each.value.route_tables
  routes                = each.value.routes

  depends_on = [module.foundation]
}
#test
# module "fw" {
#   source            = "app.terraform.io/cloud-castles/fw/azurerm"
#   version           = "1.0.0"
#   for_each = {
#     for key, value in local.fw_settings.fws :
#     key => value
#   }
#   ###########################################################
#   # Import inputs from previous Modules
#   ###########################################################
#   resource_group = module.foundation[each.value.targetResourceGroup].resource_group_name
#   location       = module.foundation[each.value.targetResourceGroup].resource_group_location
#   dns_servers    = module.network[each.value.targetVnet].dns_servers
#   subnet_id      = module.network[each.value.targetVnet].subnet_ids[each.value.targetSubnet]
#   ###########################################################

#   fw_name           = each.key
#   pip_name          = each.value.pip_name
#   allocation_method = each.value.allocation_method
#   pip_sku           = each.value.pip_sku
#   fw_policy_name    = each.value.fw_policy_name
#   fw_policy_sku     = each.value.fw_policy_sku
#   fw_sku            = each.value.fw_sku
#   fw_tier           = each.value.fw_tier
#   ip_conf_name      = each.value.ip_conf_name

#   depends_on = [module.network]
# }

# module "vpngw" {
#   source                  = "app.terraform.io/cloud-castles/vpngw/azurerm"
#   version                 = "1.0.3"
#   resource_group          = local.foundation_settings.resource_group
#   location                = local.foundation_settings.location
#   subnet_id               = element(module.network.subnet_ids, 1)
#   localgw_bgp_settings    = local.vpngw_settings.localgw_bgp_settings
#   localgw_networks        = local.vpngw_settings.localgw_networks
#   vpngw_bgp_asn           = local.vpngw_settings.vpngw_bgp_asn
#   vpngw_conn_ipsec_policy = local.vpngw_settings.vpngw_conn_ipsec_policy

#   depends_on = [module.network]
# }

#test2