##
# cplace Server

data "template_file" "user-data-cplace" {
  template = file("${path.module}/cloud-init/user-data-cplace.yml.tpl")
  vars = {
    ansible_public_key = tls_private_key.ansible_ssh.public_key_openssh
  }
}

data "template_cloudinit_config" "cplace" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user-data-cplace.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/cloud-init/install-cplace.sh")
  }
}

# cplace firewall blocking in/out internet access, allow inbound HTTP traffic
resource "hcloud_firewall" "cplace" {
  name = "cplace"
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
}

# place cplace on different physical servers
resource "hcloud_placement_group" "cplace_spread" {
  name = "cplace-spread"
  type = "spread"
}

# primary site, always used
resource "hcloud_server" "cplace" {
  for_each           = var.cplace_servers
  name               = each.value.name
  backups            = false
  delete_protection  = false
  image              = "rocky-8"
  location           = each.value.location
  server_type        = each.value.server_type
  user_data          = data.template_cloudinit_config.cplace.rendered
  ssh_keys           = [hcloud_ssh_key.bootstrap.id]
  firewall_ids       = [hcloud_firewall.cplace.id]
  placement_group_id = hcloud_placement_group.cplace_spread.id
  network {
    network_id = hcloud_network.network.id
    ip         = each.value.ip
  }
  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}

# Floating IPv4 address, will be used in active-pasive mode
# It will be assigned by default to the site1
# TODO: in cplace HA mode, loadbalancer must be used instead
# resource "hcloud_floating_ip" "cplace_primary_ipv4" {
#   count         = var.cplace_enable_active_passive ? 1 : 0
#   name          = "cplace-primary-ipv6"
#   description   = "Primary IPv4 address of the cplace service"
#   type          = "ipv4"
#   home_location = var.hcloud_datacenter
#   server_id     = hcloud_server.cplace_site1[0].id
# }

# resource "hcloud_floating_ip" "cplace_primary_ipv6" {
#   count         = var.cplace_enable_active_passive ? 1 : 0
#   name          = "cplace-primary-ipv6"
#   description   = "Primary IPv6 address of the cplace service"
#   type          = "ipv6"
#   home_location = var.hcloud_datacenter
#   server_id     = hcloud_server.cplace_site1[0].id
# }
