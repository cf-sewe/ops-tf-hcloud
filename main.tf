##
# cplace Stack @ Hetzner Cloud

# cloud init
# SSH key for Ansible (except on automation server)
# dns
# firewall
# install ansible with cloud init?

# Ansible SSH keypair (will be kept in TF cloud store)
resource "tls_private_key" "ansible_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 3072
}

# # SSH public key for ansible
# resource "hcloud_ssh_key" "sewe" {
#   name       = "sewe"
#   public_key = ""
# }

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