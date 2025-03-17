variable "vm_name" {
  description = "The hostname of the VM"
  type = string
  default = "github-runner-vm"
}
variable "ssh_key_path" {
  description = " Ssh pulic key path"
  type = string
  default = "C:/rsa_key/rsa.pub"
}
variable "location" {
  description = "Azure region"
  type        = string
  default     = "East us"

}