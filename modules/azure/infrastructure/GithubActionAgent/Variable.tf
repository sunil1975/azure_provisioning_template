variable "ssh_key_path" {
  description = " Ssh pulic key path"
  type = string
  default = "C:/rsa_key/rsa.pub"
}
variable "github_token" {
  description = "GitHub personal Access Token"
  type        = string
  sensitive   = true
}
variable "github_owner" {
  description = "Github repository owner"
  type        = string
}
variable "github_repo" {
  description = "Github repository name"
  type        = string
}

variable "runner_name" {
  description = "Name of the GitHub Action runner"
  type        = string
  default     = "azure-runner"
}
variable "location" {
  description = "Azure region"
  type        = string
  default     = "East us"

}