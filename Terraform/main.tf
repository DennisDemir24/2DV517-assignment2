resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "TF_key"
  public_key = var.openstack_pubkey
}
