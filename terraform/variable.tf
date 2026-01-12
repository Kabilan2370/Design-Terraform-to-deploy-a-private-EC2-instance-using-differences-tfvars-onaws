variable "aws_region" {}
variable "env" {}

variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "instance_type" {}
variable "key_name" {}

variable "strapi_port" {
  default = 1337
}
