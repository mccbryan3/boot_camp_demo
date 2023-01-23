variable "location" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "admin_user" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
  
}

variable "my_ip" {
  type = string
}

variable "ssh_pub_key" {
  type = string
}