variable "resource_group_location" {
  type        = string
  description = "The Azure Region where the Resource Group should exist"
}

variable "resource_group_name" {
  type        = string
  description = "The Name which should be used for this Resource Group"
}

variable "storage_account_name" {
  type        = string
  description = "Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed."
}

variable "storage_account_kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
}

variable "storage_account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
}

variable "storage_container_name" {
  type        = string
  description = "The name of the Container which should be created within the Storage Account"
}

variable "storage_container_access_type" {
  type        = string
  description = "The Access Level configured for this Container. Possible values are blob, container or private"
}