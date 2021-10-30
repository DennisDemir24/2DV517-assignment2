# Files generated to be used by Ansible

# Ansible ansible.cfg
resource "local_file" "ansiblecfg" {

  depends_on = [
    openstack_compute_floatingip_associate_v2.fip_3
  ]
  content = <<EOT
[defaults]
inventory	= ./inventory
remote_user = ubuntu
private_key_file = ${var.ssh_key_private}
  EOT
  filename = "../Ansible/ansible.cfg"
}

# Ansible inventory
# TODO: look into some form of loop to proof against other amounts of instances!
resource "local_file" "inventory" {

  depends_on = [
    openstack_compute_floatingip_associate_v2.fip_3
  ]
  content = <<EOT
# [ac_server]
# ac ansible_host=${openstack_networking_floatingip_v2.fip_2.address}

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

[prometheus]
prom ansible_host=${openstack_compute_instance_v2.fs[0].access_ip_v4}

[all:vars]
# ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@${openstack_networking_floatingip_v2.fip_2.address}"'
ansible_python_interpreter=/usr/bin/python3
  EOT
  # filename = "${openstack_compute_instance_v2.ac[0].access_ip_v4}:./etc/ansible/hosts"
  filename = "../Ansible/inventory"
}
