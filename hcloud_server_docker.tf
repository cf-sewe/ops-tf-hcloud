##
# docker Server

data "template_file" "user-data-docker" {
  template = file("${path.module}/cloud-init/user-data-docker.yml.tpl")
  vars = {
    ansible_public_key = tls_private_key.ansible_ssh.public_key_openssh
  }
}

data "template_cloudinit_config" "docker" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user-data-docker.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/cloud-init/install-docker.sh")
  }
}

# docker firewall blocking in/out internet access, allow inbound HTTP traffic
resource "hcloud_firewall" "docker" {
  name = "doccker"
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
    port      = 80
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow HTTP"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = 443
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow HTTPS"
  }
  rule {
    direction = "out"
    protocol  = "tcp"
    port      = 53
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow DNS (TCP)"
  }
  rule {
    direction = "out"
    protocol  = "udp"
    port      = 53
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow DNS (UDP)"
  }
  rule {
    direction = "out"
    protocol  = "udp"
    port      = 123
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow NTP"
  }
  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = 636
    destination_ips = [var.ldaps_ipv4_address]
    description     = "Allow LDAPS"
  }
  rule {
    direction = "out"
    protocol  = "tcp"
    port      = 465
    # Note: Amazon SES supports dedicated IPs for 25$ per month.
    # Then we could restrict the destination to improve security.
    destination_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow SMTP (Amazon SES)"
  }
}

resource "hcloud_server" "docker" {
  name              = "docker"
  backups           = false
  delete_protection = false
  image             = "rocky-8"
  location          = var.hcloud_datacenter
  server_type       = var.hcloud_servertype_docker
  user_data         = data.template_cloudinit_config.docker.rendered
  ssh_keys          = [hcloud_ssh_key.bootstrap.id]
  firewall_ids      = [hcloud_firewall.docker.id]
  network {
    network_id = hcloud_network.network.id
    ip         = "10.77.1.4"
  }
  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}
