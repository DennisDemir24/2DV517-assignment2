variable "openstack_username" {
  type = string
  description = "Your openstack username"
}

variable "openstack_password" {
  type = string
  description = "Your openstack password"
}

variable "openstack_pubkey" {
  type = string
  description = "Your openstack public key"
}

variable "openstack_keypair_name" {
  type = string
  description = "Your openstack keypair name"
}

variable "ssh_key_private" {
  type = any
  description = "ssh pem file"
}