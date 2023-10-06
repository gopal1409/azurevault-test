


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env}-${var.rg_name}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnnet" {
  name = "${var.env}-${var.rg_name}-subnet"
  #location = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.env}-${var.rg_name}-publicip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "ni" {
  name                = "${var.env}-${var.rg_name}-ni"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal-ip"
    subnet_id                     = azurerm_subnet.subnnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

##we will create an linux vm
locals {
  webvm_custom_data = <<CUSTOM_DATA
#!/bin/sh
sudo apt-get update -y
sudo apt install apache2 -y
sudo echo "Welcome to test - WebVM App1 - VM Hostname: $(hostname)" > /var/www/html/index.html
CUSTOM_DATA
}

resource "azurerm_linux_virtual_machine" "web_linux_vm" {

  name                            = "${var.env}-${var.rg_name}-vm"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = azurerm_key_vault_secret.kv-vm-secret.value
  disable_password_authentication = false

  network_interface_ids           = [azurerm_network_interface.ni.id]
  /*admin_ssh_key {
    username = "azureuser"
    ##path.module is the root directory it is like callign your current directory
    public_key = file("${path.module}/ssh-keys/terraform-azure.pem.pub")
  }*/
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  ###to execute the boot strap script
  custom_data = base64encode(local.webvm_custom_data)
  #if you boot strap data is in inside a file in shell format
  #custom_data = filebase64("${path.module}/app/app.sh")
}