provider "selectel" {
  username    = var.username
  password    = var.password
  domain_name = var.domain_name
}

provider "openstack" {
  user_name           = var.username
  password            = var.password
  tenant_id           = var.project_id
  project_domain_name = var.domain_name
  user_domain_name    = var.domain_name
  auth_url            = var.auth_url
  region              = var.region
}

resource "openstack_compute_keypair_v2" "admin_ssh_pubkey" {
  count      = length(var.ssh_keypairs)

  name       = var.ssh_keypairs[count.index].name
  public_key = var.ssh_keypairs[count.index].key

  region     = var.region
}
