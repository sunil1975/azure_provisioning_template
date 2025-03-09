locals {
  module_name           = "${basename(path_relative_to_include())}"
  parent_terragrunt_dir = "${get_parent_terragrunt_dir()}"
  inputs_config         = try(read_terragrunt_config("${get_original_terragrunt_dir()}/inputs.hcl"), null)
  backend_config        = read_terragrunt_config("${get_parent_terragrunt_dir()}/backend.hcl")
}

terraform {
  source = "${local.parent_terragrunt_dir}/..//modules/azure/infrastructure/${local.module_name}"
}

inputs = local.inputs_config.inputs

remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = merge(local.backend_config.inputs, {
    key = "${path_relative_to_include()}/terraform.tfstate"
  })
}