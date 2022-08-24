resource "azurerm_resource_group" "amsdev" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "amsdev" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet_ip_segment]
}

resource "azurerm_subnet" "amsdev" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_ip_segment]
}

resource "azurerm_public_ip" "amsdev" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "amsdev" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_configuration {
    name                          = var.nic_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.amsdev.id
    subnet_id = azurerm_subnet.amsdev.id 
  }
}
resource "azurerm_network_security_group" "amsdev" {
  name                = var.nsg_name
  resource_group_name = var.resource_group_name
  location            = var.location
  #security_group_names = ["${azure_security_group.web.name}", "${azure_security_group.apps.name}"]
  security_rule {
    name                       = var.nsg_name
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"    
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
    
  }
}
resource "azurerm_network_interface_security_group_association" "amsdev" {
  network_interface_id      = azurerm_network_interface.amsdev.id
  network_security_group_id = azurerm_network_security_group.amsdev.id
}



resource "azurerm_linux_virtual_machine" "amsdev" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.amsdev.id]
  size                  = "Standard_B1s"
  admin_username        = "DevOpsJIO"
  disable_password_authentication = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "Latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  } 

   #resource "tls_private_key" "linux_key"{
   #  algorithm  = "RSA"
   #  rsa_bits   = 4096
   #}
   #resource "local_file" "linuxkey"{
   #  filename = "linuxkey.pem"
   #  content  = tls_private_key.linux_key.private_key_pem
  #} 
  # admin_ssh_key {
   #  username  = "DevOpsJIO"
   #  public_key = tls_private_key.linux_key.public_key_openssh
   #  }

   #depends_on = [  
   #   tls_private_key.linux_key   
   #]

admin_ssh_key {
    username   = "DevOpsJIO"    
    public_key = file("C://Users//Hari//amsdevvm//amsdev.pub")
  }
connection {
      host = self.public_ip_address
      user = "DevOpsJIO"
      type = "ssh"
      private_key = "${file("C://Users//Hari//amsdevvm//amsdev")}"
      timeout = "4m"
      agent = false
      }

provisioner "remote-exec" {
  inline = [ "mkdir /tmp/123", "touch /tmp/123/file.txt" ]
  
}
  





  
  #provisioner "local-exec" {
  #  command = "echo ${aws_instance.testInstance.public_ip} >> public_ip.txt"
  #}
  #provisioner "local-exec" {
  #  command = "echo ${azurerm_linux_virtual_machine.amsdev.name} >> public_ip.txt"
  #}
   
  #provisioner "remote-exec" {
  # inline = [
  #   "sudo -S yum install epel-release -y",
  #   "sudo yum install ansible -y",
  #]
  # connection {
  #   type = "ssh"
  #   user = "DevOpsJIO"
     #host = data.azurerm_public_ip.amsdev.public_ip_address
  #   host = self.public_ip_address
	 #private_key = file("C://Users//Hari//amsdevvm//amsdev")
  #   private_key = file("C://Users//Hari//amsdevvm//amsdev")
  # }
}  





output "public_ip_address_id" {
    value = azurerm_public_ip.amsdev.id   
}

output "public_ip_address_name" {
    value = azurerm_public_ip.amsdev.name    
}
output "resource_group_name" {
    value = azurerm_resource_group.amsdev.name 
  
}
output "resource_group_id" {
    value = azurerm_resource_group.amsdev.id 
  
}
output "vm" {
   value = azurerm_linux_virtual_machine.amsdev.name
}

output "public_ip" {
    value = azurerm_public_ip.amsdev.id  
}
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.amsdev.public_ip_address
}

