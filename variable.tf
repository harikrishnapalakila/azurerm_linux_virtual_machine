provider "azurerm" {
  features {

  }

}
#hola como tassh

variable "resource_group_name" { default = "cmsdevrg" }
variable "location" { default = "centralindia" }


variable "vnet_name" { default = "cmsdevvnet" }
variable "vnet_ip_segment" { default = "11.0.0.0/16" }


variable "subnet_name" { default = "cmsdevsubnet" }
variable "subnet_ip_segment" { default = "11.0.1.0/24" }


variable "public_ip_name" { default = "cmsdevpublic" }
#variable "public_ip_address" {}
variable "nic_name" { default = "cmsdevnic" }
variable "nsg_name" { default = "cmsdevnsg" }

variable "vm_name" { default = "cmsdevm" }


#variable "vm_name" { 
#    type = list(string)    
#    default = [ "cmsdevm01", "cmsdevm02", "cmsdevm03" ]
#}



