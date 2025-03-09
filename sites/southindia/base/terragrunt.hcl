locals {
  input_config = read_terragrunt_config("${get_original_terragrunt_dir()}/input.hcl")
}

terraform {
  source = "../../../modules/azure/bootstrap"
}

inputs = local.input_config.inputs