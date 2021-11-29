output "jump_server_ipv4p" {
  value       = hcloud_server.jump.ipv4_address
  description = "IPv4 address of the jump server"
}
