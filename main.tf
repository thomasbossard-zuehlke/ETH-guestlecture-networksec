# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

# Virtual Network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet 1
resource "azurerm_subnet" "Subnet1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Ubuntu1: Create Network Security Group and rule
resource "azurerm_network_security_group" "NSG1" {
  name                = "Ubuntu1NetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Ubuntu1: Create public IPs
resource "azurerm_public_ip" "PublicIP1" {
  name                = "Ubuntu1PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Ubuntu1: Create network interface
resource "azurerm_network_interface" "Nic1" {
  name                = "Ubuntu1NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "Ubuntu1nic_configuration"
    subnet_id                     = azurerm_subnet.Subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PublicIP1.id
  }
}

# Ubuntu1: Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "assoc1" {
  network_interface_id      = azurerm_network_interface.Nic1.id
  network_security_group_id = azurerm_network_security_group.NSG1.id
}

# Ubuntu1: Create virtual machine
resource "azurerm_linux_virtual_machine" "Ubuntu1" {
  name                  = "Ubuntu1VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.Nic1.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "Ubuntu1"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_pub_key
  }
}

# Subnet 2
resource "azurerm_subnet" "Subnet2" {
  name                 = "subnet-2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Ubuntu1: Create Network Security Group and rule
resource "azurerm_network_security_group" "NSG2" {
  name                = "Ubuntu2NetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyInboundAny"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

# Ubuntu2: Create public IP
resource "azurerm_public_ip" "PublicIP2" {
  name                = "Ubuntu2PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Ubuntu2: Create network interface
resource "azurerm_network_interface" "Nic2" {
  name                = "Ubuntu2NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "Ubuntu2nic_configuration"
    subnet_id                     = azurerm_subnet.Subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PublicIP2.id
  }
}

# Ubuntu2: Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "assoc2" {
  network_interface_id      = azurerm_network_interface.Nic2.id
  network_security_group_id = azurerm_network_security_group.NSG2.id
}

# Ubuntu2: Create virtual machine
resource "azurerm_linux_virtual_machine" "Ubuntu2" {
  name                  = "Ubuntu2VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.Nic2.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "Ubuntu2"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_pub_key
  }
}