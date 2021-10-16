# Network and security groups.

# Network, Subnet, Router, and Interface.
resource "openstack_networking_network_v2" "network_1" {
  name           = "AcmeLAN"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.20.0/24"
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "AcmeRouter"
  admin_state_up      = true
  external_network_id = "fd401e50-9484-4883-9672-a2814089528c"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

# Security groups
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "SSH"
  description = "SSH"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "secgroup_2" {
  name        = "SSHHTML"
  description = "SSH and HTML"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
