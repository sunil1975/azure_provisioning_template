locals {
  prefix = "shakiel"
}

inputs = {
  resource_group_location          = "South India"
  resource_group_name              = "${local.prefix}-sample-rg"
  storage_account_name             = "${local.prefix}terraformstates"
  storage_account_kind             = "BlobStorage"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  storage_container_name           = "template"
  storage_container_access_type    = "private"
}