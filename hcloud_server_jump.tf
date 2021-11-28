##
# Jump Server / Ansible Server

# All traffic toward internet is permitted.
resource "hcloud_firewall" "jump-server" {
  name = "jump-server"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow ICMP"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow SSH from company IPs"
  }
}

# TODO: remove temporary allow root access via personal ssh key
resource "hcloud_server" "jump" {
  name              = "jump"
  backups           = false
  delete_protection = false
  image             = "rocky-8"
  location          = var.hcloud_datacenter
  server_type       = "cx11"
  user_data         = file("cloud-init/user-data-jump.yml")
  firewall_ids      = [hcloud_firewall.jump.id]
  network {
    network_id = hcloud_network.network.id
    ip         = "10.77.1.2"
  }
  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}

# resource "hcloud_rdns" "master" {
#   server_id  = hcloud_server.test1.id
#   ip_address = hcloud_server.test1.ipv4_address
#   dns_ptr    = "test.cplace.io"
# }