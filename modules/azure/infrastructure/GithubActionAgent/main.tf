# Resource Group
resource "azurerm_resource_group" "runner_rg" {
  name     = "github-runner-rg"
  location = var.location
}
# virtual Network
resource "azurerm_virtual_network" "runner_vnet" {
  name                = "runner-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.runner_rg.location
  resource_group_name = azurerm_resource_group.runner_rg.name
}
#subnet
resource "azurerm_subnet" "runner_subnet" {
  name                 = "runner-subnet"
  resource_group_name  = azurerm_resource_group.runner_rg.name
  virtual_network_name = azurerm_virtual_network.runner_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#public IP
resource "azurerm_public_ip" "runner_public_ip" {
  name                = "runner-public-ip"
  location            = azurerm_resource_group.runner_rg.location
  resource_group_name = azurerm_resource_group.runner_rg.name
  allocation_method   = "Dynamic"

}
#Network Interface
resource "azurerm_network_interface" "runner_nic" {
  name                = "runner-nic"
  location            = azurerm_resource_group.runner_rg.location
  resource_group_name = azurerm_resource_group.runner_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.runner_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.runner_public_ip.id

  }
}
# virtual Machine
resource "azurerm_linux_virtual_machine" "runner_vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.runner_rg.name
  location              = azurerm_resource_group.runner_rg.location
  size                  = "standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.runner_nic.id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }
  #Install GitHub Action runner with terraform & ansible
  custom_data = filebase64("cloud-init.yaml")
 

}





