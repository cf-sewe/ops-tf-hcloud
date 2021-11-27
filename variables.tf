variable "hcloud_token" {
  sensitive   = true
  description = "Hetzner Cloud API Token"
}

variable "hcloud_datacenter" {
  default     = "fsn1"
  description = "Hetzner Cloud location. You can list locations with 'hcloud location list'"
}
