# Instance resources. 
# access_ip_v4 = local IP

# Ansible control server(?)
resource "openstack_compute_instance_v2" "ac" {
  name      = "AcmeAC_${count.index}"
  image_id  = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f"
  flavor_name = "c1-r05-d10"
  key_pair  = var.openstack_keypair_name
  availability_zone = "Education"
  security_groups = [ "SSH" ]
  count = 1

  depends_on = [
    openstack_networking_router_v2.router_1
  ]

  network {
    name = "AcmeLAN"
    fixed_ip_v4 = "192.168.20.10"
  }

# This doesn't work
  /*provisioner "remote-exec" {
    inline = [
      "sudo touch helloworld.md"
    ]

    connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    private_key = file(var.ssh_key_private)
    host        = "${openstack_compute_instance_v2.ac[0].access_ip_v4}"
    }
  }
  */
}

# TODO: look into some form of loop to proof against other amounts of instances!
resource "local_file" "hosts" {
  content = <<EOT

  [ac server]
  lb ansible_host=${openstack_compute_instance_v2.ac[0].access_ip_v4}

  [nginx]
  lb ansible_host=${openstack_compute_instance_v2.lb[0].access_ip_v4}
  
  [wordpress]
  wp1 ansible_host=${openstack_compute_instance_v2.wp[0].access_ip_v4}
  wp2 ansible_host=${openstack_compute_instance_v2.wp[1].access_ip_v4}
  wp3 ansible_host=${openstack_compute_instance_v2.wp[2].access_ip_v4}

  [databaseMS]
  db1 ansible_host=${openstack_compute_instance_v2.db[0].access_ip_v4}

  [databaseSL]
  db2 ansible_host=${openstack_compute_instance_v2.db[1].access_ip_v4}

  [fileserver]
  fs ansible_host=${openstack_compute_instance_v2.fs[0].access_ip_v4}

  [all:vars]
  ansible_python_interpreter=/usr/bin/python3"
  EOT
  # filename = "${openstack_compute_instance_v2.ac[0].access_ip_v4}:./etc/ansible/hosts"
  filename = "../Ansible/inventory"
}

# Load balancer (?)
resource "openstack_compute_instance_v2" "lb" {
  name      = "AcmeLB_${count.index}"
  image_id  = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f"
  flavor_name = "c1-r05-d10"
  key_pair  = var.openstack_keypair_name
  availability_zone = "Education"
  security_groups = [ "SSHHTML" ]
  count = 1

  depends_on = [
    openstack_networking_router_v2.router_1,
    openstack_compute_instance_v2.wp[0]
  ]

  network {
    name = "AcmeLAN"
    fixed_ip_v4 = "192.168.20.11"
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

  depends_on = [
    openstack_networking_router_v2.router_1,
    openstack_compute_instance_v2.db[0]
  ]

  network {
    name = "AcmeLAN"
    fixed_ip_v4 = "192.168.20.${count.index + 20}"
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

  depends_on = [
    openstack_networking_router_v2.router_1,
    openstack_compute_instance_v2.fs
  ]

  network {
    name = "AcmeLAN"
    fixed_ip_v4 = "192.168.20.${count.index + 30}"
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

  depends_on = [
    openstack_networking_router_v2.router_1,
    openstack_compute_instance_v2.lb
  ]

  network {
    name = "AcmeLAN"
    fixed_ip_v4 = "192.168.20.40"
  }
}

# Set floating IP to the LB server
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
  depends_on = [
    openstack_networking_router_v2.router_1,
    openstack_compute_instance_v2.lb
  ]
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.lb[0].id
  depends_on = [
    openstack_networking_floatingip_v2.fip_1,
    openstack_compute_instance_v2.lb
  ]
}

# Set floating IP to the AC server
resource "openstack_networking_floatingip_v2" "fip_2" {
  pool = "public"
  depends_on = [
    openstack_networking_router_v2.router_1,
    openstack_compute_instance_v2.ac
  ]
}

resource "openstack_compute_floatingip_associate_v2" "fip_2" {
  floating_ip = openstack_networking_floatingip_v2.fip_2.address
  instance_id = openstack_compute_instance_v2.ac[0].id
  depends_on = [
    openstack_networking_floatingip_v2.fip_2,
    openstack_compute_instance_v2.ac
  ]
}

