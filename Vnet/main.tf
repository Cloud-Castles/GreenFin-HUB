data "external" "vnet_settings" {
  program = ["cat", "${path.module}/configuration.json"]
}

locals {
  vnet_settings = jsondecode(data.external.vnet_settings.result)
}


# locals {
#   vnet_settings = jsondecode(file("${path.module}/configuration.json"))
# }1223

module "vnet" {
  source  = "app.terraform.io/cloud-castles/vnet/azurerm"
  version = "1.0.0"
  resource_group = local.vnet_settings.resource_group
  location = local.vnet_settings.location
  vnet_name = local.vnet_settings.vnet_name
  address_space = local.vnet_settings.address_space
}

