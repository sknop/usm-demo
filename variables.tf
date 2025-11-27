variable "region" {
  type = string
}

variable "vpc-cidr" {
  default = "172.32.0.0/16"
  description = "The CIDR block for your VPC"
  type = string
}

variable "public-availability-zones" {
  description = "The availability zone for the public subnet"
  type = list(string)
}

variable "private-availability-zones" {
  description = "The availability zones for the private subnet"
  type = list(string)
}

variable "public-subnet-cidr" {
  description = "Public subnet CIDR"
  type = list(string)
}

variable "private-subnets-cidr" {
  description = "Private subnet CIDR"
  type = list(string)
}

variable "my-ip" {
  description = "IP Address from which to get access to the public subnet in CIDR format (usually /32)"
  type = string
  default = ""
}

variable "jumphost-instance-type" {
  description = "AWS instance type used for jumphost instance"
  default = "t3.small"
}

variable "bootcamp-key-name" {
  default = "bootcamp-key"
  description = "Name of key in AWS"
  type = string
}

variable "owner_email" {
  type = string
}

variable "owner_name" {
  type = string
}

variable "username" {
  type = string
  description = "Name used to clarify VPC, jump host and key name"
}


variable "confluent_api_secret" {
  default = ""
}
variable "confluent_api_key" {
  default = ""
}

