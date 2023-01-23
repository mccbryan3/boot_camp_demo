data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "jenkins_demo" {
  name = var.resource_group_name
}

resource "random_password" "main" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}


resource "azurerm_public_ip" "main" {
  name                = "${var.instance_name}-public-ip-01"
  location            = data.azurerm_resource_group.jenkins_demo.location
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}


resource "azurerm_network_security_group" "main" {
  name                = "${var.instance_name}-sg-01"
  location            = data.azurerm_resource_group.jenkins_demo.location
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "jenkins_demo_ssh" {
  name                       = "SSH"
  priority                   = 1001
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = var.my_ip
  destination_address_prefix = "*"
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name
  network_security_group_name = azurerm_network_security_group.main.name
}


resource "azurerm_network_security_rule" "jenkins_demo_web" {
    name                       = "AllowInbound8080"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
    resource_group_name = data.azurerm_resource_group.jenkins_demo.name
    network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_network_interface" "main" {
  name                = "${var.instance_name}-nic-01"
  location            = data.azurerm_resource_group.jenkins_demo.location
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name

  ip_configuration {
    name                          = "${var.instance_name}-ip-01"
    subnet_id                     = data.azurerm_subnet.jenkins_demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
  tags = var.tags
  depends_on = [
    data.azurerm_subnet.jenkins_demo
  ]   
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.instance_name
  location            = data.azurerm_resource_group.jenkins_demo.location
  resource_group_name = data.azurerm_resource_group.jenkins_demo.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.instance_name}-001-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.instance_name
    admin_username = var.admin_user
    admin_password = resource.random_password.main.result
    custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = var.ssh_pub_key
      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
    }
  }

  tags = var.tags
}


# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = templatefile("azure-user-data.sh",
    {
      # Var content
    }
  )
}
