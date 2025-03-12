# output the public IP address
output "public_ip" {
  value = azurerm_public_ip.runner_public_ip.ip_address
}