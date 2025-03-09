terraform {
  source = "../../../modules/azure/infrastructure/vm"
}

remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    resource_group_name  = "shakiel-sample-rg"
    storage_account_name = "shakielterraformstates"
    container_name       = "template"
    key                  = "vm.terraform.tfstate"
  }
}
