module "vnet" {
  source  = "app.terraform.io/cloud-castles/greenfin-tfc-lab-tf-code-modules/azurerm"
  version = "1.0.0"
  environment  = "dev"
}