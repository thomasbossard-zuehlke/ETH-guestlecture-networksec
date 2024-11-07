variable "resource_group_location" {
  type        = string
  default     = "SwitzerlandNorth"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rgETHlecture"
  description = "Name of the resource group."
}
variable "username" {
  type        = string
  default     = "ethuser"
  description = "Username"
}
variable "ssh_pub_key" {
  type        = string
  default     = ""
  description = "SSH public key"
}