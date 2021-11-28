##
# Jump Server / Ansible Server

data "template_file" "script" {
  template = file("${path.module}/cloud-init/user-data-jump.yml.tpl")
  vars = {
    ansible_public_key = tls_private_key.ansible_ssh_key.public_key_openssh
  }
}
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.script.rendered
  }
  # part {
  #   content_type = "text/x-shellscript"
  #   content      = "baz"
  # }
}

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
  user_data         = data.template_cloudinit_config.config.rendered
  firewall_ids      = [hcloud_firewall.jump-server.id]
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