##
# Jump Server / Ansible Server

data "template_file" "user-data-jump" {
  template = file("${path.module}/cloud-init/user-data-jump.yml.tpl")
  vars = {
    ansible_public_key = tls_private_key.ansible_ssh.public_key_openssh
    ansible_private_key = base64encode(tls_private_key.ansible_ssh.private_key_pem)
  }
}

data "template_cloudinit_config" "jump-server" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user-data-jump.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/cloud-init/install-jump.sh")
  }
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

resource "hcloud_server" "jump" {
  name              = "jump"
  backups           = false
  delete_protection = false
  image             = "rocky-8"
  location          = var.hcloud_datacenter
  server_type       = "cpx11"
  user_data         = data.template_cloudinit_config.jump-server.rendered
  ssh_keys          = [hcloud_ssh_key.bootstrap.id]
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