# ================================
# GROUPE DE RESSOURCES (étape 7)
# ================================
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# ================================
# RÉSEAU VIRTUEL (étape 8)
# ================================
resource "azurerm_virtual_network" "main" {
  name                = "vnet-cr460"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-cr460"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ================================
# MACHINE VIRTUELLE (étape 9)
# ================================
resource "azurerm_network_interface" "main" {
  name                = "nic-cr460"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-cr460"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# ================================
# CONTENEUR DOCKER / ACI (étape 10)
# ================================
resource "azurerm_container_group" "main" {
  name                = "aci-cr460"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "helloworld"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# ================================
# OUTPUTS (facilite les captures)
# ================================
output "container_ip" {
  description = "IP publique du conteneur Docker"
  value       = azurerm_container_group.main.ip_address
}