output "jump_server_ipv4" {
  value       = hcloud_server.jump.ipv4_address
  description = "IPv4 address of the jump server"
}

output "bootstrap_ssh_key" {
  value       = tls_private_key.bootstrap_ssh.private_key_pem
  description = "Private bootstrapping SSH key"
  sensitive   = true
}

# output "cplace_primary_ipv4" {
#   value       = hcloud_floating_ip.cplace_primary_ipv4.*.ip_address
#   description = "Primary IPv4 address of the cplace service"
# }

# output "cplace_primary_ipv6" {
#   value       = hcloud_floating_ip.cplace_primary_ipv6.*.ip_address
#   description = "Primary IPv6 address of the cplace service"
# }
