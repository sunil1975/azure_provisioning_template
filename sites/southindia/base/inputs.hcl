locals {
  backend_config = read_terragrunt_config(find_in_parent_folders("backend.hcl"))
}

inputs = {
  resource_group_location          = "South India"
  resource_group_name              = local.backend_config.inputs.resource_group_name
  storage_account_name             = local.backend_config.inputs.storage_account_name
  storage_account_kind             = "BlobStorage"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  storage_container_name           = local.backend_config.inputs.container_name
  storage_container_access_type    = "private"
}