##
# cplace Stack @ Hetzner Cloud

# cloud init
# SSH key for Ansible (except on automation server)
# dns
# firewall
# install ansible with cloud init?

# Ansible SSH keypair
resource "tls_private_key" "ansible_ssh" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

# Temporary ssh key valid during bootstrapping
resource "tls_private_key" "bootstrap_ssh" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

# SSH public key for bootstrapping (also avoids root password generation)
# Note: will be removed by Ansible
resource "hcloud_ssh_key" "bootstrap" {
  name       = "bootstrap"
  public_key = tls_private_key.bootstrap_ssh.public_key_openssh
}

# Private network for internal communication
resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.77.0.0/16"
}
resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.77.1.0/24"
}