variable "region" {
  default = "ca-central-1"
}

variable "profile" {
  description = "AWS profile to use for authentication"
  default = "default"
}

variable "ssh_key" {
  description = "SSH key name to use for accessing the ec2 instance"
}

variable "remote_state_bucket" {
  description = "VPC to place new instance in"
}

variable "remote_state_key" {
  description = "Subnet to place new instance in"
}
