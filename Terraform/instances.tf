# Instance resources. 

# Load balancer (?)
resource "openstack_compute_instance_v2" "lb_1" {
  name      = "AcmeLB_1"
  image_id  = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f"
  flavor_name = "c1-r05-d10"
  key_pair  = var.openstack_keypair_name
  availability_zone = "Education"
  security_groups = [ "SSHHTML" ]

  network {
    name = "AcmeLAN"
  }
}

# 3 WP servers
resource "openstack_compute_instance_v2" "wp" {
  name      = "AcmeWP_${count.index}"
  image_id  = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f"
  flavor_name = "c1-r2-d20"
  key_pair  = var.openstack_keypair_name
  availability_zone = "Education"
  count = 3
  security_groups = [ "SSHHTML" ]

  network {
    name = "AcmeLAN"
  }
}

# 2 Db servers (master-slave replication ?)
resource "openstack_compute_instance_v2" "db" {
  name      = "AcmeDB_${count.index}"
  image_id  = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f"
  flavor_name = "c1-r2-d10"
  key_pair  = var.openstack_keypair_name
  availability_zone = "Education"
  count = 2
  security_groups = [ "SSH" ]

  network {
    name = "AcmeLAN"
  }
}

# File server
resource "openstack_compute_instance_v2" "fs" {
  name      = "AcmeFS_${count.index}"
  image_id  = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f"
  flavor_name = "c1-r2-d10"
  key_pair  = var.openstack_keypair_name
  availability_zone = "Education"
  count = 1
  security_groups = [ "SSH" ]

  network {
    name = "AcmeLAN"
  }
}

# Set floating IP to the LB server
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.lb_1.id
}
