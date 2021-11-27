output "ipv4_address" {
  value       = hcloud_server.jump.ipv4_address
  description = "IPv4 address of the jump server"
}
