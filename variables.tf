variable "hcloud_token" {
  sensitive   = true
  description = "Hetzner Cloud API Token"
}

variable "hcloud_datacenter" {
  default     = "fsn1"
  description = "Hetzner Cloud location. You can list locations with 'hcloud location list'"
}


variable "hcloud_datacenter_alt" {
  default     = "nbg1"
  description = "Alternative hcloud location for active-passive second site."
}

variable "cplace_node_count" {
  default     = "1"
  description = "Specifies the number of cplace Nodes for HA"
}

variable "cplace_enable_active_passive" {
  default     = false
  description = "Whether to enable active-passive mode"
}

variable "cplace_server_type" {
  default     = "cpx21"
  description = "Defines the cplace server type."
}
