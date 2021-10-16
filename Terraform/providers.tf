terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

provider "openstack" {
  user_name = var.openstack_username
  password  = var.openstack_password
  auth_url  = "https://cscloud.lnu.se:5000/v3"
  user_domain_name = "Default"
  project_domain_name = "Default"
}
