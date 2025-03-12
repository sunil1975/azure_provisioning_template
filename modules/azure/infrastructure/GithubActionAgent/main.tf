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
  name                  = "github-runner-vm"
  resource_group_name   = azurerm_resource_group.runner_rg.name
  location              = azurerm_resource_group.runner_rg.location
  size                  = "standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.runner_nic.id]
  admin_ssh_key {
    username   = "adminuser"
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

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl",
      "mkdir action-runner && cd action-runner",
      "curl -o action-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.285.1/action-runner-linux-x64-2.285.1.tar.gz",
      "tar xzf ./action-runner.tar.gz",
      "./config.sh --url https://github.com/${var.github_owner}/${var.github_repo} --token ${var.github_token} --name ${var.runner_name} --unattended",
      "./run.sh",
      #Terrafrom Insallation   
      "sudo apt-get install unzip",
      "wget https://releases.hashicorp.com/terraform/1.11.1/terraform_1.11.1_linux_amd64.zip",
      "unzip terraform_1.11.1_linux_amd64.zip",
      "sudo mv terraform /usr/local/bin/",
      "terraform --version",
      #Terrafrunt Installation
      "curl -L https://github.com/gruntwork-io/terragrunt/release/download/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt",
      "sudo chmod +x /usr/local/bin/terragrunt",
      #Azure Cli installation
      "curl -sL https://aks.ms/installAzureCLIDev | bash",
      #Install kubectl
      "az aks install-cli",


      # Ansible Installation
      "sudo apt install ansible",
      "ansible --version"

    ]

    connection {
      type        = "ssh"
      host        = azurerm_public_ip.runner_public_ip.ip_address
      user        = "adminuser"
      private_key = file(var.ssh_key_path)
    }
  }

}





