##
# Forward Proxy (Squid)

data "template_file" "user-data-fwd" {
  template = file("${path.module}/cloud-init/user-data-fwd.yml.tpl")
  vars = {
    ansible_public_key = tls_private_key.ansible_ssh.public_key_openssh
  }
}

data "template_cloudinit_config" "fwd" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user-data-fwd.rendered
  }
}

# All inbound traffic is prohibited.
# All traffic outgoing to internet is permitted.
resource "hcloud_firewall" "fwd" {
  name = "fwd"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow ICMP"
  }
}

resource "hcloud_server" "fwd" {
  name              = "fwd"
  backups           = false
  delete_protection = false
  image             = "rocky-8"
  location          = var.hcloud_datacenter
  server_type       = "cxp11"
  user_data         = data.template_cloudinit_config.fwd.rendered
  ssh_keys          = [hcloud_ssh_key.bootstrap.id]
  firewall_ids      = [hcloud_firewall.fwd.id]
  network {
    network_id = hcloud_network.network.id
    ip         = "10.77.1.3"
  }
  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}
